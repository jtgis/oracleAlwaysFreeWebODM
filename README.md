# oracleAlwaysFreeWebODM
How to setup WebODM on an Oracle Always Free Cloud Compute Instance

The first step is to setup a compute instance on oracle cloud. I assigned the max resources (4 OCPUs and 24 GB of Ram) and used Canonical Ubuntu 22.04. Be sure to save your private key file (*.key), as it is used for ssh access. The VM is created and running you can navigate to the virtual cloud network settings, then to the subnet, and add an ingress rule for port 8000 (the port used by WebODM by default for the webapp). I had some difficulties figuring out this part as I was not setting the ingress security list rule in the correct spot.

![image](https://user-images.githubusercontent.com/46830116/216821184-da5b6d46-08e2-476e-a2b8-799b5fd494fb.png)

Now we have a properly provisioned cloud vm with the proper ports open. Time to install and configure WebODM.

To ssh into the vm I used the guide on the orcale site https://docs.oracle.com/iaas/Content/Compute/Tasks/accessinginstance.htm. 

Once we are connected via ssh we can install WebODM. My process mostly comes from https://docs.opendronemap.org/installation/#step-1-install-requirements but I deviate to use python2 explicitly (the flavour of ubuntu uses 3 and WebODM needed 2?), install pip (it was missing?), and open the correct port in the iptables.

```
sudo apt update
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo apt install -y git python2 python-pip
sudo apt install pip
```

Now we are ready to install WebODM.

Check if docker composed is installed (it was not). It will give an error after the first command if it is missing and the second command installs it.

```
docker-compose --version
sudo pip install docker-compose
```

Now we can clone, and do the install/first run:

```
git clone https://github.com/OpenDroneMap/WebODM	
cd WebODM
sudo ./webodm.sh start --port 8000 --detached
```

The parameters on this start method make sure it is using port 8000 (which we already tested as open), and in detached mode (background mode) so we can still access and use the terminal.

If we look at the listening ports we can see that 8000 is not there.

```
sudo netstat -lntp
```

And if we look at the iptables there is no rule for port 8000. There is also one weird rul rejecting connections that someone smarter than me on the internet suggested removing so I did.

```
sudo iptables -S INPUT
```

So now we add and remove the port stuff.

```
sudo iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 8000 -j ACCEPT
sudo iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited
```

A restart on WebODM might be useful.

```
sudo ./webodm.sh restart
```

If we check the listening ports and iptables again we should see port 8000 listening and as a rule (use the commands from above).

Now i tested the port using https://portchecker.co/checking. If it is not showing open it might be an issue with the egress rules in the console so try poking around in there again. If it is working we can run the command below to make the iptable rules persistent across reboots.

```
sudo netfilter-persistent save
```

Now you should be able to navigate to publicIP:8000 in any web browser and access your WebODM web app. If not it is likely the egress rules in oracle or you messed soemthing in the vm up bad. Either way it is a quick process and can be started from the beginning easily. The more times you do it the better you get at it :).
