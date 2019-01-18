const puppeteer = require('puppeteer');

module.exports = async (context, req) => {

  const path = __dirname + '/trace.json';
  const { query: { url } } = req;

  const browser = await puppeteer.launch({
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox'
    ]
  });

  const page = await browser.newPage();
  await page.goto(url);
  await page.tracing.start({ path });
  // page.waitForNavigation gives timeout, common problem, using waitFor for now
  await page.waitFor(3000);
  await page.tracing.stop();
  // Contains loading times (DOMContentLoaded etc)
  const performanceTiming = (await page.evaluate(() => JSON.stringify(window.performance.timing)))
  return browser.close().then(() => {
    const result = require(path);
    context.bindings.outputBlob = JSON.stringify(result);
  });
};