#### Step 1: Running a config server in Cloud Foundry

Let's create a simple Java application running a config server.

1\. Create the folder `ConfigServer` and the Maven project file `pom.xml` in it:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>configserver</artifactId>
    <version>0.0.1-SNAPSHOT</version>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.4.1.RELEASE</version>
    </parent>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-config-server</artifactId>
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

Notice that we are using the `spring-cloud-config-server` dependency. It adds Spring Cloud Config Server libraries to the project.

2\. Add a Java class to run a Spring Boot application, which, in turn, runs a config server. Create the folder `src\main\java\com\example\config` and the `Application` class in it:

```java
package com.example.config;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.cloud.config.server.EnableConfigServer;

@EnableConfigServer
@EnableAutoConfiguration
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

}
```

This is an ordinary Spring Boot application class with auto configuration for Spring enabled. We use the `@EnableConfigServer` annotation to make it run a config server. 

Now we need to provide the necessary configuration for the config server. Create the folder `src\main\resources` and the `application.yml` config file in it:

```yml
---
server:
  port: ${PORT:8888}

spring.cloud.config.server.git.uri: https://[my-git-repository].git

```

Here, we set the already familiar property, `server.port`, for a Spring Boot application. The `spring.cloud.config.server.git.uri` property sets a Git repository to use as config server storage. 

> **NOTE:** Make sure to provide a path to an existing repository or create one in advance.

3\. Put some configuration onto the config server

Let's create a configuration file and push it to the Git repository that we use as config server storage. Create the file `helloworld.yml` with the following content:

```yml
---
logging:
  level:
    com.example: INFO

```

In this configuration, we set the logging level of the `com.example` logger to `INFO`. The file is named `helloworld.yml`, which makes this configuration applicable to the `helloworld` application's `default` profile.

4\. Create `manifest.yml`, the deployment manifest:

```yml
---
applications:
- name: config-server
  memory: 512mb
  instances: 1
  path: target/configserver-0.0.1-SNAPSHOT.jar
  buildpack: https://github.com/cloudfoundry/java-buildpack.git

```

5\. Build the application and run it in Cloud Foundry:

    $ mvn package
    $ cf push
    
    requested state: started
    instances: 1/1
    usage: 512M x 1 instances
    urls: config-server.[cloud-foundry].com
    last uploaded: Tue Nov 8 12:37:50 UTC 2016
    stack: cflinuxfs2
    buildpack: https://github.com/cloudfoundry/java-buildpack.git

         state     since                    cpu    memory           disk           details
    #0   running   2016-11-08 03:39:22 PM   0.0%   221.6M of 512M   144.6M of 1G

Now open the page `http://config-server.[cloud-foundry].com/helloworld/default` to get the configuration stored on the config server for the application `HelloWorld` with the `default` profile:

```json
{
  "name": "helloworld",
  "profiles": [
    "default"
  ],
  "label": "master",
  "version": "681024e676288cd3c36d7b8b18949c4ea603e08f",
  "state": null,
  "propertySources": [
  {
    "name": "https://[my-git-repository].git/helloworld.yml",
    "source": {
      "logging.level.com.example": "INFO"
    }
  }
  ]
}
```

> **NOTE:** The default strategy used by a config server to locate property sources is to clone a Git repository (at `spring.cloud.config.server.git.uri`) and use it to initialize a mini `SpringApplication`. The mini-application’s `Environment` is used to enumerate property sources and publish them via a JSON endpoint.
>
> The HTTP service provides resources in the following format:
>
> * /{application}/{profile}[/{label}]
> * /{application}-{profile}.yml
> * /{label}/{application}-{profile}.yml
> * /{application}-{profile}.properties
> * /{label}/{application}-{profile}.properties
>
> Where the "application" is a Spring application's name (maps to "spring.application.name" on the client side), "profile" is an active Spring profile (maps to "spring.profiles.active" on the client, a comma separated list), and "label" is an optional Git label (defaults to "master").
