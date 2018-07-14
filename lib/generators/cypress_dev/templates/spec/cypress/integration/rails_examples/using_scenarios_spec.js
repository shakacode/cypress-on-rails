describe('Rails using scenarios examples', function() {
  beforeEach(() => {
    cy.app('clean') // have a look at cypress/app_commands/clean.rb
  })

  it('setup basic scenario', function() {
    cy.appScenario('basic')
    cy.visit('/')
    cy.get('table').find('tbody').should(($tbody) => {
      // clean should of removed these from other tests
      expect($tbody).not.to.contain('Good bye Mars')
      expect($tbody).not.to.contain('Hello World')

      expect($tbody).to.contain('I am a Postman')
    })
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
