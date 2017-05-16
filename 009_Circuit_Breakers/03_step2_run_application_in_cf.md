### Step 2: Trying out the Hystrix circuit breaker in Cloud Foundry

In this step, we are assuming that the `eureka-server` and `person-service` applications that were used in the previous module are still running in Cloud Foundry:

    $ cf a
    
    name                requested state   instances   memory   disk   urls
    eureka-server       started           1/1         512M     1G     eureka-server.[cloud-foundry].com
    person-service      started           1/1         512M     1G     person-service.[cloud-foundry].com

Now let's build the `HelloWorld` application and push it to Cloud Foundry. From the `HelloWorld` folder, execute:

    $ mvn clean package
    $ cf push
    
    requested state: started
    instances: 1/1
    usage: 512M x 1 instances
    urls: helloworld.[cloud-foundry].com
    last uploaded: Wed Nov 2 16:15:37 UTC 2016
    stack: cflinuxfs2
    buildpack: https://github.com/cloudfoundry/java-buildpack.git

         state     since                    cpu      memory           disk           details
    #0   running   2016-11-02 07:16:27 PM   194.7%   340.6M of 512M   160.1M of 1G

Go to `http://helloworld.[cloud-foundry].com` to see the application's home page:

    Hello World! My name is Kim Bauer. I'm using a data service this time.

You should see person details retrieved from the database (any person, except for the fallback "Mark Twain").

Open the `http://helloworld.[cloud-foundry].com/health` page to see some information on our application's health, which also includes Hystrix state:

```json
...
"hystrix": {
  "status": "UP"
}
...
```

Now let's get some service failures to see the circuit breaker in action. We will stop the `person-service` application to make `HelloWorld` get a failure each time it calls the `personservice/person` endpoint:

    $ cf stop person-service
    
    Stopping app person-service in org org / space demo as user...
    OK

Go back to the `http://helloworld.[cloud-foundry].com` page and see the message that is getting printed:

    Hello World! My name is Mark Twain. I'm using a data service this time.
    
You will see that the message says "Mark Twain," which means the fallback method worked this time. 

Let's check the circuit breaker state on the application health page `http://helloworld.[cloud-foundry].com/health`:

```json
...
"hystrix": {
  "status": "UP"
}
...
```

Hystrix is up, there is no circuit breaker opened.

Now we need to reach the threshold of 3 failures (the value we have set for `circuitBreaker.requestVolumeThreshold`) to open the circuit breaker. Refresh your application's home page `http://helloworld.[cloud-foundry].com` 3 times. Each time, you should see "Mark Twain" on the page. Now go back to the health page `http://helloworld.[cloud-foundry].com/health`, refresh it, and check the state of Hystrix again:

```json
...
"hystrix": {
  "status": "CIRCUIT_OPEN",
  "openCircuitBreakers": [
    "PersonService::getPerson"
  ]
}
...
```

You will see that the circuit breaker opened this time.

> **NOTE:** Hystrix may need some time to change its state (no more than 5 seconds in our case—the default `circuitBreaker.sleepWindowInMilliseconds` time interval).

Now let's make the circuit breaker close. To do so, we need to start getting successful results when querying `personservice`. Let's start `person-service` first:

    $ cf start person-service
    
    requested state: started
    instances: 1/1
    usage: 512M x 1 instances
    urls: person-service.[cloud-foundry].com
    last uploaded: Wed Nov 2 16:11:06 UTC 2016
    stack: cflinuxfs2
    buildpack: https://github.com/cloudfoundry/java-buildpack.git

         state     since                    cpu    memory           disk           details
    #0   running   2016-11-03 12:28:22 PM   0.0%   322.2M of 512M   170.5M of 1G

Now open the application's home page `http://helloworld.[cloud-foundry].com`. You should see a person's details retrieved from the database again:

    Hello World! My name is Michelle Dessler. I'm using a data service this time.
    
Check the health page `http://helloworld.[cloud-foundry].com/health`. You should see a closed circuit breaker:

```json
...
"hystrix": {
  "status": "UP"
}
...
```

> **NOTE:** It may take some time for Hystrix to change its state (no more than 5 seconds in our case—the default `circuitBreaker.sleepWindowInMilliseconds` time _interval)._