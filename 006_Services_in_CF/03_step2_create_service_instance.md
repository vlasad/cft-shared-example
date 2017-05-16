### Step 2: Creating a service instance with the Cloud Foundry CLI

To create a service instance, use the `cf create-service SERVICE PLAN SERVICE_INSTANCE` command, where:

* `SERVICE` is the service that you choose.
* `PLAN` is the service plan that enables users to get access to different sets of features and resource quotas for the same service.
* `SERVICE_INSTANCE` is the name for your service instance—a meaningful alias you provide that can be changed at any time. Any series of alphanumeric characters, hyphens (-), and underscores (_) are allowed.

Now, let's create a `mysql` service instance for our sample application:

	$ cf create-service mysql 512mb example-mysql

	Creating service instance example-mysql in org org / space demo as user...
	OK

Use the `cf services` command to list the service instances in your targeted space. The output will display the bound apps, if any, and the state of the last operation requested for this service instance:

	$ cf services

	Getting services in org org / space demo as user...
	OK

	name            service   plan      bound apps   last operation
	example-mysql   mysql     default                create succeeded

The output snippet shows details of the service instance that we have just created named `example-mysql`, and that there are no applications currently bound to this instance.