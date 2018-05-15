describe('My First Test', function() {
  it('visit root', function() {
    // This calls to the backend to prepare the application state
    // see the scenarios directory
    cy.setupScenario('basic')

    // The application unter test is available at SERVER_PORT
    cy.visit('http://localhost:'+Cypress.env("SERVER_PORT"))
  })
})