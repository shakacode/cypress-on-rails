describe('My First On Rails Tests', function() {
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

  it('stub services with rspec-mock', function() {
    cy.app('stub_services')
    cy.visit('/')
  })

  it('runs multiple commands', function() {
    cy.appCommands([{ name: 'stub_services' },
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