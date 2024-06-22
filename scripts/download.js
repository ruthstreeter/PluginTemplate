const { chromium } = require('playwright');

(async () => {
  const selector = process.argv[2];
  const downloadUrl = process.argv[3];
  const destination = process.argv[4];
  console.log(`Downloading ${downloadUrl} to ${destination}`);
  const browser = await chromium.launch();
  console.log("Launched browser");
  const page = await browser.newPage();
  console.log("Opened window");
  await page.goto(downloadUrl, { waitUntil: 'domcontentloaded' });
  console.log(`Gone to page: ${downloadUrl}`);
  const downloadPromise = page.waitForEvent('download');
  console.log("Started download promise");
  await page.click(selector)
  console.log(`Clicked selector: ${selector}`);
  const download = await downloadPromise;
  console.log("Got download promise");
  await download.saveAs(destination);
  console.log("Saved download");
  await browser.close();
  console.log("Closed Browser");
})();
