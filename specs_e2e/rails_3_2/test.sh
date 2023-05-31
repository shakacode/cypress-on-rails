#!/usr/bin/env bash
set -eo pipefail

echo '--- testing rails 3.2'

echo '-- setting environment'
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export RAILS_ENV=test
export BUNDLE_GEMFILE="$DIR/Gemfile"
cd $DIR

echo '-- bundle install'
bundle --version
bundle install --quiet --gemfile="$DIR/Gemfile" --retry 2 --path vendor/bundle

echo '-- cypress install'
bundle exec ./bin/rails g cypress_on_rails:install --install_folder=test/e2e --cypress_folder=test/cypress --playwright_folder=test/playwright --install_cypress --install_playwright --install_with=npm --skip
rm -vf cypress/e2e/rails_examples/advance_factory_bot.cy.js
rm -vf cypress/e2e/rails_examples/using_vcr.cy.js

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
    node_modules/.bin/cypress run --record
# fi

echo '-- cypress run'
cp -fv ../cypress.config.js .
npx playwright test

echo '-- stop rails server'
kill -9 `cat tmp/pids/server.pid`
