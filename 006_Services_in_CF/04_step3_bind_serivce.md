### Step 3: Binding a service instance to your app

You can bind a service instance **after pushing an application**, using the Cloud Foundry CLI with the `cf bind-service APP SERVICE_INSTANCE` command. In this case, you must restart or, sometimes, restage your application to make changes be applied to the VCAP_SERVICES environment variable and to make the application recognize these changes.



Besides binding a service instance to an application after this application has been pushed, you can 
**bind the service instance during push** using the application manifest.

In our sample, we are going to bind the `example-mysql` service instance to the `HelloWorld` application using the application manifest so that the service instance is bound during the application push. Let's change the application’s `manifest.yml` and specify the `example-mysql` service instance binding:

	---
	applications:
	- name: helloworld
	  memory: 512mb
	  instances: 1
	  path: target/helloworld-0.0.1-SNAPSHOT.jar
	  buildpack: https://github.com/cloudfoundry/java-buildpack.git#v3.14
	services:
	- example-mysql

To deploy the updated version, use the `cf push` CLI command:

	$ cf push

	Updating app helloworld in org org / space demo as user...
	...

	Binding service example-mysql to app helloworld in org org / space demo as user...
	OK

	...
	requested state: started
	instances: 1/1
	usage: 512M x 1 instances
	urls: helloworld.[cloud-foundry].com
	last uploaded: Wed Oct 19 09:59:15 UTC 2016
	stack: cflinuxfs2
	buildpack: https://github.com/cloudfoundry/java-buildpack.git

	 state     since                    cpu    memory           disk             details
	#0   running   2016-10-19 01:00:54 PM   0.0%   273.1M of 512M   136.6M of 256M

The output contains a message that says `Binding service example-mysql to app helloworld in org ...`.

Now run the `cf services` command to see the `example-mysql` service now bound to the `HelloWorld` application:

	$ cf services

	name                                       service         plan      bound apps   last operation
	example-mysql                              mysql           default   helloworld   create succeeded