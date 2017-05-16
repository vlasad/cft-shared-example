#!/bin/bash -e

APP_NAME=`cf apps | grep started | awk '{print $1}'`

check 'cf service example-mysql' 'Bound apps: {{echo $APP_NAME}}' true #> The example-mysql service is not bound to the application.
