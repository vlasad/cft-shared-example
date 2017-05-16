### Step 3: Creating a Hystrix dashboard

A major advantage of Hystrix is that it can collect metrics for each `HystrixCommand` and display them on a dashboard. This means, you can efficiently monitor the health of each circuit breaker.

To run a Hystrix dashboard in Cloud Foundry, we will create a separate `hystrix-dashboard` application.

1\. Create a folder called `HystrixDashboard` and a `pom.xml` file there with the following contents:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>hystrixdashboard</artifactId>
    <version>0.0.1-SNAPSHOT</version>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.4.1.RELEASE</version>
    </parent>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-hystrix-dashboard</artifactId>
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

Notice that we are using the `spring-cloud-starter-hystrix-dashboard` Spring Cloud starter to include libraries for the embedded Hystrix dashboard.

2\. Add a class running the Spring Boot application. Create the folder `src/main/java/com/example/dashboard` and the `Application` class in it:

```java
package com.example.dashboard;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.cloud.netflix.hystrix.dashboard.EnableHystrixDashboard;

@EnableHystrixDashboard
@EnableAutoConfiguration
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

}
```

The `@EnableHystrixDashboard` annotation in conjunction with the `spring-cloud-starter-hystrix-dashboard` starter make our application run a Hystrix dashboard.

3\. Create the `src/main/resources` folder and the `application.yml` file in it:

```yml
---
server:
  port: ${PORT:8099}

```

Here, we only specify the `server.port` property. No additional properties are required.

4\. Create the `manifest.yml` file:

```yml
---
applications:
- name: hystrix-dashboard
  memory: 512mb
  instances: 1
  path: target/hystrixdashboard-0.0.1-SNAPSHOT.jar
  buildpack: https://github.com/cloudfoundry/java-buildpack.git

```

5\. Build the application and run it in Cloud Foundry:

    $ mvn clean package
    $ cf push
    
    requested state: started
    instances: 1/1
    usage: 512M x 1 instances
    urls: hystrix-dashboard.[cloud-foundry].com
    last uploaded: Thu Nov 3 09:54:14 UTC 2016
    stack: cflinuxfs2
    buildpack: https://github.com/cloudfoundry/java-buildpack.git

         state     since                    cpu    memory          disk         details
    #0   running   2016-11-03 12:54:53 PM   0.0%   31.9M of 512M   149M of 1G
    
6\. Open the dashboard, which should be available at `http://hystrix-dashboard.[cloud-foundry].com/hystrix`. Add the path `http://helloworld.[cloud-foundry].com/hystrix.stream` to monitor the `HelloWorld` application on the dashboard.

![Hystrix dashboard home](https://s3.amazonaws.com/cf-training-resources/cf_for_developers_introduction/009_Hystrix_dashboard.png)

Hit the **Monitor Stream** button.

![Hystrix dashboard for helloworld](https://s3.amazonaws.com/cf-training-resources/cf_for_developers_introduction/009_Hystrix_dashboard_initial.png)

Here, you can see metrics for the `getPerson` Hystrix command. Notice that the circuit breaker is closed.

> **NOTE:** The dashboard shows data in real time and refreshes automatically. Keep the dashboard page opened to see how it will change.

7\. Let's again simulate service failures by stopping `person-service` as we did before. Do not forget to query `http://helloworld.[cloud-foundry].com` 3 times to make Hystrix open the circuit breaker. Now let's observe the changes on the dashboard.

![Hystrix dashboard - open circuit](https://s3.amazonaws.com/cf-training-resources/cf_for_developers_introduction/009_Hystrix_dashboard_open_circuit.png)
 
You can see that the dashboard is saying that a circuit breaker is open. It also shows that it got 100% of errors from the command.  

To learn more about the Hystrix dashboard, visit its [wiki page](https://github.com/Netflix/Hystrix/wiki/Dashboard).


## Learning check

Answer these questions to check your understanding of the topics covered in this module:

1. What is the circuit breaker pattern? Why is it so important to use circuit breakers in a microservices architecture?
2. What do you need to add to your application to run Hystrix with Spring?
3. How can you make vulnerable code to run with a Hystrix circuit breaker?
4. What properties can be used to tune Hystrix circuit breaker behaviour? How are they used in the circuit breaker workflow? What are their default values?
5. How do we create a Hystrix dashboard?