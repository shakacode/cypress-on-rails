describe('Rails Other examples', function() {
  it('Inserting a cassette', function() {
    cy.app('clean') // have a look at cypress/app_commands/clean.rb

    cy.vcr_insert_cassette('cats', { record: "new_episodes" })
    cy.visit('/using_vcr/index')

    cy.get('a').contains('Cats').click()
    cy.contains('Wikipedia has a recording of a cat meowing, because why not?')

    cy.vcr_eject_cassette();

    cy.vcr_insert_cassette('cats')
    cy.visit('/using_vcr/record_cats')
    cy.contains('Wikipedia has a recording of a cat meowing, because why not?')
  })
})
