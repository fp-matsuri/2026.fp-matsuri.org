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

test.describe("Sponsors Page Visual Tests", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/sponsors/");
    await page.locator("body").waitFor({ state: "visible" });
    await page.waitForTimeout(1000);
  });

  test("should render the sponsors page correctly", async ({ page }) => {
    await expect(page).toHaveScreenshot("sponsors-page.png", {
      fullPage: true,
    });
  });
});

test.describe("Schedule Page Visual Tests", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/schedule/");
    await page.locator("body").waitFor({ state: "visible" });
    await page.waitForTimeout(1000);
  });

  test("should render the schedule page correctly", async ({ page }) => {
    await expect(page).toHaveScreenshot("schedule-page.png", {
      fullPage: true,
    });
  });
});

test.describe("Sponsor Popover Visual Tests", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/");
    await page.locator("body").waitFor({ state: "visible" });
    await page.waitForTimeout(1000);
  });

  test("should render each sponsor popover correctly", async ({ page }) => {
    const buttons = page.locator(
      'button[popovertarget^="sponsor-"]:not([popovertargetaction="hide"])',
    );
    const count = await buttons.count();
    expect(count).toBeGreaterThan(0);

    for (let i = 0; i < count; i++) {
      const button = buttons.nth(i);
      const popoverId = await button.getAttribute("popovertarget");
      if (!popoverId) continue;

      await button.click();
      const popover = page.locator(`#${popoverId}`);
      await expect(popover).toBeVisible();
      await page.waitForTimeout(300);

      await expect(popover).toHaveScreenshot(`popover-${popoverId}.png`);

      await page.keyboard.press("Escape");
      await expect(popover).toBeHidden();
    }
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
