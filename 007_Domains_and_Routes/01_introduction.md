In this module, you will learn how to work with routes and domains in Cloud Foundry.


### Objectives

After completing this module, you will be able to:

* Use domain and routing features in Cloud Foundry
* Understand why these concepts were introduced in Cloud Foundry
* Use the Web Console and CLI commands to manage routes and domains


### Study topics

### Routes

Any app running inside Elastic Runtime is assigned or mapped to a unique URL (aka route). Cloud Foundry uses these URLs to route HTTP requests to the right app. For instance, when we deployed the `HelloWorld` application in one of the earlier modules, it was automatically mapped to the route `helloworld.[cloud-foundry-instance].com`.

Mapping multiple apps to one route will make Cloud Foundry balance requests to this route across all instances of the mapped apps. This feature makes blue-green deployments possible. You can also assign several routes to a single app. That way, you will be able to access the app using any of the mapped URLs.

Keep in mind that routes are attached to spaces. While you can map many apps to a single route, all these apps have to live in the same space—the one to which the route belongs. At the same time, routes must be unique within the scope of your Cloud Foundry deployment. Users of one space cannot create a route with an URL that already exists in another space, even if these spaces belong to different orgs.


### Domains

The term "domain" and related terms, such as "shared domain," "private domain," "domain name," and "root domain" get different (than usual) meanings in the context of Cloud Foundry.

"Domain name," "root domain," and "subdomain" refer to DNS records.

The word "domain" implies that traffic coming to any routes within the domain will get routed to Cloud Foundry. This usually means that the DNS is set out-of-band and resolves the domain name to a load balancer's IP address, which—in its turn—forwards the traffic to Cloud Foundry routers.
