### Step 7: Creating a Eureka client

Now we are going to edit the `HelloWorld` application, so that it can query the `personservice` service registered in Eureka.

As with `PersonService`, we should annotate our application as `@EnableDiscoveryClient` to use Eureka. By default, `@EnableDiscoveryClient` makes the app become both a Eureka "instance" (i.e. it registers itself) and a "client" (i.e. it can query the registry to locate other services). Because our `HelloWorld` app is just going to query a Eureka-registered service (`personservice`) and it is not supposed to be accessed by any clients, we don't need to register it as a Eureka "instance." To switch off the registration, we need to additionally set `eureka.client.registerWithEureka: false` in the application properties.

Let's start implementing the changes.

1\. Open your `pom.xml`, then, add the `spring-cloud-starter-eureka` dependency and a `dependencyManagement` section for it:

```xml
<dependencies>
    ...
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-eureka</artifactId>
    </dependency>
    ...
</dependencies>

<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>Camden.SR1</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

2\. Put the `@EnableDiscoveryClient` annotation into the `Example` class. Change the `home` method to query `personservice` registered in Eureka:

```java
package com.example;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@RestController
@EnableAutoConfiguration
@EnableDiscoveryClient
public class Example {

    @Autowired
    private RestTemplate restTemplate;


    @RequestMapping("/")
    String home() {

        Person person = restTemplate.getForObject("http://personservice/person", Person.class);

        return String.format("Hello World!%s",
                person == null ? "" :
                        String.format(" My name is %s %s. I'm using a data service this time.", person.getFirstName(), person.getLastName()));
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(Example.class, args);
    }

    @Bean
    @LoadBalanced
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        return builder.build();
    }
}
```

> **NOTE:** Our `RestTemplate` bean is now also marked as `@LoadBalanced`. This tells Spring Cloud that we want to use its client-side load balancing feature provided with the Netflix Ribbon load balancer. Print the dependency tree to see the library included:
>
>       $ mvn dependency:tree
>
>       [INFO] --- maven-dependency-plugin:2.10:tree (default-cli) @ helloworld ---
>       [INFO] com.example:helloworld:jar:0.0.1-SNAPSHOT
>       ...
>       [INFO] \- org.springframework.cloud:spring-cloud-starter-eureka:jar:1.2.1.RELEASE:compile
>       ...
>       [INFO]    +- org.springframework.cloud:spring-cloud-starter-ribbon:jar:1.2.1.RELEASE:compile
>       [INFO]    |  +- com.netflix.ribbon:ribbon:jar:2.2.0:compile
>       [INFO]    |  |  +- com.netflix.ribbon:ribbon-transport:jar:2.2.0:runtime
>       ...
>       [INFO]    +- com.netflix.ribbon:ribbon-eureka:jar:2.2.0:compile
>       ...
>
> We define the Ribbon-aware `RestTemplate` bean in our `Example` class to access `personservice` using it. Note that the URI we are querying uses the service name, `personservice`, not an actual hostname. The service name from the URI is extracted and passed to Ribbon, which then uses a built-in load balancer to pick from among the registered instances in Eureka and, finally, the HTTP call is made to a real service instance.

3\. Provide the necessary configuration in `application.yml`:

```yml
---
server:
  port: ${PORT:8090}

eureka:
  client:
    registerWithEureka: false
    serviceUrl:
      defaultZone: ${vcap.services.eureka-config.credentials.uri:http://localhost:8761/eureka/}

```

Here, we set `eureka.client.registerWithEureka: false` to disable instance registering in Eureka and provide `eureka.client.registerWithEureka.serviceUrl.defaultZone` with the Eureka server URL (like in `PersonService`, it is obtained from the `eureka-config` user-provided service).

4\. Bind the application to the `eureka-config` service to get Eureka server URL when running in the cloud. Change `manifest.yml`:

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

```

Now, as we are ready with the changes, let's build the application and push it to Cloud Foundry:

    $ mvn clean package
    $ cf push
    
    requested state: started
    instances: 1/1
    usage: 512M x 1 instances
    urls: helloworld.[cloud-foundry].com
    last uploaded: Mon Oct 31 14:47:40 UTC 2016
    stack: cflinuxfs2
    buildpack: https://github.com/cloudfoundry/java-buildpack.git

         state     since                    cpu    memory           disk           details
    #0   running   2016-10-31 05:48:24 PM   0.0%   174.6M of 512M   157.1M of 1G
    
Go to `http://helloworld.[cloud-foundry].com` to see the application's home page:

    Hello World! My name is Kim Bauer. I'm using a data service this time.


## Learning check

Answer these questions to check your understanding of the Title concepts:

1. What is Service Discovery and why is it so important in the cloud?
2. In what ways can the Service Discovery problem be solved?
3. What are the drawbacks of solving the Service Discovery problem by using environment variables?
4. How can Eureka be used (injected) in a Java application?
5. What annotation should be used to turn an application into a Eureka server? Do we need any additional configuration for a server application?
6. What is the difference between a Eureka "instance" and Eureka "client"?
7. What annotation(s) should be used to make an application a Eureka instance and client? How can we switch off instance registration while creating a Eureka client?
8. How can we specify a Eureka server URL in instances/clients?
9. By what ID are instances registered in Eureka? How does a client access a specific registered service?
10. Why do we use Ribbon load-balancing when accessing services registered in Eureka?
