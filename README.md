# CypressOnRails

![Build Status](https://github.com/shakacode/cypress-on-rails/actions/workflows/ruby.yml/badge.svg)
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

## Installation

Add this to your Gemfile:

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
* `config/initializers/cypress_on_rails` used to configure CypressDev
* `spec/cypress/e2e/` contains your cypress tests
* `spec/cypress/support/on-rails.js` contains CypressDev support code
* `spec/cypress/app_commands/scenarios/` contains your CypressDev scenario definitions
* `spec/cypress/cypress_helper.rb` contains helper code for CypressDev app commands

if you are not using database_cleaner look at `spec/cypress/app_commands/clean.rb`.
if you are not using factory_bot look at `spec/cypress/app_commands/factory_bot.rb`.

Now you can create scenarios and commands that are plain ruby files that get loaded through middleware, the ruby sky is your limit.

### Update your database.yml

When writing cypress test on your local it's recommended to start your server in development mode so that changes you
make are picked up without having to restart the server. 
It's recommend you update your database.yml to check if the CYPRESS environment variable is set and switch it to the test database
otherwise cypress will keep clearing your development database.

for example:

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
You can check the [association Docs](https://github.com/shakacode/cypress-on-rails/blob/master/docs/factory_bot_associations.md) on more ways to setup association with the correct data.

In some cases, using static Cypress fixtures may not provide sufficient flexibility when mocking HTTP response bodies - it's possible to use `FactoryBot.build` to generate Ruby hashes that can then be used as mock JSON responses:
```ruby
FactoryBot.define do
  factory :some_web_response, class: Hash do
    initialize_with { attributes.deep_stringify_keys }

    id { 123 }
    name { 'Mr Blobby' }
    occupation { 'Evil pink clown' }
  end
end

FactoryBot.build(:some_web_response) => { 'id' => 123, 'name' => 'Mr Blobby', 'occupation' => 'Evil pink clown' }
```

This can then be combined with Cypress mocks:
```js
describe('My First Test', function() {
  it('visit root', function() {
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

    cy.contains("Hello World")
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
// spec/cypress/e2e/simple.cy.js
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
// spec/cypress/e2e/scenario_example.cy.js
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
// spec/cypress/e2e/simple.cy.js
describe('My First Test', function() {
  beforeEach(() => { cy.app('load_seed') })

  it('visit root', function() {
    cy.visit('/')

    cy.contains("Seeds")
  })
})
```

## Expermintal Features (matching npm package)

Please test and give feedback

add the npm package:

```
yarn add cypress-on-rails --dev
```

### for VCR

This only works when you start the rails server with a single worker and single thread

#### setup

Add your VCR configuration to your `cypress_helper.rb`

```ruby
require 'vcr'
VCR.configure do |config|
  config.hook_into :webmock
end
```

Add to you `cypress/support/index.js`

```js
import 'cypress-on-rails/support/index'
```

Add to you `clean.rb`

```ruby
VCR.eject_cassette # make sure we no cassettes inserted before the next test starts
VCR.turn_off!
WebMock.disable! if defined?(WebMock)
```

Add to you `config/cypress_on_rails.rb`

```ruby
  c.use_vcr_middleware = !Rails.env.production? && ENV['CYPRESS'].present?
```

#### usage

You have `vcr_insert_cassette` and `vcr_eject_cassette` available. https://www.rubydoc.info/github/vcr/vcr/VCR:insert_cassette


```js
describe('My First Test', function() {
  beforeEach(() => { cy.app('load_seed') })

  it('visit root', function() {
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

# Supporters

The following companies support this open source project, and ShakaCode uses their products! Justin writes React on Rails on [RubyMine](https://www.jetbrains.com/ruby/). We use [Scout](https://scoutapp.com/) to monitor the live performance of [HiChee.com](https://HiChee.com), [Rails AutoScale](https://railsautoscale.com) to scale the dynos of HiChee, and [HoneyBadger](https://www.honeybadger.io/) to monitor application errors. We love [BrowserStack](https://www.browserstack.com) to solve problems with oddball browsers.

[![RubyMine](https://user-images.githubusercontent.com/1118459/114100597-3b0e3000-9860-11eb-9b12-73beb1a184b2.png)](https://www.jetbrains.com/ruby/)
[![Scout](https://user-images.githubusercontent.com/1118459/171088197-81555b69-9ed0-4235-9acf-fcb37ecfb949.png)](https://scoutapp.com/)
[![Rails AutoScale](https://user-images.githubusercontent.com/1118459/103197530-48dc0e80-488a-11eb-8b1b-a16664b30274.png)](https://railsautoscale.com/)
[![BrowserStack](https://cloud.githubusercontent.com/assets/1118459/23203304/1261e468-f886-11e6-819e-93b1a3f17da4.png)](https://www.browserstack.com)
[![HoneyBadger](https://user-images.githubusercontent.com/1118459/114100696-63962a00-9860-11eb-8ac1-75ca02856d8e.png)](https://www.honeybadger.io/)

ShakaCode's favorite project tracking tool is [Shortcut](https://shortcut.com/). If you want to **try Shortcut and get 2 months free beyond the 14-day trial period**, click [here to use ShakaCode's referral code](http://r.clbh.se/mvfoNeH). We're participating in their awesome triple-sided referral program, which you can read about [here](https://shortcut.com/referral/). By using our [referral code](http://r.clbh.se/mvfoNeH) you'll be supporting ShakaCode and, thus, React on Rails!
