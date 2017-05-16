### Step 4: Accessing a service from your application

Let's change our ‘HelloWorld’ application to read data from the MySQL service.


#### Implementing data access with Spring Data JPA

To implement data access, we are going to use the Spring Data JPA module. Spring Data JPA, a part of the larger Spring Data family, facilitates implementation of JPA-based repositories. The module deals with enhanced Spring support for JPA-based data access layers.

Spring Boot provides a starter for using Spring Data JPA along with Hibernate—`spring-boot-starter-data-jpa`. Add it to your `pom.xml` file:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```

View dependencies that the starter adds to your project by rendering a dependency tree: 

	$ mvn dependency:tree

	...
	[INFO] +- org.springframework.boot:spring-boot-starter-data-jpa:jar:1.4.1.RELEASE:compile
	[INFO] |  +- org.springframework.boot:spring-boot-starter-aop:jar:1.4.1.RELEASE:compile
	[INFO] |  |  \- org.aspectj:aspectjweaver:jar:1.8.9:compile
	[INFO] |  +- org.springframework.boot:spring-boot-starter-jdbc:jar:1.4.1.RELEASE:compile
	[INFO] |  |  +- org.apache.tomcat:tomcat-jdbc:jar:8.5.5:compile
	[INFO] |  |  |  \- org.apache.tomcat:tomcat-juli:jar:8.5.5:compile
	[INFO] |  |  \- org.springframework:spring-jdbc:jar:4.3.3.RELEASE:compile
	[INFO] |  +- org.hibernate:hibernate-core:jar:5.0.11.Final:compile
	[INFO] |  |  +- org.hibernate.javax.persistence:hibernate-jpa-2.1-api:jar:1.0.0.Final:compile
	[INFO] |  |  +- org.javassist:javassist:jar:3.20.0-GA:compile
	[INFO] |  |  +- antlr:antlr:jar:2.7.7:compile
	[INFO] |  |  +- org.jboss:jandex:jar:2.0.0.Final:compile
	[INFO] |  |  +- dom4j:dom4j:jar:1.6.1:compile
	[INFO] |  |  |  \- xml-apis:xml-apis:jar:1.4.01:compile
	[INFO] |  |  \- org.hibernate.common:hibernate-commons-annotations:jar:5.0.1.Final:compile
	[INFO] |  +- org.hibernate:hibernate-entitymanager:jar:5.0.11.Final:compile
	[INFO] |  +- javax.transaction:javax.transaction-api:jar:1.2:compile
	[INFO] |  +- org.springframework.data:spring-data-jpa:jar:1.10.3.RELEASE:compile
	[INFO] |  |  +- org.springframework.data:spring-data-commons:jar:1.12.3.RELEASE:compile
	[INFO] |  |  +- org.springframework:spring-orm:jar:4.3.3.RELEASE:compile
	[INFO] |  |  +- org.springframework:spring-tx:jar:4.3.3.RELEASE:compile
	[INFO] |  |  +- org.slf4j:slf4j-api:jar:1.7.21:compile
	[INFO] |  |  \- org.slf4j:jcl-over-slf4j:jar:1.7.21:compile
	[INFO] |  \- org.springframework:spring-aspects:jar:4.3.3.RELEASE:compile
	...

Now we are going to create a simple POJO, marked as a JPA entity, to represent the data:

```java
package com.example;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Person {

    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
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

The snippet contains a Person class with such attributes, as the `id`, `firstName`, and `lastName`.

> **NOTE:** The default constructor, as well as field getters and setters, only exist for the sake of JPA. You won’t use them directly. The constructor defined as protected by this reason.

The `Person` class uses the `@Entity` annotation, indicating that it is a JPA entity. In the absence of a `@Table` annotation, this entity is mapped to a table named `person`. By default, its properties are mapped to the columns `id`, `first_name`, and `last_name` respectively. The `id` property is marked with the `@Id` and `@GeneratedValue` annotations, so that JPA will recognize it as an auto-generated object ID.

The Spring Data JPA repository abstraction helps to significantly reduce the amount of boilerplate code required to implement data access layers for various persistence stores. Spring Data enables automatic repository implementations from a repository interface at runtime. Now we are going to create a repository interface that works with `Person` entities:

```java
package com.example;

import org.springframework.data.repository.CrudRepository;

public interface PersonRepository extends CrudRepository<Person, Long> {

}
```

`PersonRepository` extends the `CrudRepository` interface. The type of entity and ID that it works with, `Person` and `Long`, are specified in the generic parameters of `CrudRepository`. By extending `CrudRepository`, `PersonRepository` inherits several methods for working with `Person` persistence, including methods for saving, deleting, and finding `Person` entities.

> **NOTE:** In a typical Java application, you’d expect to write a class implementing `PersonRepository`. With Spring Data, you don’t have to write an implementation of the repository interface, as Spring Data creates such an implementation on the fly when you run the application.

> **NOTE:** The Spring Data project provides persistence-technology-specific sub-interfaces to include additional technology-specific methods. It also allows you to define other query methods by simply declaring their method signature in the repository interface.

> **NOTE:** The Spring Data JPA module uses JPA to store data in a relational database. The `spring-boot-starter-data-jpa` Spring Boot starter provides a Spring Data JPA with the Hibernate implementation of JPA. Hibarnate's `SessionFactory` uses JDBC `DataSource` in a nutshell. The `DataSource` injection and configuration is controlled by Spring Boot. So you can simply inject `PersonRepository` and access data with it.

Now we change the `Example` class to auto-wire the `PersonRepository` bean and read `person` data using it. The `home` handler reads all the persons stored in the database, picks a random person, and renders its name in the 'HelloWorld' message:

```java
package com.example;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

@RestController
@EnableAutoConfiguration
public class Example {

    @Autowired
    PersonRepository repository;

    @RequestMapping("/")
    String home() {

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

        return String.format("Hello World!%s",
                person == null ? "" :
                String.format(" My name is %s %s.", person.getFirstName(), person.getLastName()));
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(Example.class, args);
    }
}
```

**TODO!!! - remove this part related to CollectionUtils**

This code uses `org.apache.commons.collections.CollectionUtils`, so you also need to add the Maven dependency to your `pom.xml` file:

```xml
<dependency>
    <groupId>commons-collections</groupId>
    <artifactId>commons-collections</artifactId>
</dependency>
```

> **NOTE:** Spring Boot attempts to determine where your repository definitions are located based on the `@EnableAutoConfiguration` annotation it finds. To get more control, use the `@EnableJpaRepositories` annotation from Spring Data JPA. The same holds true for `@Entity` definitions. To get more control over the entities, use the `@EntityScan` annotation.


#### Populating the database with initial data

Let’s insert some data into the database to see that it is actually read. We are now going to use the `hibernate.ddl-auto=create` setting to force Hibernate to create database tables when initializing `SessionFactory`. Provide the following hibernate properties for the `src/main/resources/application.yml` file:

```yml
---
spring:
  jpa:
    hibernate.ddl-auto: create
    show-sql: true

```

For debugging purposes, we have also enabled the `show-sql` feature to print to the console any SQL requests performed by Hibernate.

>**NOTE:** Specifying the application's external properties in the `application.yml` file is a convenient way in Spring Boot applications.

Now we also need to provide some script that will populate the DB with data. Create an `src/main/resources/import.sql` file and put some entries in there:

```sql
INSERT INTO person(first_name, last_name) VALUES ('Jack', 'Bauer');
INSERT INTO person(first_name, last_name) VALUES ('Chloe', 'Brian');
INSERT INTO person(first_name, last_name) VALUES ('Kim', 'Bauer');
INSERT INTO person(first_name, last_name) VALUES ('David', 'Palmer');
INSERT INTO person(first_name, last_name) VALUES ('Michelle', 'Dessler');
```

Here, we use the Hibernate’s data import feature: an `import.sql` file in the root of the `classpath` executed on startup. It is a Hibernate specific feature and has nothing to do with Spring.
