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

test.describe("Timetable Page Tests", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/timetable/");
    await page.locator("body").waitFor({ state: "visible" });
    await page.waitForTimeout(1000);
  });

  test("should render the timetable page correctly", async ({ page }) => {
    // スピーカーアイコンは外部（fortee.jp）依存で読み込みが不安定なため
    // 比較対象から除外する
    await expect(page).toHaveScreenshot("timetable-page.png", {
      fullPage: true,
      mask: [page.locator('img[src*="fortee.jp"]')],
    });
  });

  test("should render both days with linked sessions", async ({ page }) => {
    await expect(page.locator("#day1")).toContainText("2026年7月11日（土）");
    await expect(page.locator("#day2")).toContainText("2026年7月12日（日）");

    await expect(
      page.locator('main a[href*="fortee.jp/2026fp-matsuri/proposal/"]'),
    ).toHaveCount(40);
  });
});

test.describe("Sponsor Popover Visual Tests", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/");
    await page.locator("body").waitFor({ state: "visible" });
    await page.waitForTimeout(1000);
  });

  test("should render each sponsor popover correctly", async ({ page }) => {
    // 全スポンサーの popover を1件ずつ開いて検証するため、スポンサーが増えるほど
    // 実行時間が伸びる。デフォルトの30秒では遅い CI ランナーで超過するため延長する。
    test.setTimeout(120_000);

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

      await expect(popover).toHaveScreenshot(`popover-${popoverId}.png`, {
        mask: [page.locator("iframe")],
        maxDiffPixelRatio: 0.02,
      });

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
