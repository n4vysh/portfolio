const puppeteer = require("puppeteer");

module.exports = {
  ci: {
    collect: {
      chromePath: puppeteer.executablePath(),
      numberOfRuns: 1,
      isSinglePageApplication: true,
      staticDistDir: __dirname + "/dist",
      url: ["/"],
    },
    assert: {
      preset: "lighthouse:no-pwa",
      assertions: {
        "csp-xss": "off",
        "unused-javascript": "off",
        "legacy-javascript": "off",
        "unminified-javascript": "off",
      },
    },
  },
};
