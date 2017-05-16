### Step 4: Service Discovery with Netflix Eureka

As we have learned, service discovery is one of the key components of any microservice-based architecture. Eureka is a service discovery server and client built by Netflix and supported in Cloud Foundry. In this step, we will use Eureka to register our services, so that they can talk to and get information about each other.

One of the advantages of Eureka is that it is easy to use with Spring. Once services are registered as Eureka instances, clients can discover them using Spring-managed beans. To create an embedded Eureka server, we can use declarative Java configuration.

Let's change our sample to use Eureka for Service Discovery in Cloud Foundry.


#### Running Eureka server

As the first step, we need to deploy a separate application running a Eureka server.

1\. Create a new folder, called `EurekaServer`, to host the application.

2\. Create a `pom.xml` file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>eurekaserver</artifactId>
    <version>0.0.1-SNAPSHOT</version>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.4.1.RELEASE</version>
    </parent>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-eureka-server</artifactId>
        </dependency>
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

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                </configuration>
            </plugin>
        </plugins>
    </build>

</project>
```

To include Eureka server in our project, we use the Spring Cloud starter `spring-cloud-starter-eureka-server`. We also specify the `dependencyManagement` section for it as described on the [Spring Cloud Project page](http://projects.spring.io/spring-cloud/).

> **NOTE:** Spring Cloud builds on Spring Boot by providing a number of libraries that enhance the behavior of your application when added to the classpath.

3\. Create the `src/main/java/com/example/registry` folder and the `Application` class in it:

```java
package com.example.registry;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@EnableEurekaServer
@EnableAutoConfiguration
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

}
```

We annotate the `Application` class with the already familiar Spring Boot annotation—`@EnableAutoConfiguration`—to enable Spring Boot auto-configuration. We also add the `@EnableEurekaServer` annotation of the Spring Cloud Netflix module. This annotation makes the application run a Eureka server. The server has a home page with a UI and HTTP API endpoints provided by the standard Eureka functionality under `/eureka/*`.

> **NOTE:** Eureka server has no backend store. The service instances in the registry all have to send heartbeats to keep their registrations up-to-date (so this can be done in-memory). Clients also have an in-memory cache of Eureka registrations, so they don’t have to go to the registry for every single request to a service.

4\. Disable Eureka client-side behavior on the server

In the default configuration, Eureka server also works as a client. This means it has to have one or more service URLs, which it can use to locate its peer. If you choose to provide no service URL, Eureka server will work, but you will be getting a lot of log messages saying that Eureka couldn't register with any peers.

This is why, in our example, we will switch off the client-side behavior.

Create the `src/main/resources` folder and the `application.yml` configuration file in it:

```yml
---
server:
  port: ${PORT:8761}

eureka:
  client:
    registerWithEureka: false
    fetchRegistry: false

```

The client side behavior of Eureka can be switched off by setting the `eureka.client.registerWithEureka: false` and `eureka.client.fetchRegistry: false` properties.
Notice that we also set the `server.port` property via the `PORT` environment variable (assigned to application by Cloud Foundry when running in the cloud) with fallback to `8761` (Eureka server’s default port used for local run).

5\. Now create an application manifest file and name it `manifest.yml`:

```yml
---
applications:
- name: eureka-server
  memory: 512mb
  instances: 1
  path: target/eurekaserver-0.0.1-SNAPSHOT.jar
  buildpack: https://github.com/cloudfoundry/java-buildpack.git

```

Next, build the application and push it to Cloud Foundry:

    $ mvn clean package
    $ cf push
    
    requested state: started
    instances: 1/1
    usage: 512M x 1 instances
    urls: eureka-server.[cloud-foundry].com
    last uploaded: Fri Oct 28 11:04:52 UTC 2016
    stack: cflinuxfs2
    buildpack: https://github.com/cloudfoundry/java-buildpack.git

         state     since                    cpu    memory           disk           details
    #0   running   2016-10-28 02:05:35 PM   0.0%   332.2M of 512M   161.1M of 1G
    
Now open your web browser at `http://eureka-server.[cloud-foundry].com` and see the Eureka server dashboard:

![Eureka server dashboard](img/011_Eureka_server_dashboard.png)

6\. One more thing that we are going to do is create a user-provided service storing the Eureka server URL. We will use this service afterwards to deliver the Eureka server URL to our client application.

To create a user-provided service in Cloud Foundry, open the CLI and execute the command `cf cups SERVICE_INSTANCE -p '{"PARAM1":"VALUE1", "PARAM2":"VALUE2", ...}'`:

    $ cf cups eureka-config -p '{"uri":"http://eureka-server.[cloud-foundry].com/eureka"}'
    
    Creating user provided service eureka-config in org org / space demo as user...
    OK

> **NOTE:** When passing the parameter string, remember about the specifics of the command line on your OS. E.g. on Windows you should use double quotes to wrap the JSON and escape the double quotes inside it:
>    
>       cf cups eureka-config -p "{\"uri\":\"http://eureka-server.[cloud-foundry].com/eureka\"}"

Now check your service via the `cf services` command:

    $ cf services
    
    Getting services in org org / space demo as user...
    OK

    name             service         plan      bound apps   last operation
    ...
    eureka-config    user-provided