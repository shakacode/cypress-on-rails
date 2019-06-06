describe('Rails using rails fixtures examples', function() {
  beforeEach(() => {
    cy.app('clean') // have a look at cypress/app_commands/clean.rb
  })

  it('loading all fixtures', function() {
    cy.appFixtures()
    cy.visit('/')
    cy.get('table').find('tbody').should(($tbody) => {
      expect($tbody).to.contain('MyRailsFixtures')
      expect($tbody).to.contain('MyRailsFixtures2')
    })
  })

  it('using single rails fixtures', function() {
    cy.appFixtures({fixtures: ['posts']})
    cy.visit('/')
    cy.get('table').find('tbody').should(($tbody) => {
      expect($tbody).to.contain('MyRailsFixtures')
      expect($tbody).to.contain('MyRailsFixtures2')
    })
  })

  it('loading another folder of fixtures', function() {
    cy.appFixtures({fixtures_dir: 'test/cypress_fixtures' })
    cy.visit('/')
    cy.get('table').find('tbody').should(($tbody) => {
      expect($tbody).to.contain('MyCypressFixtures')
      expect($tbody).to.contain('MyCypressFixtures2')
    })
  })
})

