### Step 3: Mapping the route

**Option 1**

One of the options for mapping a route to an app is to use the `cf push` command:

	cf push helloworld -d privatedomain.com --hostname demo

In case you choose not to specify any domain or hostname, Cloud Foundry will generate a route from your app's name and the first shared domain created in the system. 


**Option 2** 

Another way to map routes to an app is through a manifest. You will need to edit the route attribute, adding the host, domain, port, and/or path components of your route, like so:

	---
	applications:
	- name: helloworld
	  host: demo
	  memory: 256mb
	  instances: 1
	  path: target/helloworld-0.0.1-SNAPSHOT.jar
	  buildpack: https://github.com/cloudfoundry/java-buildpack.git	  routes:
	  - route: privatedomain.com


**Option 3**

If you have already deployed the application, you can still add a new route with the `cf map-route` command:

	cf map-route helloworld privatedomain.com --hostname demo

Whatever option you use, the result will be as follows:

    name         requested state   instances   memory   disk   urls
    helloworld   started           1/1         256M     1G     helloworld.[cloud-foundry].com, demo.[cloud-foundry].com, demo.privatedomain.com

To check the application's availability, open all the three URLs:

* http://helloworld.[cloud-foundry].com
* http://demo.[cloud-foundry].com
* http://demo.privatedomain.com
    
As we have seen, in Cloud Foundry, multiple apps, or versions of the same app, can be mapped to the same route. Keep in mind that the platform will randomly route traffic among the apps on the shared route, which may result in issues.


## Learning check

Answer these questions to check your understanding of the concepts described in this module:

1. What is the difference between private and shared domains?
2. What is the difference between the "name" and "host" parameters in `manifest.yml`?