describe('Rails using factory bot examples', function() {
  beforeEach(() => {
    cy.app('clean') // have a look at cypress/app_commands/clean.rb
  })

  it('using single factory bot', function() {
    cy.appFactories([
      ['create', 'post', {title: 'Good bye Mars'} ]
    ])
    cy.visit('/')
    cy.get('table').find('tbody').should(($tbody) => {
      // clean should of removed these from other tests
      expect($tbody).not.to.contain('Hello World')

      expect($tbody).to.contain('Good bye Mars')
    })
  })

  it('using response from factory bot', function() {
    cy.appFactories([['create', 'post', { title: 'Good bye Mars'} ]]).then((results) => {
      const record = results[0];

      cy.visit(`/posts/${record.id}`);
    });
    cy.contains("Good bye Mars")
  })

  it('using response from factory bot', function() {
    cy.appFactories([['create', 'post', { title: 'Good bye Mars'} ]]).then((result) => {
      const record = JSON.parse(result)[0][0];

      cy.visit(`/posts/${record.id}`);
    });
    cy.contains("Good bye Mars")
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
    })
  })

  it('using response from multiple factory bot', function() {
    cy.appFactories([
      ['create', 'post', { title: 'My First Post'} ],
      ['create', 'post', { title: 'My Second Post'} ]
    ]).then((results) => {
      cy.visit(`/posts/${results[0].id}`);
      cy.contains("My First Post")

      cy.visit(`/posts/${results[1].id}`);
      cy.contains("My First Post")
    });
  })
})
