#!/bin/bash -e

check 'cf services' 'example-mysql.*create succeeded' true #> The example-mysql service is not created.
