#!/usr/bin/env bash
set -eo pipefail

echo '--- testing rails 3.2'

echo '-- setting environment'
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export RAILS_ENV=test
export BUNDLE_GEMFILE="$DIR/Gemfile"
cd $DIR

echo '-- bundle install'
gem install bundler -v '1.0.22'
bundle _1.0.22_ --version
bundle _1.0.22_ install --quiet --gemfile="$DIR/Gemfile" --path vendor/bundle

echo '-- cypress install'
bundle exec ./bin/rails g cypress_on_rails:install --install_with=npm
rm -vf e2e/cypress/rails_examples/advance_factory_bot.cy.js
rm -vf e2e/cypress/rails_examples/using_vcr.cy.js

echo '-- start rails server'
# make sure the server is not running
(kill -9 `cat tmp/pids/server.pid` || true )

bundle exec ./bin/rails server -p 5017 -e test &
sleep 2 # give rails a chance to start up correctly

echo '-- cypress run'
cp -fv ../cypress.config.js .
# if [ -z $CYPRESS_RECORD_KEY ]
# then
#     node_modules/.bin/cypress run
# else
    npx cypress run --record
# fi

echo '-- playright install'
bundle exec ./bin/rails g cypress_on_rails:install --framework playright --install_with=npm --skip
rm -vf cypress/e2e/rails_examples/advance_factory_bot.cy.js
rm -vf cypress/e2e/rails_examples/using_vcr.cy.js

echo '-- playwright run'
cp -fv ../playwright.config.js .
npx playwright install-deps
npx playwright test playwright/e2e/

echo '-- stop rails server'
kill -9 `cat tmp/pids/server.pid`
