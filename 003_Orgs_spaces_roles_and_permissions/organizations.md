### Organizations (orgs)

An org is a development account that can be accessed with individual user accounts and shared by multiple users. 
Within an org, users share the same resource quota plan, applications, services, and custom domains.

Use the following command to get more information about organizations:

    cf orgs 
    
It will return all the orgs that you have created in your Cloud Foundry deployment.

### Org quota plans

Org quota plans are named sets that define quotas for RAM, instances, and services, e.g., 10 GB of RAM, 100 instances, and 100 services.

Cloud Foundry does not attach any quota plans to specific user accounts. Instead, operators assign quota plans to orgs. That way, all users within an org share the quota assigned to it. Each org can have an unlimited number of predefined quota plans, but only one quota plan can be assigned at a time.

Use the following command to list org quota plans:

    cf quotas

You will be able to see the list of all quota plans in your CF instance:
    
    name      total memory   instance memory   routes   service instances   paid plans   app instances   route ports
    default   10G            unlimited         1000     100                 allowed      unlimited       0
    
In order to get information about your current organization you can run:
    
    cf target
    
In order to get information about quota plan which is specified for your organization run:
    
    cf org ORG_NAME
    
An example for org "poc" is `cf org poc` and the output for it should be similar to example below with information about resources that can be used in total
by all users registered in this organization:

    Getting info for org poc as user@altoros.com...
    OK
    
    poc:
           domains:        cf-dev.den.altoros.com
           quota:          default (10240M memory limit, unlimited instance memory limit, 1000 routes, 100 services, paid services allowed, unlimited app instance limit, 0 route ports)
           spaces:         dev
           space quotas: