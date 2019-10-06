describe('More Rails using factory bot examples', function() {
  beforeEach(() => {
    cy.app('clean') // have a look at cypress/app_commands/clean.rb
  })

  it('using response from factory bot', function() {
    cy.appFactories([['create', 'post', { title: 'Good bye Mars'} ]]).then((results) => {
      const record = results[0];

      cy.visit(`/posts/${record.id}`);
    });
    cy.contains("Good bye Mars")
  })

  it('using response from multiple factory bot', function() {
    cy.appFactories([
      ['create', 'post', { title: 'My First Post'} ],
      ['create', 'post', { title: 'My Second Post'} ]
    ]).then((results) => {
      cy.visit(`/posts/${results[0].id}`);
      cy.contains("My First Post")

      cy.visit(`/posts/${results[1].id}`);
      cy.contains("My Second Post")
    });
  })
})
