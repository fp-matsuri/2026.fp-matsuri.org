import { test, expect } from "@playwright/test";

test.describe("Top Page Visual Tests", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/");
    await page.locator("body").waitFor({ state: "visible" });
    await page.waitForTimeout(1000);
  });

  test("should render the main page correctly", async ({ page }) => {
    await expect(page).toHaveScreenshot("top-page.png", {
      fullPage: true,
    });
  });
});

test.describe("Code of Conduct Page Visual Tests", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/code-of-conduct/");
    await page.locator("body").waitFor({ state: "visible" });
    await page.waitForTimeout(1000);
  });

  test("should render the code of conduct page correctly", async ({ page }) => {
    await expect(page).toHaveScreenshot("code-of-conduct-page.png", {
      fullPage: true,
    });
  });
});

test.describe("404 Page Visual Tests", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/404");
    await page.locator("body").waitFor({ state: "visible" });
    await page.waitForTimeout(1000);
  });

  test("should render the 404 page correctly", async ({ page }) => {
    await expect(page).toHaveScreenshot("404-page.png", {
      fullPage: true,
    });
  });
});
