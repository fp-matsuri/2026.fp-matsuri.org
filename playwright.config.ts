import { defineConfig, devices } from "@playwright/test";

/**
 * See https://playwright.dev/docs/test-configuration.
 */
export default defineConfig({
  testDir: "./tests",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: "html",
  snapshotPathTemplate:
    "{testDir}/{testFileDir}/{testFileName}-snapshots/{arg}-{projectName}{ext}",

  use: {
    baseURL: "http://localhost:1234",
    trace: "on-first-retry",
  },

  expect: {
    timeout: 5000,
    toHaveScreenshot: { maxDiffPixels: 0 },
  },

  projects: [
    {
      name: "Chromium",
      use: {
        ...devices["Desktop Chrome"],
        viewport: { width: 1440, height: 900 },
      },
    },
    {
      name: "Mobile Safari",
      use: { ...devices["iPhone 12"] },
    },
  ],

  webServer: {
    command: "npm run preview",
    url: "http://localhost:1234",
    reuseExistingServer: !process.env.CI,
  },
});
