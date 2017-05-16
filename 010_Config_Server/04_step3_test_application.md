#### Step 3: Testing the application

Let's build the `HelloWorld` application and run it in Cloud Foundry:

    $ mvn clean package
    $ cf push
    
    requested state: started
    instances: 1/1
    usage: 512M x 1 instances
    urls: helloworld.[cloud-foundry].com
    last uploaded: Wed Nov 9 16:19:46 UTC 2016
    stack: cflinuxfs2
    buildpack: https://github.com/cloudfoundry/java-buildpack.git

         state     since                    cpu    memory         disk           details
    #0   running   2016-11-09 07:21:22 PM   0.0%   299M of 512M   160.2M of 1G

You can find your application logs using command:

    cf logs helloworld --recent

If you scroll back the log console, you should see the following initialization logs:

    ...
    [APP.0] 2016-11-09 20:33:27: 2016-11-09 17:33:27.811  INFO 16 --- [           main] c.c.c.ConfigServicePropertySourceLocator : Fetching config from server at: http://config-server.[cloud-foundry].com
    [APP.0] 2016-11-09 20:33:28: 2016-11-09 17:33:28.656  INFO 16 --- [           main] c.c.c.ConfigServicePropertySourceLocator : Located environment: name=helloworld, profiles=[cloud], label=master, version=cf98dbbb5cc9c515d0b4f21ef6298adf408cd012, state=null
    [APP.0] 2016-11-09 20:33:28: 2016-11-09 17:33:28.657  INFO 16 --- [           main] b.c.PropertySourceBootstrapConfiguration : Located property source: CompositePropertySource [name='configService', propertySources=[MapPropertySource [name='configClient'], MapPropertySource [name='https://[my-git-repository].git/helloworld.yml']]]
    ...
    
Now open the application's home page at `http://helloworld.[cloud-foundry].com` to trigger some logs to be printed. Get back to the application logs. The `INFO` log message will be printed:

![Application INFO logs](https://s3.amazonaws.com/cf-training-resources/cf_for_developers_introduction/013_app_logs_info.png)


##### Changing configuration on the fly

Let's change the logging level value on the config server to see that the application will re-configure and consume a new value.
Change the `helloworld.yml` config stored in your Git repository like the following:

```yml
---
logging:
  level:
    com.example: DEBUG

```

Commit and push your changes.

Refresh the page `http://config-server.[cloud-foundry].com/helloworld/default` and see how the configuration has changed on the config server:

```json
{
  "name": "helloworld",
  "profiles": [
    "default"
  ],
  "label": "master",
  "version": "cf98dbbb5cc9c515d0b4f21ef6298adf408cd012",
  "state": null,
  "propertySources": [
  {
    "name": "https://[my-git-repository].git/helloworld.yml",
    "source": {
      "logging.level.com.example": "DEBUG"
    }
  }
  ]
}
```

Now, if you hit your application's home page, `http://helloworld.[cloud-foundry].com`, to print some logs, you will see that the application is still printing only `INFO` logs. To re-configure the application, we need to execute its `/refresh` endpoint (provided by Spring Cloud for the `@RefreshScope` bean `PersonService`). Execute the following from your command line:

    $ curl -X POST http://helloworld.[cloud-foundry]/refresh
    
Now again, trigger some logs by refreshing `http://helloworld.[cloud-foundry].com` and see the log messages printed in the application's log stream:

![Application INFO logs](https://s3.amazonaws.com/cf-training-resources/cf_for_developers_introduction/013_app_logs_debug.png)

As you can see, both `INFO` and `DEBUG` logs are printed now.


## Learning check

Answer the following questions:

1. How can you use a config server?
2. How will you set up a config server in Cloud Foundry?
3. How will you make an application consume configuration from a config server?
4. Why do we put cloud config properties in a bootstrap properties file (not in an application properties file)?
5. How do we make an application, which is using a config server, re-initialize when there are some configuration changes?
