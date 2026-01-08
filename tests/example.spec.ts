import { test, expect } from "@playwright/test";

test.describe("Top Page Visual Tests", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/", { waitUntil: "domcontentloaded" });
    await page.locator('#app').waitFor({ state: "visible" });
    await page.waitForTimeout(1000);
  });

  test("should render the main page correctly", async ({ page }) => {
    await expect(page).toHaveScreenshot("top-page.png", {
      fullPage: true,
    });
  });
});
