### Cloud Foundry CLI installation

In case you have tried Cloud Foundry before, you may already have the Cloud Foundry CLI on
your system. So let's check if it is already installed. In the terminal, type:

    cf --version 
    
You will get the version of your Cloud Foundry CLI:

    cf version 6.16.1+924508c-2016-02-26

In case the Cloud Foundry CLI is not yet installed, you can download it from [https://github.com/cloudfoundry/cli#downloads](https://github.com/cloudfoundry/cli#downloads) and follow the instructions for your operating system. Note that if you have the *cf CLI v5 Ruby gem* installed, you will need to remove it first.


#### Windows

To install the Cloud Foundry CLI on Windows:

1. Unpack the ZIP file.
2. Double-click the Cloud Foundry CLI executable.
3. When prompted, click **Install**, then, click **Close**.
4. To verify the installation, in the terminal, type `cf`. The Cloud Foundry CLI help listing should appear.


#### Mac OS X

To install the Cloud Foundry CLI on Mac OS X:

1. Open the .pkg file.
2. In the installer wizard, click **Continue**.
3. Select an installation destination and click **Continue**.
4. When prompted, click **Install**.
5. To verify the installation, in the terminal, type `cf`. The Cloud Foundry CLI help listing should appear.


#### Linux

To install the Cloud Foundry CLI on a Linux system:

1. Go to the [CLI releases](https://github.com/cloudfoundry/cli/releases) page and download a package for your system.
2. Use your system's package manager to install the CLI. Don't forget about `sudo`—the
  commands may require root permissions to run. Next are some examples of commands 
  that you may use.
	- Debian/Ubuntu: `dpkg -i path/to/cf-cli-*.deb && apt-get install -f`
	- Red Hat: `rpm -i path/to/cf-cli-*.rpm`
3. To verify the installation, in the terminal, type `cf`. The Cloud Foundry help listing
  should appear.
