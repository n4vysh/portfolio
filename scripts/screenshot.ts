import puppeteer from "puppeteer";

const browser = await puppeteer.launch({
  args: ["--no-sandbox", "--disable-setuid-sandbox"],
});
const page = await browser.newPage();
await page.goto("http://localhost:8080");
await page.screenshot({ path: "./misc/screenshot.png" });

await browser.close();
