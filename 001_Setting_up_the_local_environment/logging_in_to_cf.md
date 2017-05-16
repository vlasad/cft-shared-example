### Step 1: Logging in to Cloud Foundry  with the cf cli


In the previous module, you have learnt how to install the Cloud Foundry Command Line Interface (CF CLI) utility called ‘cf’ 
to communicate with the Cloud Foundry instance. To use the CLI for deploying and managing applications, 
you need to connect it to an API endpoint and log in to Cloud Foundry:

        cf login -a api.{{echo $CF_DOMAIN}}

You will also need to provide your login and password:

        API endpoint: https://api.[cloud-foundry].com

        Email> [my-email]

        Password> [my-password]
        Authenticating...
        OK


Your credentials for this training are:

    API      : https://api.{{echo $CF_DOMAIN}}
    Login    : {{echo $CF_USER}}
    Password : {{echo $CF_PASSWORD}}
    Org      : {{echo $CF_ORG}}
    Space    : {{echo $CF_SPACE}}

> **IMPORTANT**: Please, save this information locally. It can be required to login later if session is terminated. 

Later, in case if your session is expired, you can login to cf using following commands:

    cf api api.{{echo $CF_DOMAIN}} --skip-ssl-validation
    cf auth {{echo $CF_USER}} {{echo $CF_PASSWORD}}
    cf target -o {{echo $CF_ORG}} -s {{echo $CF_SPACE}}




