describe('My First On Rails Tests', function() {
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

  it('using single factory bot', function() {
    cy.appFactories([
      ['create', 'post', {title: 'Good bye Mars'} ]
    ])
    cy.visit('/')
    cy.get('table').find('tbody').should(($tbody) => {
      // clean should of removed these from other tests
      expect($tbody).not.to.contain('I am a Postman')
      expect($tbody).not.to.contain('Hello World')

      expect($tbody).to.contain('Good bye Mars')
    })
  })

  it('using multiple factory bot', function() {
    cy.appFactories([
      ['create_list', 'post', 10],
      ['create', 'post', {title: 'Hello World'} ]
    ])
    cy.visit('/')
    cy.get('table').find('tbody').should(($tbody) => {
      // clean should of removed these from other tests
      expect($tbody).to.contain('Hello World')
      expect($tbody).not.to.contain('Good bye Mars')

      expect($tbody).not.to.contain('I am a Postman')
    })
  })

  it('cypress eval', function() {
    cy.appEval("Post.create(title: 'Hello Eval')")

    cy.visit('/')
    cy.get('table').find('tbody').should(($tbody) => {
      // clean should of removed these from other tests
      expect($tbody).not.to.contain('Good bye Mars')
      expect($tbody).not.to.contain('I am a Postman')
      expect($tbody).not.to.contain('Hello World')
      expect($tbody).not.to.contain('MyRailsFixtures')
      expect($tbody).not.to.contain('MyRailsFixtures2')

      expect($tbody).to.contain('Hello Eval')
    })
  })

  it('runs multiple commands', function() {
    cy.appCommands([{ name: 'clean' },
                    { name: 'eval', options: "Time.now" }])
    cy.visit('/')
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
