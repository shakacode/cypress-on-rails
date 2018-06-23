describe('My First On Rails Tests', function() {
  beforeEach(() => {
    cy.app('clean') // have a look at cypress/app_commands/clean.rb
  })

  it('setup basic scenario', function() {
    cy.appScenario('basic')
    cy.visit('/')
  })

  it('using factory bot', function() {
    cy.appFactories([
      ['create_list', 'post', 10],
      ['create', 'post', {title: 'Hello World'} ]
    ])
    cy.visit('/')
  })

  it('cypress eval', function() {
    cy.appEval("Time.now")
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
