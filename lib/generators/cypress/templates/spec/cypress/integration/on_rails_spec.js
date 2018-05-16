describe('My First On Rails Tests', function() {
  it('setup basic scenario', function() {
    cy.appScenario('basic')
    cy.visit('/')
  })

  it('cypress eval', function() {
    cy.appEval("Time.now")
  })

  // uncomment these if you want to see what happens
  // it('example of missing scenario failure', function() {
  //   cy.appScenario('missing')
  // })
  //
  // it('example of missing app failure', function() {
  //   cy.app('run_me')
  // })
})