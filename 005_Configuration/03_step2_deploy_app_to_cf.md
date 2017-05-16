### Step 2: Deploying an application to Cloud Foundry

After you have saved the configuration as a YAML file, you can push your code to Cloud Foundry with a single command:

	cf push

In case you decide to store `manifest.yml` somewhere other than the project's root folder, you will need to tell Cloud Foundry where this file is. To specify the path to the manifest, use the `-f` option followed by the path:

	cf push -f PATH/TO/manifest.yml

Once the application is up and running, the CLI will print a summary:

	...
	requested state: started
	instances: 1/1
	usage: 256M x 1 instances
	urls: helloworld.[cloud-foundry].com
	last uploaded: Tue Oct 12 10:09:27 UTC 2016
	stack: cflinuxfs2
	buildpack: https://github.com/cloudfoundry/java-buildpack.git
	
	     state     since                    cpu    memory         disk          details
	#0   running   2016-10-12 01:10:47 PM   0.0%   856K of 256M   35.5M of 1G
	
If you need to check on your app's health some time later, use the `cf app` command followed by its name:

	cf app {{cf apps | grep started | awk '{print $1}'}} 

Now go to `{{cf apps | grep started | awk '{print $1}'}}.{{echo $CF_DOMAIN}}/message` and check if the app is working. You should see the message:

	Hello World!