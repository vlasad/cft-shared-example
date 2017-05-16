### Step 3: Solving the Service Discovery problem using environment variables

Let's run the sample applications in Cloud Foundry.

First, we push `PersonService`:

    $ cf push
    
    ...
    Showing health and status for app person-service in org org / space demo as user...
    OK

    requested state: started
    instances: 1/1
    usage: 512M x 1 instances
    urls: person-service.[cloud-foundry].com
    last uploaded: Thu Oct 27 15:45:12 UTC 2016
    stack: cflinuxfs2
    buildpack: https://github.com/cloudfoundry/java-buildpack.git

         state     since                    cpu    memory           disk           details
    #0   running   2016-10-27 06:45:54 PM   0.0%   200.5M of 512M   150.8M of 1G

To verify that everything is ok, access the `/person` endpoint by opening `http://person-service.[cloud-foundry].com/person`:

```json
{
"id": 3,
"firstName": "Kim",
"lastName": "Bauer"
}
```

Now we are ready to run the `HelloWorld` application in the cloud. At this point we are facing the **Service Discovery problem: how can our application know where to find another application in the cloud?**

One of the possible solutions is to set an environment variable with the value of the service routing URL. Let's try this solution in the `HelloWorld` application. Change the `example.person.service.url` property in `application.yml` like this:

```yml
...
example:
  person.service.url: ${PERSON_SERVICE_URL:http://localhost:8080}
...

```

Then, set the `PERSON_SERVICE_URL` environment variable in `manifest.yml`:

```yml
---
applications:
- name: helloworld
  memory: 512mb
  instances: 1
  path: target/helloworld-0.0.1-SNAPSHOT.jar
  buildpack: https://github.com/cloudfoundry/java-buildpack.git
env:
  PERSON_SERVICE_URL: http://person-service.[cloud-foundry].com

```

Now build the application and push it to Cloud:

    $ mvn clean package
    $ cf push
    
    requested state: started
    instances: 1/1
    usage: 512M x 1 instances
    urls: helloworld.[cloud-foundry].com
    last uploaded: Thu Oct 27 16:20:03 UTC 2016
    stack: cflinuxfs2
    buildpack: https://github.com/cloudfoundry/java-buildpack.git

         state     since                    cpu    memory         disk         details
    #0   running   2016-10-27 07:20:38 PM   0.0%   808K of 512M   1.3M of 1G
    
Go to `http://helloworld.[cloud-foundry].com` to see the application home page:

    Hello World! My name is Kim Bauer. I'm using a data service this time.


#### Drawbacks of using environment variables for Service Discovery

The solution that we have just tried solves the problem of Service Discovery, but it also has a serious drawback. This approach is not flexible enough when there are changes in service configuration details—in our case, when a service routing URL changes. Each time it happens, we have to **redeploy** an application with a new service configuration (service URL in our case) to apply the changes. This can be especially problematic if we run multiple applications that use the same service—we have to restart each of them to apply the changes.