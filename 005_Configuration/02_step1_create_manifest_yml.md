### Step 1: Creating `manifest.yml`

Cloud Foundry retrieves configuration details from manifest files written in YAML. By default, Cloud Foundry looks for your project's `manifest.yml` file in its `ROOT` directory.

To deploy the static "HelloWorld" application, we used the following command:

	cf push helloworld -b https://github.com/cloudfoundry/staticfile-buildpack.git

As our next step, let's write a `manifest.yml` file for our app and store it in the root folder of the project. Open a text editor and add the following lines to your manifest:

	---
	applications:
	- name: {{cf apps | grep started | awk '{print $1}'}}
	  memory: 256mb
	  instances: 1
	  path: target/helloworld-0.0.1-SNAPSHOT.jar
	  buildpack: https://github.com/cloudfoundry/java-buildpack.git#v3.14

Some of the major parameters that can be defined in a YAML manifest are:

* **Name**: This is the name of your project. It can include any alphanumeric characters, however, spaces are not allowed.
* **Memory limit**: This parameter sets the max amount of memory per app instance. If an instance consumes more than is allowed in the manifest, Cloud Foundry will automatically restart it.
* **Instances**: The best way to minimize downtime is to have several instances of the same app running at the same time. The general recommendation is that any production app should have at least two instances. Still, you may be more comfortable running a single instance on the development stage for simpler debugging.
* **Path**: This is where you specify the exact location of the project that Cloud Foundry needs to deploy. When you push an application to the platform, the corresponding buildpack will examine user-provided artifacts to figure out what kind of dependencies the app needs and then download those dependencies. The buildpack also uses this information to decide what configuration should be applied to the app, so that the app can communicate with bound services.
