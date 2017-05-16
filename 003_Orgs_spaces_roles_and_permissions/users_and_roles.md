### Users

Individual developers and operators using Cloud Foundry are represented by user accounts. One user account can work in several spaces within an org and have different roles in each space. These roles define what a user can and cannot access/do within that particular space.


### Roles

A user can be granted one or more roles, which are combined to determine the overall permissions attached to that user within an org and the spaces that this org contains.

* An **Admin** user have full permissions across all orgs and spaces and can perform operational actions using the Cloud Controller API.

* **Admin Read-Only** users have read-only access to all Cloud Controller API resources.

* **Org Managers** administer the org. This role can be assigned to managers, as well as to other users.

* **Org Auditors** have view-only access to user information and org quota usage information.

* **Org Billing Managers** are granted permissions to create and manage billing accounts and payment information.

* **Space Managers** administer a certain space within an org. This can be managers or other users.

* **Space Developers** manage applications and services within a given space. This role can be assigned to software developers or other users.

* **Space Auditors** have view-only access to information about a certain space.