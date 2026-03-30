import { test, expect } from '@playwright/test';

test.describe('Program Selector (AUTH-03)', () => {
  test.skip('unauthenticated user is redirected to sign-in', async ({ page }) => {
    // Requires Clerk test mode — skipped until Clerk keys configured
    await page.goto('/select-program');
    await expect(page).toHaveURL(/sign-in/);
  });

  test.skip('authenticated user sees program cards', async ({ page }) => {
    // Requires Clerk test mode with seeded user
    await page.goto('/select-program');
    await expect(page.getByText('Select a Program')).toBeVisible();
  });
});
