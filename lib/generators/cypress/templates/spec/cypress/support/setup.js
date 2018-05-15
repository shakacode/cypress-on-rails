// cypress-on-rails: dont remove these command
Cypress.Commands.add('setupScenario', function(name) {
  Cypress.log({ message: name })
  cy.request('POST', 'http://localhost:' + Cypress.env("SERVER_PORT") + "/__cypress__/scenario", JSON.stringify({ scenario: name }))
});

Cypress.Commands.add('setupRails', function () {
  cy.request('POST', 'http://localhost:' + Cypress.env("SERVER_PORT") + "/__cypress__/setup")
});

Cypress.Commands.add('rails', function(code) {
  cy.request('POST', 'http://localhost:' + Cypress.env("SERVER_PORT") + '/__cypress__/eval', JSON.stringify({ code: code }))
})
// cypress-on-rails: end

// The next setup is optional, but if you remove it you will have to manually reset the database
beforeEach(() => { cy.setupRails() });