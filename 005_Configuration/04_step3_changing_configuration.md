### Step 3: Changing configuration

Our next step will be to modify the configuration of the "HelloWorld" app, so that we have two instances, 
each with 512 MB of RAM. Simply add these parameters to your `manifest.yml`. The resulting file should look as follows:

	---
	applications:
	- name: {{cf apps | grep started | awk '{print $1}'}}
	  memory: 512mb
	  instances: 2
	  path: target/helloworld-0.0.1-SNAPSHOT.jar
	  buildpack: https://github.com/cloudfoundry/java-buildpack.git

Save the manifest and run `cf push` to deploy the modified version of the app:

	cf push
	
Make sure that Cloud Foundry has really launched two instances of "HelloWorld." You can verify that by looking at the output.

	requested state: started
	instances: 2/2
	usage: 512M x 2 instances
	urls: helloworld.{{echo $CF_DOMAIN}}
	last uploaded: Tue Oct 12 10:43:40 UTC 2016
	stack: cflinuxfs2
	buildpack: https://github.com/cloudfoundry/java-buildpack.git
	
	     state     since                    cpu    memory         disk           details
	#0   running   2016-10-12 01:44:37 PM   0.0%   824K of 512M   49.4M of 1G
	#1   running   2016-10-12 01:44:33 PM   0.0%   912K of 512M   136.4M of 1G
	
If you inspect the logs printed by `cf push` while deploying the app, you will see that Cloud Foundry first stops the old version.

	Stopping app helloworld in org org / space demo as user...
	OK
	
After that, two more instances with an updated configuration are started:

	Starting app helloworld in org org / space demo as user...
	Creating container
	Successfully created container
	Downloading app package...
	Downloaded app package (12.1M)
	Downloading build artifacts cache...
	Downloaded build artifacts cache (44.9M)
	Staging...
	-----> Java Buildpack Version: 9bab398 | https://github.com/cloudfoundry/java-buildpack.git#9bab398
	-----> Downloading Open Jdk JRE 1.8.0_101 from https://java-buildpack.cloudfoundry.org/openjdk/trusty/x86_64/openjdk-1.8.0_101.tar.gz (found in cache)
	       Expanding Open Jdk JRE to .java-buildpack/open_jdk_jre (1.1s)
	-----> Downloading Open JDK Like Memory Calculator 2.0.2_RELEASE from https://java-buildpack.cloudfoundry.org/memory-calculator/trusty/x86_64/memory-calculator-2.0.2_RELEASE.tar.gz (found in cache)
	       Memory Settings: -Xss228K -Xmx317161K -XX:MaxMetaspaceSize=64M -Xms317161K -XX:MetaspaceSize=64M
	-----> Downloading Spring Auto Reconfiguration 1.10.0_RELEASE from https://java-buildpack.cloudfoundry.org/auto-reconfiguration/auto-reconfiguration-1.10.0_RELEASE.jar (found in cache)
	Exit status 0
	Staging complete
	Uploading droplet, build artifacts cache...
	Uploading build artifacts cache...
	Uploading droplet...
	Uploaded build artifacts cache (44.9M)
	Uploaded droplet (57.2M)
	Uploading complete
	Destroying container
	Successfully destroyed container
	
	0 of 2 instances running, 2 starting
	0 of 2 instances running, 2 starting
	1 of 2 instances running, 1 starting
	
	App started

Keep in mind that `cf push` causes a complete redeployment of the app, replacing any existing instances with new versions. This operation normally involves some downtime, which makes `cf push` unsuitable for scaling apps in production. 

`cf scale` is a much better alternative for changing instance count without redeploying. Right now, there are two instances of "HelloWorld" running. Let's use `cf scale` to stop one of them.

	cf scale {{cf apps | grep started | awk '{print $1}'}} -i 1
	
Cloud Foundry will instantly decommission one of the instances. It will also run the:

    cf app {{cf apps | grep started | awk '{print $1}'}} 

command again, which will print out a summary:

	requested state: started
	instances: 1/1
	usage: 256M x 2 instances
	urls: helloworld.{{echo $CF_DOMAIN}}
	last uploaded: Tue Oct 12 10:43:40 UTC 2016
	stack: cflinuxfs2
	buildpack: https://github.com/cloudfoundry/java-buildpack.git
	
	     state     since                    cpu    memory           disk             details
	#0   running   2016-10-12 03:31:33 PM   0.1%   301.9M of 512M   136.6M of 256M

