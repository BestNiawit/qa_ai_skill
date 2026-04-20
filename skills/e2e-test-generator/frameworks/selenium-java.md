# Framework Pattern — Selenium + Java + TestNG

> ใช้กฎ 4 ข้อเดียวกับ Playwright (POM + advanced XPath + unique/shared locators + text-as-const)

---

## Project Layout

```
<project>/
├── pom.xml
├── testng.xml
├── src/
│   ├── main/java/com/<org>/
│   │   ├── pages/
│   │   │   ├── BasePage.java
│   │   │   ├── LoginPage.java
│   │   │   └── <Feature>Page.java
│   │   ├── locators/
│   │   │   └── CommonLocators.java       ← shared XPath patterns
│   │   ├── labels/
│   │   │   ├── Labels.java
│   │   │   └── <Feature>Labels.java
│   │   ├── data/
│   │   │   └── UiTestData.java
│   │   └── config/
│   │       └── Environments.java
│   └── test/java/com/<org>/
│       └── tests/<feature>/TC_<ID>Test.java
```

---

## Dependencies (`pom.xml` excerpt)

```xml
<dependencies>
  <dependency>
    <groupId>org.seleniumhq.selenium</groupId>
    <artifactId>selenium-java</artifactId>
    <version>4.20.0</version>
  </dependency>
  <dependency>
    <groupId>org.testng</groupId>
    <artifactId>testng</artifactId>
    <version>7.10.2</version>
  </dependency>
  <dependency>
    <groupId>io.github.bonigarcia</groupId>
    <artifactId>webdrivermanager</artifactId>
    <version>5.8.0</version>
  </dependency>
</dependencies>
```

---

## Labels — constant class

```java
// src/main/java/com/org/labels/Labels.java
package com.org.labels;

public final class Labels {
  private Labels() {}

  public static final String SAVE = "บันทึก";
  public static final String CANCEL = "ยกเลิก";
  public static final String CONFIRM = "ยืนยัน";
  public static final String LOGIN_SUBMIT = "เข้าสู่ระบบ";
  // ...
}
```

```java
// src/main/java/com/org/labels/LoginLabels.java
package com.org.labels;

public final class LoginLabels {
  private LoginLabels() {}
  public static final String INVALID_CREDENTIALS = "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง";
}
```

---

## Shared locators — utility class

```java
// src/main/java/com/org/locators/CommonLocators.java
package com.org.locators;

import org.openqa.selenium.By;

public final class CommonLocators {
  private CommonLocators() {}

  public static By buttonByLabel(String label) {
    return By.xpath(String.format(
      "//button[normalize-space()='%s'] | //button[.//*[normalize-space()='%s']]",
      label, label));
  }

  public static By dialogByTitle(String title) {
    return By.xpath(String.format(
      "//*[@role='dialog' and .//*[self::h1 or self::h2 or self::h3][normalize-space()='%s']]",
      title));
  }

  public static By menuItem(String label) {
    return By.xpath(String.format(
      "//nav//a[.//span[normalize-space()='%s']]", label));
  }

  public static By tableRowByCell(String cellText) {
    return By.xpath(String.format(
      "//tbody//tr[.//td[normalize-space()='%s']]", cellText));
  }

  public static By alertMessage(String text) {
    return By.xpath(String.format(
      "//*[@role='alert' and contains(normalize-space(),'%s')]", text));
  }
}
```

---

## Base Page

```java
// src/main/java/com/org/pages/BasePage.java
package com.org.pages;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.By;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;

public abstract class BasePage {
  protected final WebDriver driver;
  protected final WebDriverWait wait;

  protected BasePage(WebDriver driver) {
    this.driver = driver;
    this.wait = new WebDriverWait(driver, Duration.ofSeconds(15));
  }

  protected WebElement waitVisible(By locator) {
    return wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
  }

  protected WebElement waitClickable(By locator) {
    return wait.until(ExpectedConditions.elementToBeClickable(locator));
  }

  protected void click(By locator) { waitClickable(locator).click(); }

  protected void type(By locator, String text) {
    WebElement el = waitVisible(locator);
    el.clear();
    el.sendKeys(text);
  }

  public boolean isVisible(By locator) {
    try { return waitVisible(locator).isDisplayed(); }
    catch (Exception e) { return false; }
  }
}
```

---

## Page class — pattern

```java
// src/main/java/com/org/pages/LoginPage.java
package com.org.pages;

import com.org.labels.Labels;
import com.org.locators.CommonLocators;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class LoginPage extends BasePage {
  // Page-specific (unique attr)
  private final By usernameInput = By.xpath("//input[@data-test-id='input-username']");
  private final By passwordInput = By.xpath("//input[@data-test-id='input-password']");

  // Shared (reuse CommonLocators)
  private final By submitButton = CommonLocators.buttonByLabel(Labels.LOGIN_SUBMIT);

  public LoginPage(WebDriver driver) { super(driver); }

  public void open() { driver.get("/login"); }

  public void login(String username, String password) {
    open();
    type(usernameInput, username);
    type(passwordInput, password);
    click(submitButton);
  }
}
```

**Rules (Java-specific):**
- `private final By` — immutable locator field
- shared locator → `CommonLocators.xxx(label)` ที่รับ constant จาก `Labels.XXX`
- ห้าม `Thread.sleep()` — ใช้ `WebDriverWait`
- ห้ามใช้ `By.xpath("(//button)[2]")` — ให้ refactor หา unique attribute

---

## Test — TestNG pattern

```java
// src/test/java/com/org/tests/login/TC_LOGIN_001Test.java
package com.org.tests.login;

import com.org.data.UiTestData;
import com.org.pages.LoginPage;
import com.org.pages.HomePage;
import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

public class TC_LOGIN_001Test {
  private WebDriver driver;
  private LoginPage loginPage;
  private HomePage homePage;

  @BeforeMethod
  public void setUp() {
    WebDriverManager.chromedriver().setup();
    driver = new ChromeDriver();
    driver.get(System.getenv().getOrDefault("BASE_URL", "https://dev.example.com"));
    loginPage = new LoginPage(driver);
    homePage = new HomePage(driver);
  }

  @Test(description = "TC_01 - Login with valid credentials")
  public void tc_01_loginSuccess() {
    var data = UiTestData.TC_LOGIN_001;
    loginPage.login(data.username(), data.password());
    Assert.assertTrue(homePage.isWelcomeVisible(), "Welcome message should be visible");
  }

  @AfterMethod
  public void tearDown() {
    if (driver != null) driver.quit();
  }
}
```

---

## Test data — record class

```java
// src/main/java/com/org/data/UiTestData.java
package com.org.data;

public final class UiTestData {
  private UiTestData() {}
  public record LoginData(String username, String password) {}

  public static final LoginData TC_LOGIN_001 = new LoginData(
    "superayodia",
    System.getenv().getOrDefault("TEST_PASSWORD", "[REDACTED]"));
}
```

---

## Commands

```bash
mvn compile
mvn test -DsuiteXmlFile=testng.xml
mvn test -Dtest=TC_LOGIN_001Test
```

---

## Notes

- Java ไม่มี template string → ใช้ `String.format("//...='%s'", label)` ใน shared locator
- `By` objects เป็น immutable + light — safe ที่จะ cache เป็น `private final`
- TestNG `@BeforeMethod` + `@AfterMethod` → fresh driver per test
- **กฎ 4 ข้อยังใช้ครบ** — XPath เหมือนเดิม, POM เหมือนเดิม, label เป็น `public static final`
