### Step 1: Listing available marketplace services
The lists of marketplace services exposed to a specific organization may differ. To view the list of services available to your target organization, run `cf marketplace`.

	$ cf marketplace

	Getting services from marketplace in org org / space demo as user...
	OK

	service          plans     description
	app-autoscaler   default   Automatically increase or decrease the number of application instances based on a policy you define.
	mysql            default   Default service
	redis            default   Default service
	rmq              default   Default service
	sso-routing      default   Application single sign-on service broker

	TIP:  Use 'cf marketplace -s SERVICE' to view descriptions of individual plans of a given service. 

The output contains a TIP suggesting that you can use the `cf marketplace -s SERVICE` command to view details of different plans within a given service. Let's see the plans available for the `mysql` service:

	$ cf marketplace -s mysql

	Getting service plan information for service mysql as user...
	OK

	service plan   description    free or paid
	default        default plan   free