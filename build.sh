#!/usr/bin/env bash
# exit on error
set -o errexit

# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
yarn --cwd ./assets
yarn --cwd ./assets run deploy
mix phx.digest

# Build the release and overwrite the existing release directory
MIX_ENV=prod mix release --overwrite

_build/prod/rel/api/bin/api eval "Api.Release.migrate"