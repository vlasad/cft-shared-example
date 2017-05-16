### Step 2: Creating sample applications

1\. Create `PersonService` application, which provides a `/person` endpoint sending person data read from the database.

We will use the sample `HelloWorld` application from the "Services in Cloud Foundry" lesson. Make sure to copy its sources to a directory called `PersonService` (you should create it first). Then open the `pom.xml` file and rename its `artifactId` like this:

    ...
    <artifactId>personservice</artifactId>
    ...

Also change its `manifest.yml` to use the new name:

    ...
    - name: person-service
      ...
      path: target/personservice-0.0.1-SNAPSHOT.jar
    ...

Then, we need to create a `/person` endpoint. Open the `Example` class and replace the `home` method with the `getPerson` method, so that it looks like this:

```java
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
```

To verify your changes, build and then run the application:

    $ mvn clean package
    $ java -jar target/personservice-0.0.1-SNAPSHOT.jar
    
    ...
    2016-10-27 13:03:06.578  INFO 12640 --- [           main] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat started on port(s): 8080 (http)
    2016-10-27 13:03:06.588  INFO 12640 --- [           main] com.example.Example                      : Started Example in 9.151 seconds (JVM running for 9.729)

Now open the [localhost:8080/person](http://localhost:8080/person) page. You should get a JSON encapsulating `Person` data, e.g.:

```json
{
"id": 3,
"firstName": "Kim",
"lastName": "Bauer"
}
```

2\. Change the `HelloWorld` application to get person details from `PersonService` by calling its `/person` endpoint.

First of all, delete all the database-related stuff: remove `PersonRepository`, `application-cloud.yml`, and `import.sql`.
Then, remove all JPA annotations from the `Person` entity (we still need to keep the entity to store person details retrieved from the service):

```java
package com.example;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Person {

    private Long id;
    private String firstName;
    private String lastName;

    protected Person() {}

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
}
```

Now let's rework the `Example` class to do an HTTP call to the `PersonService` to get a person:

```java
@RestController
@EnableAutoConfiguration
public class Example {

    @Autowired
    private RestTemplate restTemplate;

    @Value("${example.person.service.url}")
    private String personServiceUrl;


    @RequestMapping("/")
    String home() {

        Person person = restTemplate.getForObject(personServiceUrl + "/person", Person.class);

        return String.format("Hello World!%s",
                person == null ? "" :
                        String.format(" My name is %s %s. I'm using a data service this time.", person.getFirstName(), person.getLastName()));
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(Example.class, args);
    }

    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        return builder.build();
    }
}
```

You can see that we are using Spring’s `RestTemplate` as a REST client.

We set the URL of `PersonService` via the `example.person.service.url` property in `application.yml`:

```yml
---
example:
  person.service.url: http://localhost:8080
  
server:
  port: ${PORT:8090}  
```

These are all the properties that we will need for our application.

> **Note:** We also specify the application's `server.port: ${PORT:8090}` with a value of the environment variable `PORT` (set by Cloud Foundry when running in the cloud) with fallback to port `8090` to be used on localhost (the default port `8080` is already in use by `PersonService`).

The only dependency we need for our application is `spring-boot-starter-web`. So change the `pom.xml` as follows:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>helloworld</artifactId>
    <version>0.0.1-SNAPSHOT</version>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.4.1.RELEASE</version>
    </parent>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>

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

Now you are ready to build and start the `HelloWorld` application on the localhost:

    $ mvn clean package
    $ java -jar target/helloworld-0.0.1-SNAPSHOT.jar

    ...
    2016-10-27 18:57:04.566  INFO 12736 --- [           main] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat started on port(s): 8090 (http)
    2016-10-27 18:57:04.572  INFO 12736 --- [           main] com.example.Example                      : Started Example in 3.956 seconds (JVM running for 4.438)
    ...

Open your browser at `[localhost:8090](http://localhost:8090)` and you should see the application home page with a greeting message printed on it:

    Hello World! My name is Chloe Brian. I'm using a data service this time.
