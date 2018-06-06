// cypress-on-rails: dont remove these command
Cypress.Commands.add('appCommands', function (body) {
  cy.request({
    method: 'POST',
    url: "/__cypress__/command",
    body: JSON.stringify(body),
    log: true,
    failOnStatusCode: true
  })
});

Cypress.Commands.add('app', function (name, command_options) {
  cy.appCommands({name: name, options: command_options})
});

Cypress.Commands.add('appScenario', function (name) {
  cy.app('scenarios/' + name)
});

Cypress.Commands.add('appEval', function (code) {
  cy.app('eval', code)
});

Cypress.Commands.add('appFactories', function (options) {
  cy.app('factory_bot', options)
});
// cypress-on-rails: end

// The next is optional
beforeEach(() => {
  cy.app('clean') // have a look at cypress/app_commands/clean.rb
});