#### Step 1: Creating the POM

The first step is to create a `pom.xml` file for Maven. This file will serve as a recipe for building this project.

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

    <!-- Additional lines to be added here... -->

</project>
```    

The above code should give you a working build. Try running `mvn package` to test that it works. You will get the “jar will be empty - no content was marked for inclusion!” warning. Ignore it for now.

If you take a closer look at the POM file, you will notice that our sample application is using a Spring Boot "starter" called `spring-boot-starter-parent` in the `parent` section. This is one of several "starters" available in Spring Boot. The "starters" are Spring Boot's way to simplify adding JARs to your classpath. In our case, `spring-boot-starter-parent` provides some handy defaults for Maven.

> **NOTE:** At closer inspection, you will see that the `spring-boot-starter-parent` also has a section called `dependency-management`. What it does is allow us to use no `version tags` for the "blessed" dependencies.
> Note that all curated dependencies included into each Spring Boot release are managed by Spring Boot. These dependencies are automatically upgraded whenever you upgrade Spring Boot. You can specify particular versions to override Spring Boot's recommendations.
>The curated list includes various Spring modules and a selection of third-party libraries that are supported and can be used with Spring Boot.