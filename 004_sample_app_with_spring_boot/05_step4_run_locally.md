#### Step 4: Running the example

At this point, we should already have a working application. The `spring-boot-starter-parent` POM that we have used gives us a convenient `run` goal for launching the app. To start the application, simply got to root folder of your project and type `mvn spring-boot:run`  and hit **Enter**. You will see output similar to this:

    $ mvn spring-boot:run

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
    ........ Started Example in 2.222 seconds (JVM running for 6.514)

To check that the "HelloWorld" application is really working, open [localhost:8080/message](http://localhost:8080/message) with your browser. You should see a page saying "Hello World!"

    Hello World!
    
To gracefully exit the application, hit `ctrl-c`.