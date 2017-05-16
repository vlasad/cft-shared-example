In this module, you will learn how to manage your application’s configuration externally, using a config server from the Spring Cloud Config module of Spring Cloud.


## Objectives

In this module you will learn:

* What is a config server and how is it useful in cloud systems
* How to create a config server with Spring Cloud and run it in Cloud Foundry
* How to consume configuration from a config server
* How to change configuration on the fly


## Study topics

It is a good practice to use a config server in cloud systems. A config server provides you a central place to manage external properties of your applications distributed across multiple environments. Also it's a good way to separate different configurations for development, testing, and production environments when moving an application through the deployment pipeline.

The Spring Cloud project includes the Spring Cloud Config module, which provides server- and client-side support for externalized configuration in a distributed system. By default, the server storage backend uses Git. This adds some handy features, e.g., labelled versions of configuration environments and a possibility to use a wide range of tools for managing the content. Alternative implementations also exist. You can easily plug them in via Spring configuration.

In this module, you’ll setup a config server, which uses a Git repository, and then build a client that consumes the configuration on startup and then refreshes it on-the-fly (without restarting the client).