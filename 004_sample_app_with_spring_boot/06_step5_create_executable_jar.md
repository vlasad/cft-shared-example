#### Step 5: Creating an executable JAR

The last step before we can run our app "in production," is to package it as a self-contained executable JAR archive (or a "fat JAR"). The archive will contain all the compiled classes and dependencies required by your code to run.

> **NOTE:** Java does not provide a mechanism to load nested JAR files (JAR files located inside other JARs). You should keep that in mind, if you are looking to build and distribute self-contained Java apps.
> The common solution is to use "uber-JARs"—archives that package classes from all the included JARs. The tradeoff is that you won't be able to easily see what libraries are actually used in the project. Uber-JARs are also known to misbehave if they contain two or more files with the same name, even though the files may have different contents.
> Spring Boot solves this problem and makes it possible to nest JARs directly. You can read more about how this is achieved [here](http://docs.spring.io/spring-boot/docs/current/reference/html/executable-jar.html).

Now let's build an executable JAR by adding the `spring-boot-maven-plugin` to our `pom.xml`. Insert the following lines just below the `dependencies` section:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

> **NOTE:** The `spring-boot-starter-parent` POM includes the <executions> configuration to bind the repackage goal. If you are not planning to use `spring-boot-starter-parent`, you will have to declare this configuration. For more details, see the [plugin documentation](http://docs.spring.io/spring-boot/docs/1.4.1.RELEASE/maven-plugin/usage.html).

Once you have added all the parts, you can save the `pom.xml` file and run the `mvn clean package` command in your terminal to generate the JAR.
    
    $ mvn clean package

    [INFO] Scanning for projects...
    [INFO] ...
    [INFO] ------------------------------------------------------------------------
    [INFO] Building helloworld 0.0.1-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO] .... ..
    [INFO] --- maven-jar-plugin:2.6:jar (default-jar) @ helloworld ---
    [INFO] Building jar: /Users/developer/HelloWorld/target/helloworld-0.0.1-SNAPSHOT.jar
    [INFO]
    [INFO] --- spring-boot-maven-plugin:1.4.1.RELEASE:repackage (default) @ helloworld ---
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------

After running this command, you should get a `helloworld-0.0.1-SNAPSHOT.jar` file in your `target` directory. To examine the file's contents, go to the home directory and run `jar tvf`.

    $ jar tvf target/helloworld-0.0.1-SNAPSHOT.jar

You might have noticed another, much smaller file, called `helloworld-0.0.1-SNAPSHOT.jar.original` in the target directory. This is the JAR file that Maven creates before getting repackaged by Spring Boot.

Finally, you can launch your self-contained app with the `java -jar` command. Go to the home directory and execute:

    $ java -jar target/helloworld-0.0.1-SNAPSHOT.jar

You should see output similar to:

      .   ____          _            __ _ _
     /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
    ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
     \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
      '  |____| .__|_| |_|_| |_\__, | / / / /
     =========|_|==============|___/=/_/_/_/
     :: Spring Boot ::  (v1.4.1.RELEASE)
    ....... . . .
    ....... . . . (log output here)
    ....... . . .
    ........ Started Example in 2.536 seconds (JVM running for 2.864)
    
As before, to gracefully exit the application, hit `ctrl-c`.
