#!/bin/bash -e

if cf apps | grep -q "No apps found"; then
  echo "There is no applications deployed"
fi #> The helloworld application has not been deployed.

check 'cf apps' 'started' true #> The helloworld application is not in started state.
