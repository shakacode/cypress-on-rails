# cypress-on-rails

Gem for using [cypress.io](http://github.com/cypress-io/) in Rails and ruby rack applications. 
It allows to run code in the application context when executing cypress tests.
Do things like:
* use database_cleaner before each test
* seed the database with default data for each test
* use factory_bot to setup data
* create scenario files used for specific tests

## Getting started

Add this to your Gemfile:
```
group :test, :development do
  gem 'cypress-on-rails', git: 'https://github.com/grantspeelman/cypress-on-rails'
end
```

The generate the boilerplate code using:
```
bin/rails g cypress:install

# if you have/want a different cypress folder (default is spec/cypress)
bin/rails g cypress:install --cypress_folder=test/cypress

# if you want to install cypress with npm
bin/rails g cypress:install --install_cypress_with=npm
```

if you are not using database_cleaner look at `spec/cypress/app_commands/clean_db.rb`.
if you are not using factory_bot look at `spec/cypress/app_commands/factory_bot.rb`.

## Usage

The generator adds the following files/directory to your application:
* `spec/cypress/integrations/` contains your tests
* `spec/cypress/support/on-rails.js` contains support code
* `spec/cypress/app_commands/scenarios/` contains your scenario definitions
* `spec/cypress/cypress_helper.rb` contains helper code for app commands

When writing End-to-End tests, you will probably want to prepare your database to a known state. 
Maybe using a gem like factory_bot. This gem implements two methods to achieve this goal:

example of getting started

```
# start rails
RAILS_ENV=test bin/rake db:create db:schema:load
bin/rails server -e test -p 5002

# in separate window start cypress
cd spec
yarn run cypress open
```

Now you can create scenarios and commands that are plan ruby files that get loaded 
through middleware, the ruby sky is your limit.

### WARNING
*WARNING!!:* cypress-on-rails can execute arbitrary ruby code
Please use with extra caution if starting your local server on 0.0.0.0

### Example of using scenarios

Scenarios are named `before` blocks that you can reference in your test.

You define a scenario in the `spec/cypress/app_commands/scenarios` directory:
```ruby
# spec/cypress/app_commands/scenarios/basic.rb
require_relative '../../cypress_helper' 
Profile.create name: "Cypress Hill"

# or if you have factory_bot enabled in your cypress_helper
FactoryBot.create(:profile, name: "Cypress Hill") 
```

Then reference the scenario in your test:
```js
// spec/cypress/integrations/scenario_example_spec.js
describe('My First Test', function() {
  it('visit root', function() {
    // This calls to the backend to prepare the application state
    cy.appScenario('basic')

    cy.visit('/profiles')

    cy.contains("Cypress Hill")
  })
})
```

### Example of using app commands

create a ruby file in `spec/cypress/app_commands` directory:
```ruby
# spec/cypress/app_commands/load_seed.rb 
load "#{Rails.root}/db/seeds.rb" 
```

Then reference the command in your test with `cy.app('load_seed')`:
```js
// spec/cypress/integrations/simple_spec.js
describe('My First Test', function() {
  beforeEach(() => { cy.app('load_seed') })
  
  it('visit root', function() {
    cy.visit('/')

    cy.contains("Seeds")
  })
})
```

### Using embedded ruby
You can embed ruby code in your test file. This code will then be executed in the context of your application. For example:

```js
// spec/cypress/integrations/simple_spec.js
describe('My First Test', function() {
  it('visit root', function() {
    // This calls to the backend to prepare the application state
    cy.appEval(`
      Profile.create name: "Cypress Hill"
    `)

    // The application unter test is available at SERVER_PORT
    cy.visit('/')

    cy.contains("Cypress Hill")
  })
})
```

Use the (`) backtick string syntax to allow multiline strings.

## Usage with other rack applications

Add cypress-on-rails to your config.ru

```ruby
# an example config.ru
require File.expand_path('my_app', File.dirname(__FILE__))

require 'cypress/middleware'
Cypress.configure do |c|
  c.cypress_folder = File.expand_path("#{__dir__}/test/cypress")
end
use Cypress::Middleware

run MyApp 
```

add the following file to cypress

```js
// test/cypress/support/on-rails.js
// cypress-on-rails: dont remove these command
Cypress.Commands.add('app', function (name, command_options) {
  cy.request({
    method: 'POST',
    url: "/__cypress__/command",
    body: JSON.stringify({name: name, options: command_options}),
    log: true,
    failOnStatusCode: true
  })
});

Cypress.Commands.add('appScenario', function (name) {
  cy.app('scenarios/' + name)
});
// cypress-on-rails: end

// The next is optional
beforeEach(() => {
  cy.app('clean_db') // have a look at cypress/app_commands/clean_db
});
```

# Limitations
This code is very much at the proof-of-concept stage. The following limitations are known:
* the generator installs cypress using yarn
