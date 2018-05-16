#!/usr/bin/env bash
set -euo pipefail

echo '--- testing rails 4.2'
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RAILS_ENV=test

cd $DIR
bundle install --retry 2 --jobs 2 --path vendor/bundle
bin/rails g cypress:install --cypress_folder=test/cypress

bin/rake db:create db:schema:load

# make sure the server is not running
(kill -9 `cat tmp/pids/server.pid` || true )

bin/rails server -p 5002 -d -e test
sleep 2 # give rails a chance to start up correctly

cd test
yarn run cypress run

kill -9 `cat ../tmp/pids/server.pid`
