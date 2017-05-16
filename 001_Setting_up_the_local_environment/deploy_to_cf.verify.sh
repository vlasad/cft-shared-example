#!/bin/bash -e

check 'cf apps' 'started' true #> The helloworld application is not deployed or is not in started state.
