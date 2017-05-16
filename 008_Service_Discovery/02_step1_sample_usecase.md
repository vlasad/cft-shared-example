### Step 1: Understanding the sample use case

We will change our sample `HelloWorld` application and make it use another application running in Cloud Foundry to show Service Discovery in action.

First, we will split the current `HelloWorld` application into two. All MySQL data access logic will be moved to a new application—`PersonService`—which will expose a REST endpoint for retrieving data. The `HelloWorld` application will become a simple client application that queries `PersonService` for data and prints a greeting message.

Then, we will run both applications in Cloud Foundry with `PersonService` details set to `HelloWorld` via environment variables. This way has some serious drawbacks, which we will also discuss.

Finally, we will use Netflix Eureka for service registry and discovery in Cloud Foundry.