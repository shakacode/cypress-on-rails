# CypressOnRails

[![Build Status](https://travis-ci.com/shakacode/cypress-on-rails.svg?branch=master)](https://travis-ci.org/shakacode/cypress-on-rails) [![Gem Version](https://badge.fury.io/rb/cypress-on-rails.svg)](https://badge.fury.io/rb/cypress-on-rails)

----

This project is sponsored by the software consulting firm [ShakaCode](https://www.shakacode.com), creator of the [React on Rails Gem](https://github.com/shakacode/react_on_rails). We focus on React front-ends, often with Ruby on Rails or Gatsby. The best way to see what we do is to see the details of [our recent work](https://www.shakacode.com/recent-work). Feel free to engage in discussions around this gem at our [forum category for Cypress](https://forum.shakacode.com/c/cypress-on-rails/55).

----

Gem for using [cypress.io](http://github.com/cypress-io/) in Rails and ruby rack applications
with the goal of controlling State as mentioned in [Cypress Best Practices](https://docs.cypress.io/guides/references/best-practices.html#Organizing-Tests-Logging-In-Controlling-State)

It allows to run code in the application context when executing cypress tests.
Do things like:
* use database_cleaner before each test
* seed the database with default data for each test
* use factory_bot to setup data
* create scenario files used for specific tests

Has examples of setting up state with:
* factory_bot
* rails test fixtures
* scenarios
* custom commands

## Resources
* [Video of getting started with this gem](https://grant-ps.blog/2018/08/10/getting-started-with-cypress-io-and-ruby-on-rails/)
* [Article: Introduction to Cypress on Rails](https://www.shakacode.com/blog/introduction-to-cypress-on-rails/)

## Getting started

Add this to your Gemfile:

```ruby
group :test, :development do
  gem 'cypress-on-rails', '~> 1.0'
end
```

Generate the boilerplate code using:

```shell
bin/rails g cypress_on_rails:install

# if you have/want a different cypress folder (default is spec/cypress)
bin/rails g cypress_on_rails:install --cypress_folder=test/cypress

# if you want to install cypress with npm
bin/rails g cypress_on_rails:install --install_cypress_with=npm

# to update the generated files run
bin/rails g cypress_on_rails:update
```

The generator modifies/adds the following files/directory in your application:
* `config/environments/test.rb`
* `config/initializers/cypress_on_rails` used to configure CypressDev
* `spec/cypress/integrations/` contains your cypress tests
* `spec/cypress/support/on-rails.js` contains CypressDev support code
* `spec/cypress/app_commands/scenarios/` contains your CypressDev scenario definitions
* `spec/cypress/cypress_helper.rb` contains helper code for CypressDev app commands

if you are not using database_cleaner look at `spec/cypress/app_commands/clean.rb`.
if you are not using factory_bot look at `spec/cypress/app_commands/factory_bot.rb`.

Now you can create scenarios and commands that are plain ruby files that get loaded through middleware, the ruby sky is your limit.

### WARNING
*WARNING!!:* cypress-on-rails can execute arbitrary ruby code
Please use with extra caution if starting your local server on 0.0.0.0 or running the gem on a hosted server

## Usage

Start the rails server in test mode and start cypress

```shell
# start rails
RAILS_ENV=test bin/rake db:create db:schema:load
bin/rails server -e test -p 5017

# in separate window start cypress
yarn cypress open --project ./spec
```

### Example of using factory bot
You can run your [factory_bot](https://github.com/thoughtbot/factory_bot) directly as well

```ruby
# spec/cypress/app_commands/factory_bot.rb
require 'cypress_on_rails/smart_factory_wrapper'

CypressOnRails::SmartFactoryWrapper.configure(
  always_reload: !Rails.configuration.cache_classes,
  factory: FactoryBot,
  files: Dir['./spec/factories/**/*.rb']
)
```

```js
// spec/cypress/integrations/simple_spec.js
describe('My First Test', function() {
  it('visit root', function() {
    // This calls to the backend to prepare the application state
    cy.appFactories([
      ['create_list', 'post', 10],
      ['create', 'post', {title: 'Hello World'} ],
      ['create', 'post', 'with_comments', {title: 'Factory_bot Traits here'} ] // use traits
    ])

    // Visit the application under test
    cy.visit('/')

    cy.contains("Hello World")

    // Accessing result
    cy.appFactories([['create', 'invoice', { paid: false }]]).then((records) => {
     cy.visit(`/invoices/${records[0].id}`);
    });
  })
})
```

### Example of loading rails test fixtures
```ruby
# spec/cypress/app_commands/activerecord_fixtures.rb
require "active_record/fixtures"

fixtures_dir = ActiveRecord::Tasks::DatabaseTasks.fixtures_path
fixture_files = Dir["#{fixtures_dir}/**/*.yml"].map { |f| f[(fixtures_dir.size + 1)..-5] }

logger.debug "loading fixtures: { dir: #{fixtures_dir}, files: #{fixture_files} }"
ActiveRecord::FixtureSet.reset_cache
ActiveRecord::FixtureSet.create_fixtures(fixtures_dir, fixture_files)
```

```js
// spec/cypress/integrations/simple_spec.js
describe('My First Test', function() {
  it('visit root', function() {
    // This calls to the backend to prepare the application state
    cy.appFixtures()

    // Visit the application under test
    cy.visit('/')

    cy.contains("Hello World")
  })
})
```

### Example of using scenarios

Scenarios are named `before` blocks that you can reference in your test.

You define a scenario in the `spec/cypress/app_commands/scenarios` directory:
```ruby
# spec/cypress/app_commands/scenarios/basic.rb
Profile.create name: "Cypress Hill"

# or if you have factory_bot enabled in your cypress_helper
CypressOnRails::SmartFactoryWrapper.create(:profile, name: "Cypress Hill")
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

## Usage with other rack applications

Add CypressOnRails to your config.ru

```ruby
# an example config.ru
require File.expand_path('my_app', File.dirname(__FILE__))

require 'cypress_on_rails/middleware'
CypressOnRails.configure do |c|
  c.cypress_folder = File.expand_path("#{__dir__}/test/cypress")
end
use CypressOnRails::Middleware

run MyApp
```

add the following file to cypress

```js
// test/cypress/support/on-rails.js
// CypressOnRails: dont remove these command
Cypress.Commands.add('appCommands', function (body) {
  cy.request({
    method: 'POST',
    url: "/__cypress__/command",
    body: JSON.stringify(body),
    log: true,
    failOnStatusCode: true
  })
});

Cypress.Commands.add('app', function (name, command_options) {
  cy.appCommands({name: name, options: command_options})
});

Cypress.Commands.add('appScenario', function (name) {
  cy.app('scenarios/' + name)
});

Cypress.Commands.add('appFactories', function (options) {
  cy.app('factory_bot', options)
});
// CypressOnRails: end

// The next is optional
beforeEach(() => {
  cy.app('clean') // have a look at cypress/app_commands/clean.rb
});
```

## Contributing

1. Fork it ( https://github.com/shakacode/cypress-on-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
