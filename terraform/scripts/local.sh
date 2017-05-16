#!/bin/bash
set -e

cf_domain="$1"
cf_admin="$2"
cf_admin_password="$3"
owner_tag="$4"
uuid="$5"

suffix=${uuid:0:4}
org="org-${suffix}"
space="space-${suffix}"
user="${owner_tag}-${suffix}"

export CF_HOME=.
cf api api.${cf_domain} --skip-ssl-validation
cf auth ${cf_admin} ${cf_admin_password}
cf create-org ${org}
cf create-space ${space} -o ${org}
cf create-user ${user} ${uuid}
cf set-space-role ${user} ${org} ${space} SpaceDeveloper
