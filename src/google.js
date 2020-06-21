const puppeteer = require('puppeteer');
const puppeteerExtra = require('puppeteer-extra');
const puppeteerHar = require('puppeteer-har');
const { execFile } = require('child_process');

puppeteerExtra.use(require('puppeteer-extra-plugin-adblocker')({
  blockTrackers: true,
  useCache: true,
  cacheDir: './userData',
}));

/*puppeteerExtra.use(require('puppeteer-extra-plugin-block-resources')({
  blockedTypes: new Set(['image', 'stylesheet'])
}));*/

const param_puppeteer = {
  userdatadir: "./userData",
  args: [
    '--headless',
    '--disable-gpu',
    '--disable-dev-shm-usage',
    '--disable-infobars',
    '--ignore-certifcate-errors',
    '--ignore-certifcate-errors-spki-list',
    '--safebrowsing-disable-extension-blacklist',
    '--safebrowsing-disable-download-protection',
    '–-no-first-run',
    '--no-zygote',
    '--no-sandbox',
    '--single-process',
  ]
};

function start() {
  return new Promise(async (resolve, reject) => {
    try {
      const browser = await puppeteerExtra.launch(param_puppeteer);
      const page = await browser.newPage();
      await page.emulate(puppeteer.devices['iPhone XR']);
      const har = new puppeteerHar(page);
      await har.start({ path: './userData/google.har' });

      let title = await task(page, 'https://www.google.com/search?q=Weather');

      await page.screenshot({path: './userData/google.png'});
      await page.pdf({
        path: "./userData/google.pdf",
        printBackground: true,
        format: "A4"
      });

      await har.stop();
      await browser.close();

      resolve(title);

    } catch (e) {
      return reject(e);
    }
  })
}

async function task(page, url) {
  await page.goto(url, {
     waitUntil: 'networkidle2',
  });

  const pageTitle = await page.title();

  return pageTitle;
}

start().then(console.log).catch(console.error);
