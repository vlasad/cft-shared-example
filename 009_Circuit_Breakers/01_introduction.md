### Objectives

After completing this lesson, you will:

* Know what the circuit breaker pattern is and what problems it helps to solve
* Be able to use the Hystrix circuit breaker in your application
* Know how to run a Hystrix dashboard to monitor Hystrix metrics of your application in real time


### Study topics

### Introduction

#### The circuit breaker pattern

Most modern apps need to communicate with services and other apps, which often run on remote hosts. Unlike in-memory calls, remote calls that travel across a network are prone to failures. Your call may not get any response and hang for some time until the timeout is over. An even worse situation is when a lot of users are trying to reach an unresponsive service—that may quickly deplete critical resources, resulting in cascading failures of different systems. The **circuit breaker** pattern was designed as a safeguard against such catastrophes.

A circuit breaker is based on a simple idea. A protected function call is wrapped in a circuit breaker object, which counts how many times the call has failed. When failures reach a certain threshold, the circuit breaker trips and all further calls result in a failure without actually calling the protected function. In many cases, you'll also want some kind of monitor alert to notify you when a circuit breaker has tripped.


#### Hystrix

Hystrix is a library developed by Netflix, which implements the circuit breaker pattern and helps to improve latency and fault tolerance in distributed systems. It is designed to isolate points of access to external services, libraries, and systems, and prevent cascading failures in environments where failure is virtually inevitable.

A typical use case is a microservice architecture where service calls have to travel across an arbitrary number of layers. A error on one of the lower levels can result in cascading failure of everything above it. Hystrix opens the circuit when calls to a particular service reach a certain threshold (20 errors is the default threshold). As soon as the circuit is open, the call is not made every time. Developers can provide fallbacks in case of errors and an open circuit (described below). Thus, besides helping to avoid cascading failures, a circuit breaker also protects overloaded services, giving them some time to recover.

As a fallback, you can choose to have another Hystrix-protected call, static data, or sane empty values. It is possible to arrange fallbacks in a sequence, e.g., your code may react to failure by making another call and, if the other call fails, it can return some static data.

Hystrix is available from the Spring Cloud Netflix module, which makes it very easy to build Hystrix clients with a simple annotation-driven method decorator. You can also use declarative Java configuration to enable an embedded Hystrix dashboard used for monitoring Hystrix metrics in real time.

#### The sample application

Let's use sample applications from the previous module Service Discovery. We will update the `HelloWorld` application to make a call to `personservice` with a `HystrixCommand`, which wraps the code with a circuit breaker. We will then see the circuit breaker in action by making `personservice` unavailable for some time. After that, we will create a Hystrix dashboard to see Hystrix metrics gathered from the `HystrixCommand` in our application.