#!/usr/bin/env bash
set -euo pipefail

echo '--- testing rails 4.2'

echo '-- setting environment'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RAILS_ENV=test
BUNDLE_GEMFILE="$DIR/Gemfile"
cd $DIR

echo '-- bundle install'
bundle install --retry 2 --jobs 2 --path vendor/bundle

echo '-- database setup'
bin/rake db:create db:schema:load

echo '-- cypress install'
bin/rails g cypress:install --cypress_folder=test/cypress


echo '-- start rails server'
# make sure the server is not running
(kill -9 `cat tmp/pids/server.pid` || true )

bin/rails server -p 5002 -d -e test
sleep 2 # give rails a chance to start up correctly

echo '-- cypress run'
cd test
yarn run cypress run

echo '-- stop rails server'
kill -9 `cat ../tmp/pids/server.pid`
