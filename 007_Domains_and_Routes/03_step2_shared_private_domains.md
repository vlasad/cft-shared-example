
### Step 2: Shared and private domains

There are two types of domains in Cloud Foundry:

* **Shared**: accessible to all orgs within your Cloud Foundry deployment
* **Private**: only accessible to orgs where they were created

To list all available domains, run:

	cf domains

You will see output similar to this:

	name                       status   type
	[cloud-foundry].com        shared
	myprivatedomain.com        owned


**Shared domains**

Shared domains are managed by Cloud Foundry admins and are available to users in all orgs within a deployment. One user can have access to many shared domains. For example, users may have a choice of two shared domains `shared-domain.com` and `cf.mycompany.com` where they can create routes for their applications.

There is no default shared domain in a new Cloud Foundry deployment. However, if you push an application without stating a domain, Cloud Foundry will generate a route for the app using the first shared domain created in the system. Pushing is the only operation involving routes where you don't have to specify the domain.


**Private (owned) domains**

Private or custom domains provide a way for users to create routes for privately registered domain names. Private domains added to one org may be shared by users of other orgs.

You will need org manager rights to create a private domain. To do that, use the `create-domain` command followed by the name of an org and the new domain name, like so:

	cf create-domain org privatedomain.com

To check if the domain was created successfully, run the `cf domains` command again:

	name                       status   type
	[cloud-foundry].com        shared
	myprivatedomain.com        owned
	privatedomain.com	       owned

> **NOTE**: Don’t forget that besides registering your new custom domain name in Cloud Foundry, you will need to create corresponding `CNAME` records on the DNS server responsible for that domain name.
