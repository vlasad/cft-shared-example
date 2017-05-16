### Step 4: Deploying multiple applications

In the previous example, we studied how to deploy an application, using configuration from a `manifest.yml` file. But what do we do, if our project generates several artifacts, which should be deployed separately as independent applications?

Fortunately, it is possible to describe multiple applications in a single `manifest.yml` file:

	---
	applications:
	- name: applicationOne
	  instances: 1
	  memory: 256M
	  buildpack: https://github.com/cloudfoundry/java-buildpack.git#v3.14
	  path: target/helloworld-0.0.1-SNAPSHOT.jar
	- name: applicationTwo
	  instances: 1
	  memory: 256M
	  buildpack: https://github.com/cloudfoundry/java-buildpack.git#v3.14
	  path: PATH_TO_ANOTHER_JAR/demo.jar

Running `cf push` with the above `manifest.yml` will produce two independent applications: "applicationOne" and "applicationTwo." 

If you look at this sample manifest, you will notice that a lot of the parameters are the same for both apps: memory, buildpack, and number of instances. Identical parameters can be defined "globally" in the manifest:

	---
	instances: 1
	memory: 256M
	buildpack: https://github.com/cloudfoundry/java-buildpack.git#v3.14
	applications:
	- name: applicationOne
	  path: target/helloworld-0.0.1-SNAPSHOT.jar
	- name: applicationTwo
	  path: PATH_TO_ANOTHER_JAR/demo.jar


In addition to the possibility to describe more than one application in a single manifest, there is another powerful feature—manifest inheritance. Cloud Foundry allows users to create multiple manifests with parent-child relationships where children inherit parent configuration. Children can use inherited descriptions unmodified, provide additional parameters, or override the parameters provided by their parent. Here is an example:

`manifest_parent.yml`:

	---
	instances: 1
	memory: 256M
	buildpack: https://github.com/cloudfoundry/java-buildpack.git#v3.14
	applications:
	- name: applicationOne
	  path: target/helloworld-0.0.1-SNAPSHOT.jar

To create a child manifest, add an "inherit" line pointing to a parent manifest immediately after the three dashes at the top of the child. To override parent configuration, define the new value in the child, like so:

`manifest_child.yml`:

	---
	inherit: manifest_parent.yml
	applications:
	- name: applicationTwo
	  path: PATH_TO_ANOTHER_JAR/demo.jar
	  memory: 512M 
	  
In this example, you can see that "applicationTwo" inherits from manifest_parent.yml, but it needs 512 MB of RAM instead of 256 MB defined in the parent, which contains configuration for  "applicationOne".

This feature can come in handy in a number of scenarios, for instance:

* One application may have a base parent manifest and several children, describing different deployment modes, e.g., debug, local, and public.
* An application can have a basic configuration specified in a parent manifest. Users can add new properties or override these settings by creating child manifests.