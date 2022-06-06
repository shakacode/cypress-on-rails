describe('Rails Other examples', function() {
  it('Inserting a cassette', function() {
    cy.app('clean') // have a look at cypress/app_commands/clean.rb

    cy.vcr_insert_cassette('cats', { record: "new_episodes" })
    cy.visit('/using_vcr/index')

    cy.get('a').contains('Cats').click()
    cy.contains('Record from Cats API');

    cy.vcr_eject_cassette();
  })

  it('Using previous a cassette', function() {
    cy.app('clean') // have a look at cypress/app_commands/clean.rb

    cy.vcr_insert_cassette('cats')
    cy.visit('/using_vcr/index')
    cy.get('a').contains('Cats').click()
    cy.contains('Record from Cats API');

    cy.vcr_eject_cassette();
  })
})
