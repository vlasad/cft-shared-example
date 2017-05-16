### Step 3: Deploying an application to Cloud Foundry

Use the Cloud Foundry CLI to run the `cf push` command and deploy your app. 
For details, see the "Installing the Cloud Foundry CLI" section in one of the previous modules. 
As soon as the `push` command has been issued, Cloud Foundry performs the following actions to make the application available:

1. Uploads and saves app files
2. Verifies and saves app metadata
3. Creates a “droplet” (the Cloud Foundry unit of execution) for the app
4. Selects an appropriate Diego cell or Droplet Execution Agent (DEA) to run the droplet
5. Starts the app

To push the demo application to Cloud Foundry, use the `cf push` command (for more information about deployment options, see other training modules):

        cf push helloworld -b https://github.com/cloudfoundry/staticfile-buildpack.git

The output will be similar to this:

        Updating app helloworld in org org / space demo as user...
        OK

        Uploading helloworld...
        Uploading app files from: /Users/user/Documents/helloworld
        Uploading 180B, 1 files
        Done uploading
        OK

        Starting app helloworld in org org / space demo as user...
        Creating container
        Successfully created container
        Downloading app package...
        Downloaded app package (210B)
        Downloading build artifacts cache...
        Downloaded build artifacts cache (108B)
        Staging...
        -------> Buildpack version 1.3.11
        Downloaded [https://buildpacks.cloudfoundry.org/concourse-binaries/nginx/nginx-1.11.4-linux-x64.tgz]
        -----> Using root folder
        -----> Copying project files into public/
        -----> Setting up nginx
        Exit status 0
        Staging complete
        Uploading droplet, build artifacts cache...
        Uploading build artifacts cache...
        Uploading droplet...
        Uploaded build artifacts cache (108B)
        Uploaded droplet (2.6M)
        Uploading complete
        Destroying container
        Successfully destroyed container

        1 of 1 instances running

        App started


        OK

        App helloworld was started using this command `sh boot.sh`

        Showing health and status for app helloworld in org org / space demo as sergey...
        OK

        requested state: started
        instances: 1/1
        usage: 1G x 1 instances
        urls: helloworld.[cloud-foundry].com
        last uploaded: Mon Oct 10 16:49:07 UTC 2016
        stack: cflinuxfs2
        buildpack: https://github.com/cloudfoundry/staticfile-buildpack.git

        state     since                    cpu    memory       disk         details
        #0   running   2016-10-10 07:49:40 PM   0.0%   3.8M of 1G   6.8M of 1G

It possible that selected name `helloworld` is already reserved for another applications, and in this case you will see following error message:

    Creating route helloworld.[cloud-foundry].com...
    OK
    
    FAILED
    Server error, status code: 400, error code: 210003, message: The host is taken: helloworld
    
That happens because the route should be unique per Cloud Foundry instance, just try to deploy your application using any other name. 

In order to get an access to the log messages stream generated by application you can use "cf logs APP_NAME --recent" command. For example:

    cf logs helloworld --recent
    
In an output for this commnad you will see messages related to Spring Boot initialization:

    [INFO] --- spring-boot-maven-plugin:1.5.2.RELEASE:run (default-cli) @ config ---
    2017-04-10 00:29:15.492  INFO 25786 --- [           main] s.c.a.AnnotationConfigApplicationContext : Refreshing org.springframework.context.annotation.AnnotationConfigApplicationContext@b9377e1: startup date [Mon Apr 10 00:29:15 MSK 2017]; root of context hierarchy
    2017-04-10 00:29:15.734  INFO 25786 --- [           main] trationDelegate$BeanPostProcessorChecker : Bean 'configurationPropertiesRebinderAutoConfiguration' of type [org.springframework.cloud.autoconfigure.ConfigurationPropertiesRebinderAutoConfiguration$$EnhancerBySpringCGLIB$$8592cd6e] is not eligible for getting processed by all BeanPostProcessors (for example: not eligible for auto-proxying)
    
      .   ____          _            __ _ _
     /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
    ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
     \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
      '  |____| .__|_| |_|_| |_\__, | / / / /
     =========|_|==============|___/=/_/_/_/
     :: Spring Boot ::        (v1.5.2.RELEASE)
    
    2017-04-10 00:29:21.194  INFO 25786 --- [           main] com.example.ConfigApplication            : No active profile set, falling back to default profiles: default
    2017-04-10 00:29:21.205  INFO 25786 --- [           main] ationConfigEmbeddedWebApplicationContext : Refreshing org.springframework.boot.context.embedded.AnnotationConfigEmbeddedWebApplicationContext@60bd0bb3: startup date [Mon Apr 10 00:29:21 MSK 2017]; parent: org.springframework.context.annotation.AnnotationConfigApplicationContext@b9377e1
    2017-04-10 00:29:21.684  INFO 25786 --- [           main] o.s.cloud.context.scope.GenericScope     : BeanFactory id=a5c9ffc7-da8f-3b32-bb3e-98a13de3f1de
    ...