# oracleAlwaysFreeWebODM
How to setup WebODM on an Oracle Always Free Cloud Compute Instance

The first step is to setup a compute instance on oracle cloud. I assigned the max resources (4 OCPUs and 24 GB of Ram) and used Canonical Ubuntu 22.04. Be sure to save your private key file (*.key), as it is used for ssh access. The VM is created and running you can navigate to the virtual cloud network settings, then to the subnet, and add an ingress rule for port 8000 (the port used by WebODM by default for the webapp). At this point I used https://portchecker.co/checking to confirm that that port was open. I had some difficulties figuring out this part as I was not setting the ingress security list rule in the correct spot. Adding it to multiple places and testing using the link above was helpful.

![image](https://user-images.githubusercontent.com/46830116/216821184-da5b6d46-08e2-476e-a2b8-799b5fd494fb.png)

Now we have a properly provisioned cloud vm with the proper ports open. Time to install and configure WebODM.
