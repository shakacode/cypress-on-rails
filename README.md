# CypressOnRails

![Build Status](https://github.com/shakacode/cypress-on-rails/actions/workflows/ruby.yml/badge.svg)
[![cypress-on-rails](https://img.shields.io/endpoint?url=https://dashboard.cypress.io/badge/simple/2b6cjr/master&style=plastic&logo=cypress)](https://dashboard.cypress.io/projects/2b6cjr/runs)
[![Gem Version](https://badge.fury.io/rb/cypress-on-rails.svg)](https://badge.fury.io/rb/cypress-on-rails)

----

This project is sponsored by the software consulting firm [ShakaCode](https://www.shakacode.com), creator of the [React on Rails Gem](https://github.com/shakacode/react_on_rails). We focus on React (with TS or ReScript) front-ends, often with Ruby on Rails or Gatsby. See [our recent work](https://www.shakacode.com/recent-work) and [client engagement model](https://www.shakacode.com/blog/client-engagement-model/). Feel free to engage in discussions around this gem at our [Slack Channel](https://join.slack.com/t/reactrails/shared_invite/enQtNjY3NTczMjczNzYxLTlmYjdiZmY3MTVlMzU2YWE0OWM0MzNiZDI0MzdkZGFiZTFkYTFkOGVjODBmOWEyYWQ3MzA2NGE1YWJjNmVlMGE) or our [forum category for Cypress](https://forum.shakacode.com/c/cypress-on-rails/55). 

Interested in joining a small team that loves open source? Check our [careers page](https://www.shakacode.com/career/).

Need help with cypress-on-rails? Contact [ShakaCode](mailto:justin@shakacode.com).

----

# Totally new to Cypress?
Suggest you first learn the basics of Cypress before attempting to integrate with Ruby on Rails

* [Good start Here](https://docs.cypress.io/examples/examples/tutorials.html#Best-Practices)

## Overview

Gem for using [cypress.io](http://github.com/cypress-io/) in Rails and Ruby Rack applications
with the goal of controlling state as mentioned in [Cypress Best Practices](https://docs.cypress.io/guides/references/best-practices.html#Organizing-Tests-Logging-In-Controlling-State)

It allows you to run code in the application context when executing cypress tests.
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

## Installation

Add this to your `Gemfile`:

```ruby
group :test, :development do
  gem 'cypress-on-rails', '~> 1.0'
end
```

Generate the boilerplate code using:

```shell
bin/rails g cypress_on_rails:install

# if you have/want a different cypress folder (default is cypress)
bin/rails g cypress_on_rails:install --cypress_folder=spec/cypress

# if you want to install cypress with npm
bin/rails g cypress_on_rails:install --install_cypress_with=npm

# if you already have cypress installed globally
bin/rails g cypress_on_rails:install --no-install-cypress

# to update the generated files run
bin/rails g cypress_on_rails:update
```

The generator modifies/adds the following files/directory in your application:
* `config/environments/test.rb`
* `config/initializers/cypress_on_rails.rb` used to configure Cypress on Rails
* `spec/cypress/e2e/` contains your cypress tests
* `spec/cypress/support/on-rails.js` contains Cypress on Rails support code
* `spec/cypress/app_commands/scenarios/` contains your Cypress on Rails scenario definitions
* `spec/cypress/cypress_helper.rb` contains helper code for Cypress on Rails app commands

If you are not using `database_cleaner` look at `spec/cypress/app_commands/clean.rb`.
If you are not using `factory_bot` look at `spec/cypress/app_commands/factory_bot.rb`.

Now you can create scenarios and commands that are plain Ruby files that get loaded through middleware, the ruby sky is your limit.

### Update your database.yml

When running `cypress test` on your local computer it's recommended to start your server in development mode so that changes you
make are picked up without having to restart the server. 
It's recommended you update your `database.yml` to check if the `CYPRESS` environment variable is set and switch it to the test database
otherwise cypress will keep clearing your development database.

For example:
```yaml
development:
  <<: *default
  database: <%= ENV['CYPRESS'] ? 'my_db_test' : 'my_db_development' %>
test:
  <<: *default
  database: my_db_test
```

### WARNING
*WARNING!!:* cypress-on-rails can execute arbitrary ruby code
Please use with extra caution if starting your local server on 0.0.0.0 or running the gem on a hosted server

## Usage

Getting started on your local environment

```shell
# start rails
CYPRESS=1 bin/rails server -p 5017

# in separate window start cypress
yarn cypress open 
# or for npm
node_modules/.bin/cypress open 
# or if you changed the cypress folder to spec/cypress
yarn cypress open --project ./spec
```

How to run cypress on CI

```shell
# setup rails and start server in background
# ...

yarn run cypress run
# or for npm
node_modules/.bin/cypress run 
```

### Example of using factory bot

You can run your [factory_bot](https://github.com/thoughtbot/factory_bot) directly as well

```js
// spec/cypress/e2e/simple.cy.js
describe('My First Test', () => {
  it('visit root', () => {
    // This calls to the backend to prepare the application state
    cy.appFactories([
      ['create_list', 'post', 10],
      ['create', 'post', {title: 'Hello World'} ],
      ['create', 'post', 'with_comments', {title: 'Factory_bot Traits here'} ] // use traits
    ])

    // Visit the application under test
    cy.visit('/')

    cy.contains('Hello World')

    // Accessing result
    cy.appFactories([['create', 'invoice', { paid: false }]]).then((records) => {
     cy.visit(`/invoices/${records[0].id}`);
    });
  })
})
```
You can check the [association docs](docs/factory_bot_associations.md) on more ways to setup association with the correct data.

In some cases, using static Cypress fixtures may not provide sufficient flexibility when mocking HTTP response bodies. It's possible to use `FactoryBot.build` to generate Ruby hashes that can then be used as mock JSON responses:
```ruby
FactoryBot.define do
  factory :some_web_response, class: Hash do
    initialize_with { attributes.deep_stringify_keys }

    id { 123 }
    name { 'Mr Blobby' }
    occupation { 'Evil pink clown' }
  end
end

FactoryBot.build(:some_web_response => { 'id' => 123, 'name' => 'Mr Blobby', 'occupation' => 'Evil pink clown' })
```

This can then be combined with Cypress mocks:
```js
describe('My First Test', () => {
  it('visit root', () => {
    // This calls to the backend to generate the mocked response
    cy.appFactories([
      ['build', 'some_web_response', { name: 'Baby Blobby' }]
    ]).then(([responseBody]) => {
      cy.intercept('http://some-external-url.com/endpoint', {
        body: responseBody
      });

      // Visit the application under test
      cy.visit('/')
    })

    cy.contains('Hello World')
  })
})
```

### Example of loading Rails test fixtures
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
// spec/cypress/e2e/simple.cy.js
describe('My First Test', () => {
  it('visit root', () => {
    // This calls to the backend to prepare the application state
    cy.appFixtures()

    // Visit the application under test
    cy.visit('/')

    cy.contains('Hello World')
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
// spec/cypress/e2e/scenario_example.cy.js
describe('My First Test', () => {
  it('visit root', () => {
    // This calls to the backend to prepare the application state
    cy.appScenario('basic')

    cy.visit('/profiles')

    cy.contains('Cypress Hill')
  })
})
```

### Example of using app commands

Create a Ruby file in the `spec/cypress/app_commands` directory:
```ruby
# spec/cypress/app_commands/load_seed.rb
load "#{Rails.root}/db/seeds.rb"
```

Then reference the command in your test with `cy.app('load_seed')`:
```js
// spec/cypress/e2e/simple.cy.js
describe('My First Test', () => {
  beforeEach(() => { cy.app('load_seed') })

  it('visit root', () => {
    cy.visit('/')

    cy.contains("Seeds")
  })
})
```

## Experimental Features (matching npm package)

Please test and give feedback.

Add the npm package:

```
yarn add cypress-on-rails --dev
```

### for VCR

This only works when you start the Rails server with a single worker and single thread

#### setup

Add your VCR configuration to your `cypress_helper.rb`

```ruby
require 'vcr'
VCR.configure do |config|
  config.hook_into :webmock
end
```

Add to your `cypress/support/index.js`:

```js
import 'cypress-on-rails/support/index'
```

Add to your `cypress/app_commands/clean.rb`:

```ruby
VCR.eject_cassette # make sure we no cassettes inserted before the next test starts
VCR.turn_off!
WebMock.disable! if defined?(WebMock)
```

Add to your `config/cypress_on_rails.rb`:

```ruby
  c.use_vcr_middleware = !Rails.env.production? && ENV['CYPRESS'].present?
```

#### usage

You have `vcr_insert_cassette` and `vcr_eject_cassette` available. https://www.rubydoc.info/github/vcr/vcr/VCR:insert_cassette


```js
describe('My First Test', () => {
  beforeEach(() => { cy.app('load_seed') })

  it('visit root', () => {
    cy.app('clean') // have a look at cypress/app_commands/clean.rb

    cy.vcr_insert_cassette('cats', { record: "new_episodes" })
    cy.visit('/using_vcr/index')

    cy.get('a').contains('Cats').click()
    cy.contains('Wikipedia has a recording of a cat meowing, because why not?')

    cy.vcr_eject_cassette()

    cy.vcr_insert_cassette('cats')
    cy.visit('/using_vcr/record_cats')
    cy.contains('Wikipedia has a recording of a cat meowing, because why not?')
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

add the following file to Cypress

```js
// test/cypress/support/on-rails.js
// CypressOnRails: don't remove these commands
Cypress.Commands.add('appCommands', (body) => {
  cy.request({
    method: 'POST',
    url: '/__cypress__/command',
    body: JSON.stringify(body),
    log: true,
    failOnStatusCode: true
  })
});

Cypress.Commands.add('app', (name, command_options) => {
  cy.appCommands({name: name, options: command_options})
});

Cypress.Commands.add('appScenario', (name) => {
  cy.app('scenarios/' + name)
});

Cypress.Commands.add('appFactories', (options) => {
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

## Supporters

<a href="https://www.jetbrains.com">
  <img src="https://user-images.githubusercontent.com/4244251/184837695-2c00e329-7241-4d9b-9373-644c1ce215be.png" alt="JetBrains" height="120px">
</a>
<a href="https://scoutapp.com">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/4244251/184837700-a910106b-1b1b-4117-88b8-9b5389425e66.png">
    <source media="(prefers-color-scheme: light)" srcset="https://user-images.githubusercontent.com/4244251/184837704-83960568-1599-485b-b184-5fd8b05d5051.png">
    <img alt="ScoutAPM" src="https://user-images.githubusercontent.com/4244251/184837704-83960568-1599-485b-b184-5fd8b05d5051.png" height="120px">
  </picture>
</a>
<br />
<a href="https://www.browserstack.com">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/4244251/184838560-ada89877-abd1-4d11-b144-b52ef69e0bb9.png">
    <source media="(prefers-color-scheme: light)" srcset="https://user-images.githubusercontent.com/4244251/184838569-35f4d4b1-5545-4ee4-a015-41ca7a5dbc7c.png">
    <img alt="BrowserStack" src="https://user-images.githubusercontent.com/4244251/184838569-35f4d4b1-5545-4ee4-a015-41ca7a5dbc7c.png" height="55px">
  </picture>
</a>
<a href="https://railsautoscale.com">
  <img src="https://user-images.githubusercontent.com/4244251/184838579-f8c2fd95-f376-4f0d-a661-50bbdeee892b.png" alt="Rails Autoscale" height="55px">
</a>
<a href="https://www.honeybadger.io">
  <img src="https://user-images.githubusercontent.com/4244251/184838575-e56cac82-5853-448c-a623-67280a91d75f.png" alt="Honeybadger" height="55px">
</a>

<br />
<br />

The following companies support our open source projects, and ShakaCode uses their products!
