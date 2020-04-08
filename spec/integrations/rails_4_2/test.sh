#!/usr/bin/env bash
set -eo pipefail

echo '--- testing rails 4.2'

echo '-- setting environment'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RAILS_ENV=test
BUNDLE_GEMFILE="$DIR/Gemfile"
cd $DIR

echo '-- bundle install'
bundle --version
bundle install --quiet --gemfile="$DIR/Gemfile" --retry 2 --path vendor/bundle

echo '-- cypress install'
bundle exec ./bin/rails g cypress_on_rails:install --no-install-cypress-examples
rm -vf spec/cypress/integration/rails_examples/advance_factory_bot_spec.js

echo '-- start rails server'
# make sure the server is not running
(kill -9 `cat tmp/pids/server.pid` || true )

bundle exec ./bin/rails server -p 5017 -e test &
sleep 2 # give rails a chance to start up correctly

echo '-- cypress run'
cp -fv ../cypress.json spec/
cd spec
if [ -z $CYPRESS_RECORD_KEY ]
then
    yarn run cypress run
else
    yarn run cypress run --record
fi

echo '-- stop rails server'
kill -9 `cat ../tmp/pids/server.pid`
