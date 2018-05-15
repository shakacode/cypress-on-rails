// cypress-on-rails: dont remove these command
Cypress.Commands.add('appScenario', function(name) {
  cy.app('scenarios/' + name)
});

Cypress.Commands.add('app', function (name) {
  cy.request({method: 'POST',
    url: "/__cypress__/command",
    body: JSON.stringify({ name: name }),
    log: false,
    failOnStatusCode: true} )
});

Cypress.Commands.add('appEval', function(code) {
  cy.request({method: 'POST',
    url: "/__cypress__/eval",
    body: JSON.stringify({ code: code }),
    log: false,
    failOnStatusCode: true} )
})
// cypress-on-rails: end

// The next setup is optional, but if you remove it you will have to manually reset the database
beforeEach(() => { cy.app('clean_db') });