### Step 4: Ensuring that the application is up and running
Enter the application’s URL in the browser to check whether it has been started:

    http://{{cf apps | grep started | awk '{print $1}'}}.{{echo $CF_DOMAIN}}

The displayed result should be:

    Hello World! 

It means that our simple "web site" is deployed to the cloud and ready to serve requests from our users. You can always get information about your application using `cf app APP_NAME` command. For example:

    cf app {{cf apps | grep started | awk '{print $1}'}}
    
Will show the result:
    
    Showing health and status for app helloworld in org poc / space dev as user@altoros.com...
    OK
    
    requested state: started
    instances: 1/1
    usage: 1G x 1 instances
    urls: helloworld1.[cloud-foundry].com
    last uploaded: Tue Mar 21 09:16:09 UTC 2017
    stack: cflinuxfs2
    buildpack: https://github.com/cloudfoundry/staticfile-buildpack.git
    
         state     since                    cpu    memory       disk       details
    #0   running   2017-03-21 12:16:38 PM   0.0%   4.7M of 1G   7M of 1G


### Common issues with the Cloud Foundry CLI

1. In Cygwin or Git Bash on Windows, interactive prompts, such as `cf login`, may not work. As a workaround, you can use the `cf api` and `cf auth to cf login` commands or the `-f` option.
2. On Linux, when getting a `bash: .cf: No such file or directory,` error, make sure the binary or installer you are using for your architecture is correct. 
