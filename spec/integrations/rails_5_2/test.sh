#!/usr/bin/env bash
set -eo pipefail

echo '--- testing rails 5.2'

echo '-- setting environment'
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export RAILS_ENV=test
export BUNDLE_GEMFILE="$DIR/Gemfile"
cd $DIR

echo '-- bundle install'
bundle --version
bundle install --quiet --gemfile="$DIR/Gemfile" --retry 2 --path vendor/bundle

echo '-- migration'
bundle exec ./bin/rails db:drop || true
bundle exec ./bin/rails db:create db:migrate

echo '-- cypress install'
bundle exec ./bin/rails g cypress_on_rails:install --cypress_folder=test/cypress --no-install-cypress-examples

echo '-- start rails server'
# make sure the server is not running
(kill -9 `cat tmp/pids/server.pid` || true )

bundle exec ./bin/rails server -p 5017 -e test &
sleep 2 # give rails a chance to start up correctly

echo '-- cypress run'
cp -fv ../cypress.json test/
cd test
if [ -z $CYPRESS_RECORD_KEY ]
then
    yarn run cypress run
else
    yarn run cypress run --record
fi

echo '-- stop rails server'
kill -9 `cat ../tmp/pids/server.pid` || true
