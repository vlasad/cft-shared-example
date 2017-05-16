In this module, you will learn how to manage configuration of cloud-native apps in Cloud Foundry.


### Objectives

After completing this module, you will be able to:

* Write a `manifest.yml` file detailing your project's configuration
* Manage configuration of your apps via the Cloud Foundry CLI
* Use one manifest file to configure several deployment workflows


## Study topics

### App configuration in Cloud Foundry

Configuration refers to all the parameters of your app that can change when you deploy it to different environments (staging, production, development, etc.). In particular:

* Resource handles for the DB, Memcached, and various backing services
* Credentials to access external services, e.g., Facebook or Amazon Route53
* Values that are unique for each deployment, such as the canonical hostname

In the cloud, applications keep their configuration data in environment variables (also known as env vars or simply env). Some of the advantages of env vars are: 

- the possibility to have different env vars for different deployments without modifying any code
- env vars are very unlikely to be copied to GitHub or another code repository by mistake
- env vars can work with a variety of languages and operating systems, unlike other configuration mechanisms, e.g., Java System Properties
