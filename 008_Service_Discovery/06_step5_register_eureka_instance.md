### Step 5: Registering a Eureka instance

We will change the `PersonService` application to register its instance in Eureka, making Eureka aware about it, so that Eureka can provide corresponding details to the clients.

1\. Open your `pom.xml` and add the `spring-cloud-starter-eureka` dependency, then, add the `dependencyManagement` section:

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

2\. Put the `@EnableDiscoveryClient` annotation into the `Example` class, so that it looks like this:

```java
package com.example;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

@EnableDiscoveryClient
@RestController
@EnableAutoConfiguration
public class Example {

    @Autowired
    PersonRepository repository;

    @RequestMapping("/person")
    Person getPerson() {

        // get all persons
        Iterator iterator = repository.findAll().iterator();

        // get random person
        Person person = null;
        if(iterator.hasNext()) {
            List<Person> persons = new ArrayList<Person>();
            CollectionUtils.addAll(persons, iterator);
            int randomIndex = new Random().nextInt(persons.size());
            person = persons.get(randomIndex);
        }

        return person;
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(Example.class, args);
    }
}
```

> **NOTE:** In our example there is only one class—`Example`—which serves both as a Spring Boot application and a REST "controller." You should put the `@EnableDiscoveryClient` annotation in one place—the Spring Boot application class. That way, if you have more "controllers" in your code, you won't need to mark them all with this annotation.

> **NOTE:** Because Eureka is the only Service Discovery tool available in our Cloud Foundry deployment, we are using the `@EnableDiscoveryClient` annotation. Otherwise, if you had more options for Service Discovery, you would need to explicitly use the `@EnableEurekaClient` annotation instead to specify that you are working with Eureka.

3\. Add the `eureka-config` service binding into the application's `manifest.yml`:

```yml
applications:
- name: person-service
  ...
  services:
  - eureka-config
  ...

```

We will utilize the `eureka-config` user-provided service to obtain the Eureka server URL.

4\. Add the configuration required to register the service in Eureka. Change `application.yml` to look as follows:

```yml
---
spring:
  jpa:
    hibernate.ddl-auto: create
    show-sql: true
  application:
    name: personservice

eureka:
  client:
    serviceUrl:
      defaultZone: ${vcap.services.eureka-config.credentials.uri:http://localhost:8761/eureka/}
  instance:
    instanceId: ${spring.application.name}:${vcap.application.instance_id:${spring.application.instance_id:${random.value}}}
    hostname: ${vcap.application.application_uris[0]:localhost}
    non-secure-port: 80

```

Here, we set the `spring.application.name` property to register the `PersonService` application as a Eureka instance with the name `personservice`. Eureka clients will use this name to access the service.

We configure the `eureka.client.serviceUrl.defaultZone` property and specify the Eureka server URL in it. The value is obtained from the `vcap.services.eureka-config.credentials.uri` environment variable (the variable is set by Cloud Foundry at the time when the `PersonService` application is deployed, because we are binding the `eureka-config` service to it). The "localhost" URL is used as fallback for local run.

The behavior of the instance is controlled by configuration keys of `eureka.instance.*`:

* `instanceId`—each instance has an instance ID which it registers with Eureka; instance IDs are unique for each app name
* `hostname`—the hostname of the service, which will be used by clients accessing it
* `non-secure-port`—this is the non-secure port from which the instance will get the traffic

> **NOTE:** Because we are running in Cloud Foundry, we set `eureka.instance.hostname` from the application environment variable `vcap.application.application_uris`. And we use fallback to `localhost` for local run.

> **NOTE:** You don't have to set the `eureka.instance.hostname` property if you are running on a machine that knows its own hostname. The hostname is looked up via `java.net.InetAddress` (by default).

> **NOTE:** Use `eureka.instance.non-secure-port: 8080` for the local run (because `personservice` is running on the default port `8080` on localhost). If you want to run in both localhost and Cloud Foundry, put `eureka.instance.non-secure-port: 8080` into `application.yml` to be used during the local run and `eureka.instance.non-secure-port: 80` in `application-cloud.yml` to be used when running in Cloud Foundry.

As soon as we are ready with all the changes, build the `PersonService` application and push it to Cloud Foundry:

    $ mvn clean package
    $ cf push
    
    requested state: started
    instances: 1/1
    usage: 512M x 1 instances
    urls: person-service.[cloud-foundry].com
    last uploaded: Fri Oct 28 15:18:46 UTC 2016
    stack: cflinuxfs2
    buildpack: https://github.com/cloudfoundry/java-buildpack.git

         state     since                    cpu    memory           disk           details
    #0   running   2016-10-28 06:19:40 PM   0.0%   276.2M of 512M   170.5M of 1G

Verify that your service is working fine by opening the `http://person-service.[cloud-foundry].com/person` page:

```json
{
"id": 2,
"firstName": "Chloe",
"lastName": "Brian"
}
```

Now check that the service has registered successfully in the Eureka server dashboard. Open `http://eureka-server.[cloud-foundry].com`:

![Eureka server dashboard - registered service](img/011_Eureka_server_dashboard_service.png)