#### Step 3: Writing the code

In order to complete our basic application, let's write a Java file. Before adding the file, we will need to build a folder structure. By default, Maven will compile sources from `src/main/java` and we want to use the `com.example` package. So, our structure will be `src/main/java/com/example/Example.java`.

```java
package com.example;

import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.web.bind.annotation.*;

@RestController
@EnableAutoConfiguration
public class Example {

    @RequestMapping("/message")
    String home() {
        return "Hello World!";
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(Example.class, args);
    }

}
```

Before we proceed, let's take a minute and have a closer look at our code.

**`@RestController` and `@RequestMapping`**—these two annotations are not specific to Spring Boot and you may be familiar with them. The former indicates that a class is a web `@Controller`. The latter contains routing data and maps HTTP requests that use "/" as their path to the home method.

**`@EnableAutoConfiguration`**—this one is a Spring Boot specific annotation. `@EnableAutoConfiguration` automatically configures Spring in line with the JAR dependencies that you provide. For instance, our sample web application uses `spring-boot-starter-web`, which adds Tomcat and Spring MVC. Spring Boot will detect that, assume that you are developing a web application, and automatically configure Spring for you.

> **NOTE:** Although the automated configuration feature is designed to be used with "starters," you can actually specify any JAR dependencies. Spring Boot will try to auto-configure your application, even if the packages/libraries you added are not included into the "starters." 

**`main`**—this method serves as an application entry point. `main` is a standard method for Java apps and follows the regular conventions. In our example, it delegates control to Spring Boot’s `SpringApplication` class by calling `run`. In its turn, `SpringApplication` will start Spring, which will launch the Tomcat web server that gets automatically configured for us. Note that the `run` method will need to have `Example.class` as an argument, so that `SpringApplication` knows which Spring component is primary. Any command-line arguments are exposed by means of passing an `args` array.

