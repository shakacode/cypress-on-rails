Cypress.Commands.add("vcr_insert_cassette", (cassette_name, options) => {
  if (!options) options = {};

  Object.keys(options).forEach(key => options[key] === undefined ? delete options[key] : {});
  const log = Cypress.log({ name: "VCR Insert", message: cassette_name, autoEnd: false })
  return cy.request({
    method: 'POST',
    url: "/__cypress__/vcr/insert",
    body: JSON.stringify([cassette_name,options]),
    log: false,
    failOnStatusCode: false
  }).then((response) => {
    log.end();
    if (response.status !== 201) {
      expect(response.body.message).to.equal('')
      expect(response.status).to.be.equal(201)
    }
    return response.body
  });
});

Cypress.Commands.add("vcr_eject_cassette", () => {
  const log = Cypress.log({ name: "VCR Eject", autoEnd: false })
  return cy.request({
    method: 'POST',
    url: "/__cypress__/vcr/eject",
    log: false,
    failOnStatusCode: false
  }).then((response) => {
    log.end();
    if (response.status !== 201) {
      expect(response.body.message).to.equal('')
      expect(response.status).to.be.equal(201)
    }
    return response.body
  });
});
