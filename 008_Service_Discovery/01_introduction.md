
The ephemeral nature of cloud-native software means that IP addresses may change all the time. Service registries are one of the ways to solve this issue and allow distributed services to communicate with each other. In this module, we will use Netflix Eureka to implement a service registry for our sample app.


### Objectives

After completing this lesson, you will be able to:

* Understand the problem of Service Discovery
* Solve the Service Discovery problem using environment variables
* Use Netflix Eureka for Service Discovery in Cloud Foundry

### Introduction

In the cloud, applications typically are composed of numerous services that communicate with each other. Servers are ephemeral, which means they may be created, deleted, and recreated again at any time. Since servers may come and go, their location or IP address can change. Service Discovery is a way to let applications keep track of these changes and find each other and services despite the ephemeral nature of the cloud. One of the possible implementations is to create a service registry that gets updated whenever a service changes its address. Apps can use this registry to retrieve information about the location of services that they need and then connect to them directly.

Eureka is a service registry solution from Netflix that can be used for service discovery in Cloud Foundry. In this module we will try to implement service discovery for our app, using Eureka.
