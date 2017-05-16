### Spaces

Spaces are used to accommodate applications and services within an organization, at least one space per org. Each space has a unique role and enables users to share a workspace for application development, deployment, and maintenance.

To get the list of all spaces available to your account, use the following command:

    cf spaces


### Space quotas

Quota plans for spaces are created, modified, and allocated by Org Managers. Upon allocation, each quota plan is verified by Cloud Foundry for compliance with the predefined space limit. For instance, when Space Developers push applications to Cloud Foundry, the platform checks how much memory is allocated—first, at the space level and, then, at the org level.

To get the list of space quotas, run the following command:

    cf space-quotas
    
In order to get information about your current space you can run:
    
    cf target
    
In order to get information about quota plan which is specified for your space run:
    
    cf space SPACE_NAME
    
An example for space "dev" is `cf space dev` and the output for it should be similar to:

    Getting info for space dev in org poc as user@altoros.com...
    OK
    
    dev
          Org:               poc
          Apps:              mydemothread, app_517804, app_281802, app_993964, demomyapp, app_126561
          Domains:           cf-dev.den.altoros.com
          Services:          pg, myservice
          Security Groups:   pgsql, public_networks, dns
          Space Quota:
          
in this answer you can find information about all applications and services which are deployed and available in selected `Space`
