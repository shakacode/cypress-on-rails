describe('My First Test', function() {
  it('setup basic scenario', function() {
    cy.appScenario('basic')
    cy.visit('/')
  })

  it('cypress eval', function() {
    cy.appEval("Time.now")
  })
})