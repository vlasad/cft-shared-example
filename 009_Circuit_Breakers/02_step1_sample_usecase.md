### Step 1: Changing the sample application to use a Hystrix circuit breaker

1\. Go to your `HelloWorld` application folder and add the following dependencies in the `pom.xml`:

```xml
<dependencies>
    ...
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-hystrix</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    ...
</dependencies>  
```

We use the `spring-cloud-starter-hystrix` dependency to include Spring Cloud support for Hystrix. Also, we add `spring-boot-starter-actuator` to monitor Hystrix circuit breaker state via the `/health` endpoint provided by Spring Actuator (you have already used Actuator in the previous modules).

2\. Now we are going to move the logic of querying `personservice` to a separate class, wrap the call in a `HystrixCommand`, and provide a fallback logic for this call.

Add the following `PersonService` class to the `src/main/java/com/example` folder:

```java
package com.example;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class PersonService {

    @Autowired
    private RestTemplate restTemplate;

    @HystrixCommand(fallbackMethod = "getDefaultPerson")
    public Person getPerson() {

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

`@HystrixCommand` is part of "javanica", a contrib library by Netflix. Spring Cloud wraps beans marked with the `@HystrixCommand` annotation into a proxy attached to a Hystrix circuit breaker. The circuit breaker, as described above, calculates failures, decides when to open and close the circuit, and what to do in case of failures. In our example, we provide a fallback method, called `getDefaultPerson`, which returns some static content—a person with the name "Mark Twain."

The `Example` class should change like the following:

```java
package com.example;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@RestController
@EnableAutoConfiguration
@ComponentScan
@EnableDiscoveryClient@EnableCircuitBreaker
public class Example {

    @Autowired
    private PersonService personService;

    @RequestMapping("/")
    String home() {

        Person person = personService.getPerson();

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

We put the annotation `@EnableCircuitBreaker` into the `Example` class (normally, the class of a Spring Boot application) to enable a circuit breaker implementation found on the classpath (Hystrix in our case).

Now, instead of querying `personservice` directly, the `Example` class delegates the call to the `personService` bean. Notice the `@ComponentScan` annotation that enables Spring to find the `PersonService` class when auto-wiring the `personService` bean.

3\. By default, Hystrix is configured to open a circuit breaker when it detects `20 failures` (controlled by the `circuitBreaker.requestVolumeThreshold` property). The circuit breaker opens and rejects attempts to make "real" calls to the service for some time (`5 seconds` by default, controlled by the `circuitBreaker.sleepWindowInMilliseconds` property). Then, Hystrix tries to make a "real" call again and checks if the circuit breaker can be closed. So the flow starts from the beginning.

Let's set the `circuitBreaker.requestVolumeThreshold` property for our `getPerson` command to `3`, so that we can open the circuit breaker already after 3 failures:

```yml
...
hystrix:
  command:
    getPerson:
      circuitBreaker:
        requestVolumeThreshold: 3
...
```

> **NOTE:** If you want to set a property for all commands, you should use the *default* command in a property name, e.g., `hystrix.command.default.circuitBreaker.requestVolumeThreshold`.