Built by the Spring Team on top of the existing Spring Framework, Spring Boot makes developing and deploying 
Spring applications a lot easier. It provides a new, more efficient development model that eliminates a lot of
 unnecessary steps and configuration routines. Thanks to Spring Boot, software developers can write 
 less boilerplate code and focus on what really matters.


### Objectives

In this lesson you will learn:

* Why use Spring Boot; Spring Boot features and advantages
* Spring Boot basics
* How to develop a simple application with Spring Boot

### What is Spring Boot

Spring Boot is designed to simplify development and testing of Spring software. Developers can use Spring Boot to deliver stand-alone, 
production-ready apps that "just work."


#### Features and advantages

The Spring Boot framework makes it possible to:

* Build stand-alone Spring applications
* Minimize the amount of boilerplate code, annotations, and XML configuration that developers need to do
* Directly embed Jetty, Undertow, and Tomcat without deploying any WAR files
* Ease configuration of Gradle and Maven by providing opinionated "starter" build configuration
* Automate Spring configuration, where possible; easily integrate Spring software with various technologies from the Spring ecosystem (Spring ORM, Spring Security, Spring JDBC, Spring Data, etc.)
* Add health checks, metrics, externalized configuration, and other production-grade functionality
* Entirely avoid generating code and doing XML configuration

### Creating a sample application

We will start by building a basic web app, called "HelloWorld", using some of the key features of Spring Boot.

If you have completed the previous modules, you should already have Java and Maven—the minimal prerequisites for building our application—installed on your machine.