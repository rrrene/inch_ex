#!/bin/bash

# common setup

set -e

DIRNAME=$( cd "$( dirname "$0" )" && pwd )
PROJECT_ROOT=$( cd "$DIRNAME/.." && pwd )

# execution

cd $PROJECT_ROOT

bash test_fixtures/run_and_export.sh

mix test --include test_fixtures