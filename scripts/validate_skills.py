#!/usr/bin/env python3
"""
Validate qa_ai_skill repo structure + consistency.

Checks performed:
  A. Frontmatter      — every skills/*/SKILL.md must have `name` + `description`;
                        `name` is kebab-case, matches folder, and is unique.
  B. 8 sections       — Purpose / When to Use / Inputs / Outputs / Process /
                        Quality Gate / AI Guardrails / Chain in order.
  C. Guardrails link  — each skill must link to references/ai-guardrails.md.
  D. Consistency      — deprecated severity/priority codes (P0-P3, Sev1-4) are
                        forbidden outside references/qa-standards.md.
  E. Dead links       — relative markdown links in skills/ + docs/ + references/
                        must resolve.

Exit 0 on success, 1 on any error. Warnings do not fail the build.
"""

from __future__ import annotations

import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILLS_DIR = ROOT / "skills"
DOCS_DIRS = [ROOT / "docs", ROOT / "references"]

REQUIRED_SECTIONS = [
    "1. Purpose",
    "2. When to Use",
    "3. Inputs",
    "4. Outputs",
    "5. Process",
    "6. Quality Gate",
    "7. AI Guardrails",
    "8. Chain",
]

DEPRECATED_PATTERNS = [
    (re.compile(r"\bP[0-3]\b"), "deprecated priority code (use Critical/High/Medium/Low)"),
    (re.compile(r"\bSev[1-4]\b", re.IGNORECASE), "deprecated severity code (use Critical/Major/Minor/Trivial)"),
]

# Skip deprecated-term check for lines that are clearly teaching/SDP-process context.
DEPRECATED_LINE_EXEMPT = re.compile(
    r"❌"
    r"|\blegacy\b"
    r"|\bdeprecated\b"
    r"|§\s*\d+(?:\.\d+)*\s*P\d"     # SDP process ref like "§5.3.1 P1"
    r"|P\d+/P[4-9]"                  # process slash-group with a >P3 entry → not priority
)

LINK_RE = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")
FRONTMATTER_RE = re.compile(r"\A---\n(.*?)\n---\n", re.DOTALL)
KEBAB_RE = re.compile(r"^[a-z][a-z0-9]*(-[a-z0-9]+)*$")


@dataclass
class Report:
    errors: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)

    def err(self, path: Path, msg: str) -> None:
        self.errors.append(f"{path.relative_to(ROOT)}: {msg}")

    def warn(self, path: Path, msg: str) -> None:
        self.warnings.append(f"{path.relative_to(ROOT)}: {msg}")


def parse_frontmatter(text: str) -> dict[str, str] | None:
    m = FRONTMATTER_RE.match(text)
    if not m:
        return None
    fields: dict[str, str] = {}
    current_key: str | None = None
    for raw in m.group(1).splitlines():
        if not raw.strip():
            continue
        if raw[0].isspace() and current_key:
            fields[current_key] += " " + raw.strip()
            continue
        if ":" in raw:
            k, _, v = raw.partition(":")
            current_key = k.strip()
            fields[current_key] = v.strip()
    return fields


def check_skill(skill_md: Path, seen_names: dict[str, Path], report: Report) -> None:
    text = skill_md.read_text(encoding="utf-8")
    folder = skill_md.parent.name

    # A. Frontmatter
    fm = parse_frontmatter(text)
    if fm is None:
        report.err(skill_md, "missing frontmatter block (--- ... ---)")
        return
    name = fm.get("name", "")
    desc = fm.get("description", "")
    if not name:
        report.err(skill_md, "frontmatter missing `name`")
    elif not KEBAB_RE.match(name):
        report.err(skill_md, f"frontmatter name `{name}` is not kebab-case")
    elif name != folder:
        report.err(skill_md, f"frontmatter name `{name}` != folder `{folder}`")
    elif name in seen_names:
        report.err(skill_md, f"duplicate skill name `{name}` (also in {seen_names[name].relative_to(ROOT)})")
    else:
        seen_names[name] = skill_md
    if not desc:
        report.err(skill_md, "frontmatter missing `description`")
    elif len(desc) < 40:
        report.warn(skill_md, f"description is very short ({len(desc)} chars) — add TH+EN triggers")

    # B. 8 sections in order
    headings = re.findall(r"^##\s+([^\n]+)", text, re.MULTILINE)
    idx = 0
    for want in REQUIRED_SECTIONS:
        found_at = next((i for i, h in enumerate(headings[idx:], start=idx) if h.strip().startswith(want)), -1)
        if found_at == -1:
            report.err(skill_md, f"missing or out-of-order section `## {want}`")
            return
        idx = found_at + 1

    # C. Guardrails link
    if "references/ai-guardrails.md" not in text:
        report.warn(skill_md, "no link to references/ai-guardrails.md (per SKILL-TEMPLATE checklist)")


def check_deprecated_terms(path: Path, report: Report) -> None:
    # qa-standards.md is the glossary and may mention deprecated terms as examples.
    if path.resolve() == (ROOT / "references" / "qa-standards.md").resolve():
        return
    text = path.read_text(encoding="utf-8", errors="ignore")
    for lineno, line in enumerate(text.splitlines(), start=1):
        if DEPRECATED_LINE_EXEMPT.search(line):
            continue
        for pattern, label in DEPRECATED_PATTERNS:
            if pattern.search(line):
                report.err(path, f"line {lineno}: {label} — `{line.strip()[:80]}`")


def check_links(path: Path, report: Report) -> None:
    # SKILL-TEMPLATE.md shows example paths from a hypothetical skill folder's
    # perspective — those intentionally don't resolve from repo root.
    if path.name == "SKILL-TEMPLATE.md":
        return
    text = path.read_text(encoding="utf-8", errors="ignore")
    base = path.parent
    for m in LINK_RE.finditer(text):
        target = m.group(2).strip()
        if target.startswith(("http://", "https://", "mailto:", "#")):
            continue
        # Template placeholders (e.g. {{module_id}}) aren't real paths.
        if "{{" in target or "<" in target:
            continue
        # strip in-page anchor
        file_part = target.split("#", 1)[0]
        if not file_part:
            continue
        resolved = (base / file_part).resolve()
        try:
            resolved.relative_to(ROOT)
        except ValueError:
            report.warn(path, f"link escapes repo root: `{target}`")
            continue
        if not resolved.exists():
            report.err(path, f"dead link: `{target}` → {resolved.relative_to(ROOT)}")


def main() -> int:
    report = Report()

    # Skill-level checks
    seen: dict[str, Path] = {}
    skill_files = sorted(SKILLS_DIR.glob("*/SKILL.md"))
    if not skill_files:
        print(f"error: no skills found under {SKILLS_DIR}", file=sys.stderr)
        return 1
    for s in skill_files:
        check_skill(s, seen, report)

    # Repo-wide markdown scans
    md_files: list[Path] = []
    for d in [SKILLS_DIR, *DOCS_DIRS]:
        md_files.extend(d.rglob("*.md"))
    md_files.extend(ROOT.glob("*.md"))

    for md in md_files:
        check_deprecated_terms(md, report)
        check_links(md, report)

    # Output
    if report.warnings:
        print(f"warnings ({len(report.warnings)}):")
        for w in report.warnings:
            print(f"  warn: {w}")
        print()

    if report.errors:
        print(f"errors ({len(report.errors)}):")
        for e in report.errors:
            print(f"  FAIL: {e}")
        print(f"\n{len(report.errors)} error(s). build failed.")
        return 1

    print(f"ok — {len(skill_files)} skills, {len(md_files)} markdown files checked.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
