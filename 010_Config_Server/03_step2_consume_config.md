#### Step 2: Consuming a configuration from a config server in a client application

Let's rework our `HelloWorld` application and add some logging to it. We will use the config server for application configuration (logging level) and see how config changes apply on the fly.

1\. First, we need to add the Spring Cloud Config libraries to our application. Open `pom.xml` and add the `spring-cloud-starter-config` dependency:

```xml
<depenedencies>
    ...
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-config</artifactId>
    </dependency>
    ...
</depenedencies>
```

2\. In `src\main\resources`, add a file called `bootstrap.yml` with the following content:

```yml
spring:
  application.name: helloworld
  cloud.config.uri: ${CLOUD_CONFIG_URI:http://localhost:8888}

```

Here, we set the `spring.application.name` property, so that Spring Cloud Config use it to retrieve configuration for our application from a config server. We also set `spring.cloud.config.uri` to the value of a config server URL. 

> **NOTE:** The configuration used to set up the config client must necessarily be read before the rest of the application’s configuration is read from the config server. That's why we specify the client’s `spring.application.name` and `spring.cloud.config.uri` properties in `bootstrap.yml`, which will be loaded earlier than any other configuration—during the bootstrap phase.

> **NOTE:** We use an environment variable to set a config server URL. It makes sense to create a user-provided service to pass the URL (as we did in the [Service Discovery module](011 - Service Discovery.md)).

Change your application's `manifest.yml` by adding the `CLOUD_CONFIG_URI` environment variable as follows:

```yml
---
applications:
- name: helloworld
  memory: 512mb
  instances: 1
  path: target/helloworld-0.0.1-SNAPSHOT.jar
  buildpack: https://github.com/cloudfoundry/java-buildpack.git
  services:
  - eureka-config
env:
  CLOUD_CONFIG_URI: http://config-server.[cloud-foundry].com

```

3\. Change the `PersonService` class to do some logging:

```java
package com.example;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@RefreshScope
@Component
public class PersonService {

    private static final Logger LOGGER = LoggerFactory.getLogger(PersonService.class);

    @Autowired
    private RestTemplate restTemplate;

    @HystrixCommand(fallbackMethod = "getDefaultPerson")
    public Person getPerson() {
        LOGGER.debug("This is a debug message");

        LOGGER.info("This is an info message");
        return restTemplate.getForObject("http://personservice/person", Person.class);
    }

    public Person getDefaultPerson() {
        Person defaultPerson = new Person();
        defaultPerson.setFirstName("Mark");
        defaultPerson.setLastName("Twain");

        return defaultPerson;
    }
}
```

We mark the `PersonService` bean with the Spring Cloud annotation `@RefreshScope`, so that this bean can re-initialize when there are some configuration changes.

> **NOTE:** A Spring bean marked as `@RefreshScope` gets special treatment when there is a configuration change. Spring Cloud creates such beans as lazy proxies that initialize when they are used. The scope acts as a cache of initialized values. When there are some configuration changes affecting the bean, you can force bean re-initialization by invalidating its cache. This can be done programmatically or via the REST endpoint `/refresh`.

4\. Set the logging level in app configuration. Add the following property to `application.yml`:

```yml
...
logging:
  level:
    com.example: ERROR
...
```

We set the logging level for the `com.example` logger to `ERROR`. The value is different from what we have on the config server (we put `INFO` level there). Because the application uses a config server, the value read from the config server will override the one we set in the application configuration file. So we should see `INFO` messages printed by the `com.example` logger. 