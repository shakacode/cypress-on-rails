#!/usr/bin/env bash
set -eo pipefail

echo '--- testing rails 4.2'

echo '-- setting environment'
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export RAILS_ENV=test
export BUNDLE_GEMFILE="$DIR/Gemfile"
cd $DIR

echo '-- bundle install'
gem install bundler -v "~> 1.0" --conservative
bundle --version
bundle install --quiet --gemfile="$DIR/Gemfile" --retry 2 --path vendor/bundle

echo '-- cypress install'
bundle exec ./bin/rails g cypress_on_rails:install --install_folder=spec --framework cypress --experimental --install_with=npm --force
rm -vf spec/cypress/e2e/rails_examples/advance_factory_bot.cy.js

echo '-- start rails server'
# make sure the server is not running
(kill -9 `cat ../server.pid` || true )

bundle exec ./bin/rails server -p 5017 -e test -P ../server.pid &
sleep 5 # give rails a chance to start up correctly

echo '-- cypress run'
cp -fv ../cypress.config.js spec/
# if [ -z $CYPRESS_RECORD_KEY ]
# then
#     npx cypress run -P ./spec
# else
    npx cypress install
    npx cypress run -P ./spec # --record
# fi

echo '-- playwright install'
bundle exec ./bin/rails g cypress_on_rails:install --install_folder=spec --framework playwright --experimental --install_with=npm --force
rm -vf spec/playwright/e2e/rails_examples/advance_factory_bot.cy.js

echo '-- playwright run'
cp -fv ../playwright.config.js spec/
cd spec
npx playwright install-deps
npx playwright install
npx playwright test spec/playwright/e2e

echo '-- stop rails server'
kill -9 `cat ../../server.pid` || true
