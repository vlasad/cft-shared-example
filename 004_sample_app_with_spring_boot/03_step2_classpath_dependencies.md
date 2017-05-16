#### Step 2: Adding classpath dependencies

Besides the Maven defaults provided by `spring-boot-starter-parent`, your application is likely to need other dependencies too. Ours is a web application, so we probably also want to add the `spring-boot-starter-web` dependency. But first, let's run the `mvn dependency:tree` command and have a look at what we have so far:

    $ mvn dependency:tree

    [INFO] com.example:helloworld:jar:0.0.1-SNAPSHOT
    
The output should be a tree representation of the dependencies for your project. You may notice that `spring-boot-starter-parent` does not provide any dependencies by itself. Now let's add `spring-boot-starter-web` right after the `parent` section.

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

Save and run `mvn dependency:tree` again. In the output, you should see some new dependencies that have been added, including Spring Boot and the Tomcat web server.

    $ mvn dependency:tree

    [INFO] com.example:helloworld:jar:0.0.1-SNAPSHOT
    [INFO] \- org.springframework.boot:spring-boot-starter-web:jar:1.4.1.RELEASE:compile
    [INFO]    +- org.springframework.boot:spring-boot-starter:jar:1.4.1.RELEASE:compile
    [INFO]    |  +- org.springframework.boot:spring-boot:jar:1.4.1.RELEASE:compile
    [INFO]    |  +- org.springframework.boot:spring-boot-autoconfigure:jar:1.4.1.RELEASE:compile
    [INFO]    |  +- org.springframework.boot:spring-boot-starter-logging:jar:1.4.1.RELEASE:compile
    [INFO]    |  |  +- ch.qos.logback:logback-classic:jar:1.1.7:compile
    [INFO]    |  |  |  +- ch.qos.logback:logback-core:jar:1.1.7:compile
    [INFO]    |  |  |  \- org.slf4j:slf4j-api:jar:1.7.21:compile
    [INFO]    |  |  +- org.slf4j:jcl-over-slf4j:jar:1.7.21:compile
    [INFO]    |  |  +- org.slf4j:jul-to-slf4j:jar:1.7.21:compile
    [INFO]    |  |  \- org.slf4j:log4j-over-slf4j:jar:1.7.21:compile
    [INFO]    |  +- org.springframework:spring-core:jar:4.3.3.RELEASE:compile
    [INFO]    |  \- org.yaml:snakeyaml:jar:1.17:runtime
    [INFO]    +- org.springframework.boot:spring-boot-starter-tomcat:jar:1.4.1.RELEASE:compile
    [INFO]    |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:8.5.5:compile
    [INFO]    |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:8.5.5:compile
    [INFO]    |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:8.5.5:compile
    [INFO]    +- org.hibernate:hibernate-validator:jar:5.2.4.Final:compile
    [INFO]    |  +- javax.validation:validation-api:jar:1.1.0.Final:compile
    [INFO]    |  +- org.jboss.logging:jboss-logging:jar:3.3.0.Final:compile
    [INFO]    |  \- com.fasterxml:classmate:jar:1.3.1:compile
    [INFO]    +- com.fasterxml.jackson.core:jackson-databind:jar:2.8.3:compile
    [INFO]    |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.8.3:compile
    [INFO]    |  \- com.fasterxml.jackson.core:jackson-core:jar:2.8.3:compile
    [INFO]    +- org.springframework:spring-web:jar:4.3.3.RELEASE:compile
    [INFO]    |  +- org.springframework:spring-aop:jar:4.3.3.RELEASE:compile
    [INFO]    |  +- org.springframework:spring-beans:jar:4.3.3.RELEASE:compile
    [INFO]    |  \- org.springframework:spring-context:jar:4.3.3.RELEASE:compile
    [INFO]    \- org.springframework:spring-webmvc:jar:4.3.3.RELEASE:compile
    [INFO]       \- org.springframework:spring-expression:jar:4.3.3.RELEASE:compile