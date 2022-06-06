const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    baseUrl: "http://localhost:5017",
    defaultCommandTimeout: 10000,
    supportFile: "cypress/support/index.js",
  }
})
