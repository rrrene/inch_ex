#!/bin/bash


# common setup

set -e

DIRNAME=$( cd "$( dirname "$0" )" && pwd )

FIXTURE_ROOT=$DIRNAME

FIXTURE_NAME=$1
FIXTURE_NAME=${FIXTURE_NAME:-inch_test}

# execution

cd $FIXTURE_ROOT/$FIXTURE_NAME

mix deps.get
mix compile

echo ""
echo "== Running Inch ..."

mix inch --format json > ../$FIXTURE_NAME.json

echo "== ... done"
echo ""
