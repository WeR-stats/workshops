# How to Setup a Cloud Server for Data Science
  * [Motivations](#motivations)
  * [Create a Virtual Private Server](#create-a-virtual-private-server)
    + [Sign up to Digital Ocean](#sign-up-do)
    + [Login into Digital Ocean](#login-do)
    + [Secure Digital Ocean Account](#secure-do)
    + [Create *droplet*](#droplet-without-ssh-key)
    + [First Connection](#first-connection)
      - [Windows Users](#without-key-windows)
      - [Linux and macOS Users](#without-key-linux-macos)
  * [Linux Basics](#linux-basics)
    + [Files and Folders](#files-and-folders)
      - [Root Directory Structure](#linux-directory-structure)
    + [Users, Groups, Permissions, Ownerships](#users-groups-permissions-ownerships)
    + [Software Management](#software-management)
    + [Scheduling Tasks](#cronjobs)
    + [Bash Shell](#bash-shell)
  * [Customize Your New Server](#customize-your-new-server)
    + [Upgrade the System](#upgrade-system)
    + [Add Admin User](#add-admin-user)
    + [Add *public* Group](#add-public-group)
    + [Add *public* Repository](#add-public-repository)
    + [Add Security Layer](#add-security)
    + [*Install Webmin*](#install-webmin)
    + [Take Your First *Snapshot*](#first-snapshot)
  * [The *R* Stack](#the-r-stack)
    + [Install core *R*](#install-r)
      - [Packages Management](#r-packages-management)
    + [Install *RStudio Server*](#install-rstudio-server)
      - [Appearance and configurations](#rstudio-appearance-and-configurations)
      - [Using Projects with Version Control](#rstudio-using-projects-with-version-control)
      - [Server Management](#rstudio-management)
    + [Install *Shiny Server*](#install-shiny-server)
    + [Install *Ubuntu* Dependencies for *R* packages](#install-linux-dependencies-for-r-packages)
    + [Install *R* packages](#install-r-packages)
      - [Data Preparation](#r-packages-data-preparation)
      - [Data Processing](#r-packages-data-processing)
      - [Data Display and Visualization](#r-packages-data-display-and-visualization)
        * [htmlwidgets, JS wrappers](#r-packages-htmlwidgets--js-wrappers)
        * [ggplot extensions](#r-packages-ggplot-extensions)
      - [Data Modeling, Mining and Learning](#r-packages-data-modeling--mining-and-learning)
      - [Spatial Data](#r-packages-spatial-data)
      - [Graphs, Network](#r-packages-graphs--network)
      - [Data Presentation, Shiny](#r-packages-data-presentation--shiny)
      - [Applications](#r-packages-applications)
      - [Tools and Utilities](#r-packages-tools-and-utilities)
    + [Testing the R stack](#testing-the-r-stack)
  * [The Python Data Science Stack](#the-python-data-science-stack)
    + [Install Python](#install-python)
    + [Install the Data Science Stack](#install-the-data-science-stack)
    + [Install Jupyter Notebook](#install-jupyter-notebook)
  * [Storage engines](#storage-engines)
    + [MySQL Server](#mysql)
      - [Install DBNinja as a web interface](#dbninja)
    + [Neo4j](#neo4j)
    + [MongoDB](#mongodb)
    + [Redis](#redis)
    + [PostgreSQL](#postgresql)
    + [MS SQL Server](#mssqlserver)
    + [MonetDBLite](#monetdblite)
    + [Hive / Hbase](#hive-hbase)
    + [Influx DB](#influx-db)
  * [Ngnix](#ngnix)
    + [Install Nginx](#nginx-install)
    + [Nginx Configuration](#nginx-configuration)
    + [Add Domain Name](#domain-name)
    + [Make Pretty URLs for RStudio Server and Shiny Server](#pretty-url)
    + [Add SSL Certificate](#ssl-certificate)
    + [Add Authentication to Shiny Server](#shiny-auth)
  * [Docker](#docker)
    + [Install Docker](#docker-install)
    + [Basic Commands](#docker-commands)
    + [Dockerfile](#dockerfile)
    + [Example: Selenium for Web Driving](#docker-selenium)
    + [Resources](#docker+resources)
  * [Additional Tools](#additional-tools)
    + [Install Additional Fonts](#install-fonts)
    + [Spark](#spark)
    + [Add SSH Key Pair for Enhanced Security](#droplet-with-ssh-key)
      - [Windows users](#with-key-windows)
      - [Linux and macOS users](#with-key-linux-macos)
  * [Resources](#resources)


  <a name="motivations"/>

## Motivations 



  <a name="create-a-virtual-private-server"/>

## Create a Virtual Private Server  

  <a name="sign-up-do"/>

### Sign up to Digital Ocean
  - go to https://m.do.co/c/ef1c7bc80083 (you'll be credited $100 lasting 60 days)
  - insert your email and a sufficiently strong password (you can generate one suitable [here](https://www.random.org/passwords/?num=1&len=15&format=html&rnd=new))
  - you'll be asked for a credit card, but no money will be taken from your account.
  - validate your email


  <a name="login-do"/>

### Login into Digital Ocean
  - go to https://cloud.digitalocean.com/login
  - click "Login" top right
  - enter username and password


  <a name="secure-do"/>

### Secure Digital Ocean Account
  - go to Account / Security / Secure your account / Enable Two-Factor Authentication
  - choose which system you prefer and follow instructions. 
  - in both possible cases, remember to generate the backup codes, and save them in some secure place.


  <a name="droplet-without-ssh-key"/>

### Create *droplet*
  - Click the green "Create" button in the top right
  - Click "Droplet" from the unfolding menu
  - For the installation step, you should create a VPS which is at least 2GB RAM, because a few packages require more than 1GB RAM to compile. You can change number of CPUs and amount of RAM later.  
     For the moment being, choose the following:
    - Distribution: Ubuntu 16.04.4 x64
    - Size: RAM 4GBPower: 2vCPUs, Storage: 80GB, Bandwith: 4TB, Cost: $20/mo ($0.030/hr). 
	- Region: London / Amsterdam
	- Choose a memorable name (shiny-server)
	- Add one or more tags (shiny, test)
    - Click Create
 	- Wait for the email containing the IP public address of the server, and the password for the root user. The IP address could also be found in the *Resources* tab besides the name of the droplet. 

Notice that Digital Ocean highly discourage the use of *swap space*, to keep down the size, and hence the cost, of the droplet. This is due to the fact that their system is all made up of SSD storage, that is highly degraded by the continous read/write access. Besides, upgrading the droplet leads to much better results in general.


  <a name="first-connection"/>

### First Connection

**SSH** stands for ***S**ecure **SH**ell* which is a [cryptographic](https://en.wikipedia.org/wiki/Cryptography "Cryptography")  [network protocol](https://en.wikipedia.org/wiki/Network_protocol "Network protocol") that allows secure access over an otherwise unsecured network. SSH is encrypted with *Secure Sockets Layer* (SSL), which makes it difficult for these communications to be intercepted and read.
It's often used with a password only access, but it's also possible to setup *SSH keys* that identify trusted computers without the need for passwords. For added security it's also possible to add a *passphrase* that act as a password to access the key pair.

  <a name="without-key-windows"/>

#### Windows users
Windows has no embedded ssh client by default. Many software can be downloaded for free, one of the most famous is [PuTTY](https://www.putty.org/), but we are going to use the much enhanced [MobaXTerm](https://mobaxterm.mobatek.net/), which is free for personal use.
  - [Download](https://mobaxterm.mobatek.net/download-home-edition.html) and install MobaXTerm
  - Open MobaXTerm
  - Click "Session" in the upper left button bar, then "SSH" again in the upper left button bar of the window
  - Paste the IP address you received with the email into the *Remote host* textbox, then click OK
  - type in  `root` when asked *login as*, then copy the password you received with the email and paste it into the terminal. Notice that by default Linux systems do not give any feedback from the password field. So don't try to paste again and again because you feel the need to see something back, just paste the password once and hit enter!
---
The first time you connect to a droplet as *root*, the system asks you to change the password. You have first to paste again the password you've just used to login, and then enter (twice) a new (strong) password. I advise you to use a password manager to securely collect, store and organize all your credentials. My suggestion is the free open source [KeePass Password Safe](https://keepass.info/)

  <a name="without-key-linux-macos"/>

#### Linux and macOS users
Both Linux *distros* and *macOS* have a built-in SSH client called *Terminal* which can be used to connect to remote servers:
  - **macOS**. *Terminal.app* is located in the `Applications > Utilities` folder. Double-click on the icon to start the client.
  - **Linux**. A Terminal window can be easily open using the shortcut `CTRL+ALT+T`. 
 
At the prompt you would type in general:  `ssh username@ip_address`. At the moment there is noother user than *root* , so that to connect to your droplet just type:
`ssh root@ip_address`
If the IP address and the user name are correctly recognized, the system then prompts to enter the password associated with the specified user.


  <a name="linux-basics"/>

## Linux Basics

  <a name="files-and-folders"/>

### Files and Folders
  - `pwd` 
  - `ls` 
  - `cd` 
  - `mkdir` 
  - `rmdir` 
  - `cp /path/to/origin/fname /path/to/destination` 
  - `mv /path/to/origin/fname /path/to/destination` 
  - `rm /path/to/origin/fname` 
  - `cat fname` 
  - `less fname` 
  - `more fname` 
  - `head fname` 
  - `tail fname` 
  - `touch fname` 
  - `nano fname` 

  <a name="linux-directory-structure"/>

#### Root Directory Structure



  <a name="users-groups-permissions-ownerships"/>

### Users, Groups, Permissions, Ownerships

  - `` 
  - `whoami` 
  - `adduser usrname`  
  - `usermode -aG sudo usrname`  
  - `passwd usrname`
  - `su usrname`
  - `sudo` 
  - `exit`
  - `chmod`
  - `chown`

  <a name="software-management"/>

### Software management 

   - `update`
   - `upgrade`
   - `dist-upgrade`
   - `autoremove`
  - `clean`
   - `install`
  - `/etc/apt/sources.list` Locations to fetch packages from
  - ``
 

  <a name="cronjobs"/>

### Scheduling Tasks



  <a name="bash-shell"/>

### Bash Shell




  <a name="customize-your-new-server"/>

## Customize Your New Server

  <a name="upgrade-system"/>

### Upgrade the System
  - To enable monitoring from the DO dashboard:
	```
	curl -sSL https://agent.digitalocean.com/install.sh | sh
	```
  - Enter `date` to test if the timezone is correct. If it doesn't show the correct time and/or desired timezone: 
    ```
    dpkg --configure -a
	dpkg-reconfigure tzdata
	```
	then enter the correct zone for your location. Notice that if you leave the timezone as **UTC**, there will be no automatic passage between winter and summer time.
  - Before proceeding any further, let's thouroughly upgrade the system:
	```
	apt-get update
	apt-get upgrade
	apt-get dist-upgrade
	apt-get autoremove
	```
    answering `y` everytime you're asked permission.
	If during the above upgrading session a window pops up and asks for any changes, be sure to accept the choice:
	`keep the local version currently installed`
  - Restart the system: 
    `shutdown -r now` or `reboot`


  <a name="add-admin-user"/>

### Add admin user
The Linux system is well known for its strong users management, file and directories permissions and ownerships. 

  - `adduser usrname` create new user (change *usrname* with the actual user name)
  - enter a password twice (generate one suitable [here](https://www.random.org/passwords/?num=1&len=15&format=html&rnd=new)), and then the required information (you can simply void all fields)
  - `usermod -aG sudo usrname` add new user as *sudoer* to the *sudo* group
  - `su - usrname` switch control to *usrname*
  - `sudo su` check if *usrname* can actually run admin commands
  - `exit` always remember to exit from sudo when finished (also `CTRL+D` as shortcut)
 
  From now on you should forget there exists a user called *root*, and always use instead *usrname* to run admin commands.


  <a name="add-public-group"/>

### Add *public* group
```
sudo groupadd public
sudo usermod -aG public username
```

  <a name="add-public-repository"/>

### Add *public* repository
I decided to go for `/usr/local/share/public` but feel free to change it as you wish.
```
sudo mkdir -p /usr/local/share/public/
sudo chgrp -R public /usr/local/share/public/
sudo chmod -R 2775 /usr/local/share/public/
```
Reboot to make sure the above privileges have been applied.

To add the above path to a system variable, run the following command:
```
export PUB_PATH="/usr/local/share/public"
```
after which the path can be retrieved issuing a simple `$PUB_PATH` command. It's worth noting that the above command is only a *temporary* solution, as with a reboot the content of `PUB_PATH` is lost. To add the path to a permanent system variable, first open for editing the file that stores the system-wide environment variables:
```
sudo nano /etc/environment
```
then add the following line at the end:

```
PUB_PATH="/usr/local/share/public"
```

Once you've decided the actual location, you have to build some structure in it, and that mostly depends on your projects. Any of the subdir can been created with the generic command:
```
mkdir -p /usr/local/share/public/newsubdir
```
or, if you've included the public path in the system environment:
```
mkdir -p $PUB_PATH/newsubdir
```

The following tree is how I've organized my work on my own server:
```
boundaries/	
  rds/
    s00
    s10
    s20
    s30
    s40
    s50
  shp
datasets
  census
  common
  geography
  shiny-apps
    app1
    app2
  fonts
    google
    microsoft
    windows
ext-data
  census
  crime-incidents
  cycle-schemes
    london
  food-shops
  land-registry
  lending
  uprn
  vehicles
geography
R-library
scripts
shiny-apps
  app1
  app2
styles
work
  ...
www
```


  <a name="add-security"/>

### Add security layers
First, deny the `root` user direct access via SSH:
  - open the SSH configuration file (if `nano: command not found` then `sudo apt-get install nano`):
    `sudo nano /etc/ssh/sshd_config`
 - change and Insert the following lines, then save the file (CTRL+x ==> y ==> Enter) :
	`PermitRootLogin no`
  - restart the service:
	`sudo systemctl restart ssh`	
  - logout, and test that the *root* user is NOT capable to ssh into the machine

Login back again as the *new* user, and let's change the standard ssh port **22** to a random integer number `xxxx` between 1024 and 65535:
  - open the SSH configuration file:
    `sudo nano /etc/ssh/sshd_config`
  - change the following line as desired, then save the file (CTRL+x ==> y ==> Enter)
	`Port xxxx`
  - restart the service 
	`sudo systemctl restart ssh`
  - **without logging out from the current session**, open another session besides the one already open, and test that the new user is capable to *ssh* into the machine using the new `xxxx` port, but not from the standard **22**. If anything does not sounds right, close this session and fix using the original session.

Lastly, enable the standard firewall *ufw* allowing at once the new above port (THIS IS IMPORTANT!!!)
  - enable firewall
	`sudo ufw enable`
  - allow the *ssh* port (the new `xxxx` if it's been changed, or the standard **22** if it's not been changed)
	`sudo ufw allow xxxx`
  - check if the rule has been correctly applied, check again the number is correct!
	`sudo ufw status`
	Now, using a different session as earlier, test that the new user is still capable to ssh into the machine.

The following table lists the default ports for the main services used in this document. For a more comprehensive list of default ports used by various well-known services see [this Wikipedia article](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers) 
| service | default |
|-----------|-------| 
| HTTP      |    80 |  
| HTTPS     |   443 |
| SSH       |    22 |
| FTP       |    21 | 
| SFTP      |    22*| 
| WEBMIN    | 10000 |
| RSTUDIO   |  8787 |
| SHINY     |  3838 |
| JUPYTER   |  8888 |
| MYSQL     |  3306 |
| POSTGRES  |  5432 |
| SQLSERVER |  1433 |
| MONGODB   | 27017 |
| NEO4J     |  7474 |
| REDIS     |  6379*|
| HIVE      |  |
| HBASE     |  |
| INFLUXDB  |  8086 |
| NEXTCLOUD |  |
| CALIBRE   |  |

A short list of some of the most used commands for the standard firewall is the following:
  - `ufw enable` 
  - `ufw disable` 
  - `ufw status` 
  - `ufw status verbose` 
  - `ufw allow XXXX` 
  - `ufw allow app list` 
  - `ufw allow app_profile`  
  - `ufw allow XXXX/tcp` 
  - `ufw allow XXXX/udp` 
  - `ufw allow XXXX:YYYY` 
  - `ufw allow from www.xxx.yyy.zzz` 
  - `ufw delete allow XXXX` 
  - `ufw deny XXXX` 
  - `ufw reset` 

All the above commands must obviously be launched as a *sudoer*.

If anything happens, and you can't login anymore through remote SSH, most VPS and Cloud providers allow users to open a shell from the dashboard account. 
On Digital Ocean head for the droplet dashboard. At the top right, there is a **Console** button which allows to login directly using password authentication. 
Moreover, if you forget the root password, or you've never set it, head again for the droplet dashboard, and from the left menu click on the **Access** item. There you can find the magic button to reset the root password. Once you log in, if not asked by the system itself, you should reset the password again using the following commands:
```
sudo -i
passwd
```
 
  <a name="install-webmin"/>

### Install Webmin
While powerful and efficient, sometimes it'd nice to have a simple and intuitive web interface to manage the system. Here comes [Webmin](http://www.webmin.com/).

  - add the Webmin address to the list of trusted packages repositories:
	`echo -e "\n# WEBMIN\ndeb http://download.webmin.com/download/repository sarge contrib\n" | sudo tee -a /etc/apt/sources.list`
  - download the *public key* of the Webmin developer [Jamie Cameron](https://github.com/jcameron) to secure the Ubuntu package manager:
    `wget http://www.webmin.com/jcameron-key.asc`
  - add the above key to the manager sources keyring: 
    `sudo apt-key add jcameron-key.asc`
  - update the package management system: 
    `sudo apt-get update`
   - install webmin: 
    `sudo apt-get install webmin`
  - allow access to the standard **10000** port: 
    `sudo ufw allow 10000`
  - navigate to the URL [https://server_ip:10000/](https://server_ip:10000/), don't worry for now about the warnings
  - enter your now usual username and password to log in into the Webmin console
  - change default port to some random number `XXXX` :
	```
	Webmin > 
		Webmin Configuration >
		Ports and Addresses >
		Listen on IPs and ports >
		Listen on port
	```
	Also check:
    - **NO** for `Accept IPv6 connections? `
    - **Don't listen** for `Listen for broadcasts on UDP port` 
  - After the changes have been saved, the website will go down as the port has changed and it can't reconnect to its server
  - allow access to the new `XXXX` port: 
      `sudo ufw allow XXXX`
  - delete the previous rule for the default **10000** port:
    `sudo ufw delete allow 10000`
  - check the software is now reachable at the new port: [https://server_ip:XXXX/](https://server_ip:XXXX/)

  <a name="first-snapshot"/>

### Take Your First Snapshot
At this point in time, it'd be useful to save the current state of the machine, called **snapshot**, so that if something happens in the future it's always possible to revert back to the current situation in a few minutes with a click from the droplet dashboard. Moreover, we could also build other similar droplets but slighlty different, and use this snapshot as a starting point, instead of going back to the entire droplet creation.

To snapshot a droplet:
  - shut down the droplet:
     `sudo shutdown -h now`
  - login into your DO account, head for the droplet dashboard, and from the left menu click  **Snapshots**, then **Take Snapshot**
  - Once finished,  start the droplet again using the switch on the upper right

In case you want to create a new droplet from a snapshot:
  - open the  [droplet **Create** page](https://cloud.digitalocean.com/droplets/new), 
  - select the  **Snapshots** tab
  - choose the snapshot you’d like to create the droplet from
  - fill out the rest of the choices on the **Create** page as desired, then click  **Create**


  <a name="the-r-stack"/>

## The *R* Stack

  <a name="install-r"/>

### Install core *R*

  - add the CRAN address to the list of trusted packages repositories
    `echo -e "\n# CRAN REPOSITORY\ndeb http://cran.rstudio.com/bin/linux/ubuntu xenial/\n" | sudo tee -a /etc/apt/sources.list`
    The above command:
    - presumes that the installed OS version is **16.04 LST**. For different versions, change the word `xenial` with the correct adjective using [this list](https://en.wikipedia.org/wiki/Ubuntu_version_history) as a reference. In particular, the newest LTS version **18.04** is named `bionic`.
    - connects to  `cran.rstudio.com`, which is the the generic redirection service from *RStudio*, but it's also possible to switch to a static closer location (according to the chosen VM region, not the user's location!) using [this list](https://cran.r-project.org/mirrors.html).
  - download the *public key* of the CRAN maintainer Michael Rutter to secure the Ubuntu package manager:
    `gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9`
  - add the above key to the manager sources keyring: 
    `gpg -a --export E084DAB9 | sudo apt-key add -`
  - update the package management system: 
    `sudo apt-get update`
  - install R:
    `sudo apt-get install r-base r-base-dev`
 
To add the *public* repository we define earlier to the *R* environment:
  - open the general *R* configuration file for editing:
    `sudo nano $(R RHOME)/etc/Renviron`
  - add the following line (or a similar one) at the end:
    `PUB_PATH = '/usr/local/share/public'`
  - restart *R*
  - to recall the path from inside any *R* script:
    `Sys.getenv('PUB_PATH')`

 
  <a name="r-packages-management"/>

#### Packages Management

One note of caution is how packages are installed, if you don't want to end up with lots of duplications, different versions and incompatibility
To overcome this situation, choose one of the following alternatives:
  - packages should be installed as **root**, (`sudo su` / `R`) so that they always end up in the system library that can be read by any user by default
  - define a common shared location for the packages to be stored, then include it explicitly in *any* call to the installation command:
    `install.packages('pkgname', lib.loc = '/path/to/library')`

If you try to install lots of packages in the same session, you'll probably get the following message:
`maximal number of DLLs reached...`
In that case, you need to tell *R* that it can open more than the default 100 libraries in a single session:
  - open the general *R* configuration file for editing:
    `sudo nano $(R RHOME)/etc/Renviron`
  - add the following string at the end:
    `R_MAX_NUM_DLLS = 512`
  - restart *R*

  <a name="install-rstudio-server"/>

### Install RStudio Server
  - install first the *deb* installer:
    `sudo apt-get install gdebi-core`
  - create a new repository in your home directory to store the downloaded software, then move into it:
	`mkdir ~/software`
	`cd ~/software`
  - download the package:
    `wget -O rstudio https://s3.amazonaws.com/rstudio-ide-build/server/trusty/amd64/rstudio-server-1.2.1181-amd64.deb`
    Please note that the above command presumes the *preview* 64bit version at the time of writing. It's worth verifying the newest version visiting [this page](http://www.rstudio.com/products/rstudio/download/preview/), and in case substitute where needed. 
    Moreover, if you prefer to stay on the safer side and want to install the *stable* release, check instead [this page](https://www.rstudio.com/products/rstudio/download-server/) for the newest version. 
  - install Rstudio Server:
    `sudo gdebi rstudio`
  - add a rule to the firewall to allow the default port Rstudio Server is listening to:
    `sudo ufw allow 8787`
  - head for http://ip_address:8787/ to check the software is up and running 
  - Change the default port **8787** to some random integer number `XXXX`:
    - open the configuration file for editing:
    `sudo nano /etc/rstudio/rserver.conf`
    - change the port from **8787** to **XXXX**:
      `listen XXXX`
    - restart the server:
      `sudo service rstudio-server restart`
    - add a rule to the firewall:
      `sudo ufw allow XXXX`
    - head for [http://ip_address:XXXX/]() to check the software is up and running.
    - delete the previous rule for the default **8787** port:
      `sudo ufw delete allow 8787`


  <a name="rstudio-appearance-and-configurations"/>

#### Appearance and configurations



  <a name="rstudio-using-projects-with-version-control"/>

#### Using Projects with Version Control
Before using *git*, you first have to be sure that RStudio has recognized the software. Open:
`Tools > Global Options > Git/SVN`
and check that the textbox marked as *Git executable* contains the path, usually `/usr/bin/git`
You now have to open the *git* shell, and enter the basic information about your account with the Version Control you want to use, be it Github or Bitubucket:
`git config --global user.email "email here"`
`git config --global user.name "name here"`

  - to clone on the server an existing project already on: 
    - [GitHub](): on the GH website, go to the main source of the repository, then copy the entire URL of the repository
    - [Bitbucket](): on the BB website, go to the main source of the repository, click `Clone` on the upper right, then copy the address in the textbox (drop the initial `git clone` text)
  - in Rstudio Server, click the project dropdown list in the upper right (if this is the first time that RSudio runs, it probably reads as `Project: (None)`), then `New Project`, `Version Control`, and finally `Git`. 
  - copy the address in the textbox Repository URL, and fill as desired the other two text boxes. Click `Create Project`, then insert your password to start cloning the repo.
  - If using GitHub, it's a smart choice not to use the access password when dealing with RStudio projects, but instead create a [GitHub token](https://github.com/settings/tokens) to use instead of the password.

  <a name="rstudio-management"/>

#### Server Management
Having installed *RStudio Server* as above, then it is automatically registered as a *deamon*, which starts along with the rest of the system. 
  - to manually stop, start, or restart the server, use one the following commands:
    `sudo rstudio-server stop`
    `sudo rstudio-server start`
    `sudo rstudio-server restart`
  - to list all currently active sessions:
    `sudo rstudio-server active-sessions`
  - to suspend:
    an individual session: `sudo rstudio-server suspend-session <pid>`
    all running sessions: `sudo rstudio-server suspend-all`
    The `suspend` commands also have a `force` variation which will send an *interrupt* to the specified session(s) to request the termination of any running *R* command:
    `sudo rstudio-server force-suspend-session <pid>`
    `sudo rstudio-server force-suspend-all`
    Notice that the above commands should be issued immediately prior to any reboot, so as to preserve the data and state of active *R* sessions across the restart.
 - to completely remove *RStudio Server* from the system:
    `sudo apt-get remove --purge rstudio-server`
 
  <a name="install-shiny-server"/>

### Install Shiny Server
  - install first the *shiny* package from inside *R*, using admin privileges. While we are at it, let's also install the *rmarkdown* package just to ensure that the Shiny landing page is completely correct:
    ```
    sudo su
    R
    install.packages(c('rmarkdown', 'shiny'))
    q()
    exit
    ```
    Please, don't run *R* as `sudo R`, because in that case packages would be installed in the user local directory, and couldn't be loaded by the `shiny` user. If you decided to use instead a subfolder into the *public* repository, remember to specify the optional argument as  in:
    `install.packages(c('rmarkdown', 'shiny'), lib.loc = file.path(Sys.getenv('PUB_PATH'), 'R-library'))`
  - move into the software repository we created in the previous RStudio installation step:
    `cd ~/software`
  - download the package (check [here](https://www.rstudio.com/products/shiny/download-server/) for latest version):
    `wget -O shiny https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb`
  - install *Shiny Server*:
    `sudo gdebi shiny`
  - add a rule to the firewall to allow the default port Shiny Server is listening to:
    `sudo ufw allow 3838`
  - head for [http://ip_address:3838/]() to check the software is up and running. Notice that the error in the second app is normal, as it needs the *RMarkdown* package to work, which is  not be installed yet.
  - Change the default **3838** port to the standard **80**, so that the user can access the server without an explicit port in the URL (but be sure that there are no other web servers listening to that port):
    - open the *Shiny Server* configuration file for editing:
    `sudo nano /etc/shiny-server/shiny-server.conf`
    - change the port from **3838** to **80**:
      `listen 80`
    - restart the server:
      `sudo service shiny-server restart`
    - add a rule to the firewall:
      `sudo ufw allow 80`
    - head for [http://ip_address/]() to check the software is up and running.
    - delete the previous rule for the default **3838** port:
      `sudo ufw delete allow 3838`
  - add the `shiny` user to the *public* group, hence *shiny* will share the *public* repository as well:
    `sudo usermod -aG public shiny`
  - add permission to the shiny server subdirectory to every user in the public group (you need to reboot the system for the changes to take effect):
    ```
    cd /srv/shiny-server
    sudo chown -R username:public .
    sudo chmod g+w .
    sudo chmod g+s .
    ```    
  - to copy apps from any location in any *public* user's home folder to the appropriate shiny server subfolder directory:
    `mkdir /srv/shiny-server/<APP-NAME>`
    `cp -R /home/username/<APP-PATH>/* /srv/shiny-server/<APP-NAME>/`
      
For further development, see below under the `Nginx` section adding *password authentication* and *SSL authorization*.

 
  <a name="install-linux-dependencies-for-r-packages"/>

### Install Linux dependencies for R packages

  - **devtools**:
     `sudo apt-get install curl libssl-dev libcurl4-gnutls-dev`
  - **curl**:
     `sudo apt-get install libcurl4-openssl-dev`
  - **openssl**:
    `sudo apt-get install libssl-dev`
  - **xml2**:
    `sudo apt-get install libxml2-dev`
  - **RMySQL**:
    `sudo apt-get install libmysqlclient-dev`
  - **MS SQL Server** (see separate card)
  - **rgdal** / **rgeos** / **spdplyr** (in this order):
    ```
    sudo add-apt-repository ppa:ubuntugis/ppa 
	sudo apt-get update 
	sudo apt-get install gdal-bin
	sudo apt-get install libgdal-dev libgeos-dev libproj-dev 
    ```
  - **sf** (must be installed *after* previous deps):
    `sudo apt-get install libudunits2-dev`
  - **geojsonio** (must be installed *after* previous deps):
    `sudo apt-get install libv8-3.14-dev`
  - **Cairo** / **gdtools**:
    `sudo apt-get install libcairo2-dev libxt-dev`
  - **tmap** (must be installed *after* previous deps since *rgdal*):
    ```
    sudo apt-get install libv8-3.14-dev
    sudo add-apt-repository -y ppa:opencpu/jq
    sudo apt-get update
    sudo apt-get install libjq-dev
    sudo apt-get install libprotobuf-dev
    sudo apt-get install protobuf-compiler
    ```
  - **RcppGSL**:
    `sudo apt-get install libgsl0-dev`
  - **gmp**:
    `sudo apt-get install libgmp3-dev`
  - **rgl**:
    `sudo apt-get install r-cran-rgl libcgal-dev libglu1-mesa-dev`
  - **Rglpk**:
    `sudo apt-get install libglpk-dev`
  - **magick**:
    ```
    sudo add-apt-repository -y ppa:opencpu/imagemagick
    sudo apt-get update
    sudo apt-get install libmagick++-dev
    ```
  - **rJava**:
    ```
    sudo apt-get install openjdk-8-*
    sudo apt-get install r-cran-rjava
    sudo R CMD javareconf
    ```
  - **nloptr**:
    `sudo sudo apt-get install libnlopt-dev`
  - **gganimate**:
    `sudo sudo apt-get install cargo`

Some packages need also dependencies from the [Bioconductor]('https://bioconductor.org/) repository:
```
source('https://bioconductor.org/biocLite.R')
biocLite('BiocInstaller')
biocLite("S4Vectors") 
```


  <a name="install-r-packages"/>

### Install R packages
To install all the packages in the following subsections, you need first to define the following function:
```
install_my_packages <- function(pkgs){
    library(devtools)
    pkgs <- pkgs[!sapply(pkgs, require, char = TRUE)]
    if(length(pkgs) > 0) install.packages(pkgs, dependencies = TRUE)
}
```
Each call to the above function should be made from the root environment, so having previously run separately:
`sudo su`
`R`

Before proceeding, you need to first install the package *devtools* as a general prerequisite:
```
sudo su
R
install.packages('devtools')
q()
exit
```

  <a name="r-packages-data-preparation"/>

#### Data Preparation

```
pkgs <- c(
    'readxl', 'readODS', 'data.table', 'tidyverse', 'fst', 'openxlsx', 'jsonlite', 'RCurl', 'httr', 'rvest',
    'htmltools', 'janitor', 'odbc', 'RMySQL', 'pool', 'sqldf', 'RPostgres', 'glue', 'stringr', 'lubridate',
    'hms', 'forcats', 'zoo', 'xts', 'tibbletime', 'gdata', 'purrr', 'magrittr', 'scales', 'funModeling',
    'classInt', 'matrixStats', 'skimr'
)
install_my_packages(pkgs)
```

  <a name="r-packages-data-processing"/>

#### Data Processing
```
pkgs <- c(
#)
install_my_packages(pkgs)
```

  <a name="r-packages-data-display-and-visualization"/>

#### Data Display and Visualization

```
pkgs <- c(
    'huxtable', 'flextable', 'kableExtra', 'pixiedust', 'sparkTable', 'xtable', 'microplot', 'htmlTable', 'tableHTML', 'basictabler', 'pivottabler',
    'ggplot2', 'ggvis', 'lattice', 'latticeExtra', 'googleVis', 'corrplot', 'corrgram', 'ggparallel', 'circlize', 'animation',
    'vcd', 'vcdExtra', 'gridExtra', 'sjPlot', 'tabplot', 'treemap', 'alluvial', 'iheatmapr', 'riverplot', 'tweenr', 'hexbin', 'dendextend', 'coefplot',
    'ggthemes', 'ggconf', 'ggsci', 'hrbrthemes', 'RColorBrewer', 'colorspace', 'wesanderson', 'viridis', 'Polychrome',
    'yarrr', 'munsell', 'dichromat', 'Cairo', 'randomcoloR', 'qualpalr', 'jcolors', 
    'extrafont', 'emojifont', 'fontcm', 'showtext', 'giphyr'
)
install_my_packages(pkgs)
install_github('ramnathv/rCharts')
install_github("timelyportfolio/rcdimple")
install_github('jalapic/simpletable')
install_github('tdhock/animint')
install_github('cttobin/ggthemr')
install_github('hoesler/rwantshue')
install_github('ricardo-bion/ggtech')
install_github('hadley/emo') 
```

  <a name="r-packages-htmlwidgets--js-wrappers"/>

##### htmlwidgets, JS wrappers 
```
pkgs <- c('htmlwidgets',
    'DT', 'leaflet', 'leaflet.extras', 'ggiraph', 'dygraphs', 'timevis', 'visNetwork', 'd3heatmap', 'tmap', 'mapview',
    'sunburstR', 'googleway', 'manipulateWidget', 'pairsD3', 'billboarder', 'collapsibleTree', 'leaflet.minicharts', 'listviewer',
    'sparkline', 'formattable', 'rhandsontable', 'rpivotTable', 'metricsgraphics', 'scatterD3', 'ECharts2Shiny',
    'edgebundleR', 'BioCircos', 'plotly', 'DiagrammeR', 'networkD3', 'highcharter', 'rbokeh', 'threejs', 'd3Tree', 'widgetframe', 'D3partitionR'
)
install_my_packages(pkgs)
install_github('pvictor/topogRam')
install_github('hrbrmstr/streamgraph')
install_github('timelyportfolio/parcoords')
install_github('hrbrmstr/taucharts')
install_github('homeaway/great-circles')
install_github('psychemedia/htmlwidget-hexjson')
install_github('hafen/trelliscopejs')
install_github('cmap/morpheus.R')
install_github('homerhanumat/bpexploder')
install_github('lchiffon/wordcloud2')
install_github('ThomasSiegmund/D3TableFilter')
```
 
  <a name="r-packages-ggplot-extensions"/>

##### ggplot extensions 
```
pkgs <- c(
    'cowplot', 'directlabels', 'egg', 'geofacet', 'geomnet', 'ggalluvial', 'GGally', 'ggalt', 'ggbuildr', 'ggedit', 'ggExtra', 'ggfittext', 'ggforce', 
    'ggfortify', 'gghighlight', 'ggimage', 'ggiraph', 'ggiraphExtra', 'ggmap', 'ggmosaic', 'ggnetwork', 'ggpmisc', 'ggpubr', 'ggRandomForests', 
    'ggraph', 'ggrepel', 'ggridges', 'ggseas', 'ggsignif', 'ggspatial', 'ggstance', 'ggtern', 
    'lemon', 'qqplotr', 'survminer', 'treemapify', 'waffle'
)
install_my_packages(pkgs)
install_github('thomasp85/patchwork')
install_github('shabbychef/ggallin')
install_github('dgrtwo/gganimate')
install_github('briatte/ggnet')
install_github('guiastrennec/ggplus')
install_github('ricardo-bion/ggradar')
install_github('Ather-Energy/ggTimeSeries')
install_github('sachsmc/plotROC')
install_github('Selbosh/ggChernoff') 
```

  <a name="r-packages-data-modeling--mining-and-learning"/>

#### Data Modeling, Mining and Learning
```
pkgs <- c(
    'infer', 'broom', 'ggeffects', 'modelr', 'car', 'rms', 'mgcv', 'gam', 'lme4', 'multcomp', 'glmnet', 'survival', 'dismo', 
    'caret', 'mlr', 'class', 'SuperLearner', 'h2o', 'klaR', 'ROCR', 'pROC', 'randomForest', 'ranger', 'kernlab', 'e1071', 
    'tree', 'rpart', 'rpart.plot', 'party', 'partykit', 'adabag', 'arules', 
    'nnet', 'neuralnet', 'kknn', 'C50', 'xgboost', 'DALEX', 'gbm', 'AppliedPredictiveModeling', 'earth', 'mda', 
    'tau', 'tidytext', 'tm', 'magick', 'igraph', 'ipred', 'mboost', 'lars', 'CORElearn',
    'fitdistrplus', 'boot',
    'forecast', 'sweep', 'anomalize', 'timetk', 'smooth',
    'googleAnalyticsR'
)
install_my_packages(pkgs)
```
 
  <a name="r-packages-spatial-data"/>

#### Spatial Data
```
pkgs <- c(
    'sf', 'sp', 'rgdal', 'rgeos', 'maptools', 'rmapshaper', 'mapedit', 'geojson', 'geojsonio', 'raster',
    'mapproj', 'maps', 'mapview', 'tmap', 'tmaptools', 'geogrid', 'cartogram',
    'tilegramsR', 'GISTools', 'spatstat', 'spdep', 'gstat', 'geoR', 'KRIG', 'deldir'
)
install_my_packages(pkgs) 
```
See also other packages listed in the above `ggplot` and `htmlwidgets` subsections.


  <a name="r-packages-graphs--network"/>

#### Graphs, Network
```
pkgs <- c('igraph', 'visNetwork', 'networkD3', 'DiagrammeR', 'sna', 'SigmaNet')
install_my_packages(pkgs) 
```

  <a name="r-packages-data-presentation--shiny"/>

#### Data Presentation, Shiny
```
pkgs <- c(
    'rmarkdown', 'shinydashboard', 'flexdashboard', 'knitr',
    'bsplus', 'colourpicker', 'gradientPickerD3', 'shinyBS', 'shinyalert', 'shinycssloaders', 'shinycustomloader', 'shinyDND',
    'shinyFeedback', 'shinyFiles', 'shinymaterial', 'shinyjqui', 'shinyjs', 'shinythemes', 'shinyWidgets'
)
install_my_packages(pkgs) 
```

  <a name="r-packages-applications"/>

#### Applications
```
pkgs <- c(
    'Matrix', 'svd', 'irlba', 'OpenMx', 'fitdistrplus', 'boot', 'quantmod', 'PerformanceAnalytics', 'tidyquant', 'Quandl', 'psych'
)
install_my_packages(pkgs) 
```

  <a name="r-packages-tools-and-utilities"/>

#### Tools and Utilities
```
pkgs <- c(
    'diffobj', 'doMC', 'doParallel', 'foreach', 'future',
    'promises', 'profvis', 'RSelenium', 'SOAR'
)
install_my_packages(pkgs) 
```
Notice that as of today *RSelenium*, and some of its dependencies, have been withdrawn from CRAN, so it must be installed as follows:
```
library(devtools)
install_github('johndharrison/binman')
install_github('johndharrison/wdman')
install_github('ropensci/RSelenium')
```


  <a name="testing-the-r-stack"/>

### Testing the R stack
There is a repository on the [WeR GiHub](https://github.com/WeR-stats) website called [shiny-apps](https://github.com/WeR-stats/shiny-apps). At the time of writing these notes, there's at least one app (subfolder) called *uk_petitions* that lets you download [all the petitions](https://petition.parliament.uk/petitions) created under the current UK government, and then draw a [choropleth map](https://gisgeography.com/choropleth-maps-data-classification/) of the provenance of the subscribers using the [leaflet](http://rstudio.github.io/leaflet/) package. 

If you still haven't installed any package, besides *shiny* and *rmarkdown*, let's install the ones needed for the app to run correctly. We first need to install some system dependencies though.
```
sudo apt-get install curl libssl-dev libcurl4-gnutls-dev
sudo add-apt-repository ppa:ubuntugis/ppa 
sudo apt-get update 
sudo apt-get install gdal-bin
sudo apt-get install libgdal-dev libgeos-dev libproj-dev
sudo apt-get install libcairo2-dev libxt-dev
```
Now it's possible to run *R* (as root) and actually install the required packages:
```
sudo su
R

install.packages('devtools')
library(devtools)
pkgs <- c('data.table', 'readxl', 'Cairo', 'classInt', 'colourpicker', 'data.table', 'DT', 'jsonlite', 'leaflet', 'leaflet.extras', 'RColorBrewer', 'rgdal', 'rgeos', 'shiny', 'shinyjs', 'shinyWidgets')
install.packages(pkgs, dependencies = TRUE)
q()

exit
```
Let's create a directory for the app in the Shiny server repository:
`mkdir /srv/shiny-server/uk_petitions`

To copy the app code into the above folder, we first create a project in RStudio Server saving the repository in the user home folder. Once the repo has been pulled on the server, run the following simple command to actually copy the code:
`cp ~/shiny-apps/uk_petitions/* /srv/shiny-server/uk_petitions/`

You should now open a browser and head to [http://ip_address/uk_petitions]() to see the app up and running!


  <a name="the-python-data-science-stack"/>

## The Python Data Science Stack


  <a name="install-python"/>

### Install Python 
Although Python is often automatically installed on Ubuntu, take a moment to confirm that version **3.4+** is already installed on the system, by issuing the following command: 
`python3 -V`

In a similar way, the `pip3` package manager is usually installed on Ubuntu. Take a moment though to confirm that version 8.1+ is installed, by issuing the command:
`pip3 -V`

In any case, run the following commands to install both of them:
```
sudo apt-get update
sudo apt-get install python3 python3-dev python3-pip
sudo -H pip3 install --upgrade pip
```

  <a name="install-the-data-science-stack"/>

### Install the Data Science Stack
We are now in a position to install all the top packages needed for a decent data science stack:
  - [Pandas](http://pandas.pydata.org/), [scrapy](https://scrapy.org/) and [pattern](https://github.com/clips/pattern) for data wrangling, web scraping and mining
  - [NumPy](http://www.numpy.org/), [SciPy](http://www.scipy.org/scipylib/index.html), and [SymPy](http://www.sympy.org/) for numerical computation
  - [matplotlib](http://matplotlib.org/), [seaborn](http://seaborn.pydata.org/), [Bokeh](https://bokeh.pydata.org/), [plotly](https://plot.ly/python/), [NetworkX](https://github.com/networkx/networkx), and [folium](http://python-visualization.github.io/folium/) for data visualization
  - [Statsmodels](http://statsmodels.sourceforge.net/) for statistical inference and modeling
  - [scikit-learn](http://scikit-learn.org/), [LightGBM](https://github.com/Microsoft/LightGBM), [XGBoost](https://github.com/dmlc/xgboost) for machine learning
  - [Keras](https://github.com/keras-team/keras), [TensorFlow](https://github.com/tensorflow/tensorflow), [Theano](https://github.com/Theano/Theano), and [Chainer](https://chainer.org/) for Deep Learning
  - [NLTK](http://www.nltk.org/) and [Gensim](https://radimrehurek.com/gensim/) for Natural Language Processing and Topic Modeling
  - [Cython](http://cython.org/), [Dask](https://dask.pydata.org/) and [Numba](https://numba.pydata.org/) for high performace and distributed computiing
  - [pytest](https://pytest.org/) for quality assurance
  - [IPython](https://ipython.org/) and [Jupyter](jupyter.org/) Notebook, for interactive computing in multiple programming languages.

Notice that *seaborn* requires the following additional library to be installed beforehand: 
`sudo apt-get install python3-tk`
Moreover, if using *Theano* or *Keras* it's better to install the **BLAS** libraries to improve performance:
`sudo apt-get install libblas-dev`

It's possible to install the above packages one by one when heeded, but you can also install all libraries at once.
  - open first a new file **python-libs.txt** for editing in `~/software`:
    `nano ~/software/python-libs.txt`
  - copy and paste the following list
    ```
    pandas
    scrapy
    pattern3
    numpy
    scipy
    sympy
    matplotlib
    seaborn
    bokeh
    plotly
    networkx
    folium
    statsmodels
    sklearn
    lightgbm
    xgboost
    theano
    tensorflow
    keras
    pybrain
    nltk
    gensim
    cython
    dask
    numba
    pytest
    ```
  - exit saving the file, then run the following command:
    `python3 -m pip install --user -r ~/software/python-libs.txt`


  <a name="install-jupyter-notebook"/>

### Install Jupyter Notebook
[IPython](https://ipython.org/) is an interactive command-line interface to Python. [Jupyter](https://jupyter.org/) offers an interactive web interface to many languages, including IPython and R.
First, install Ipython:
`sudo apt-get -y install ipython ipython-notebook`
Next, move on to installing Jupyter Notebook:
`sudo -H pip3 install jupyter`

Once installed correctly, to run it, execute the following command:
`jupyter notebook --no-browser --port XXXX`
By default, a notebook server runs locally at `127.0.0.1:8888`, and is accessible only from *localhost*. Hence to connect to the Jupyter Notebook we need to use **SSH tunneling**.

  <a name="tunneling-windows"/>

#### Create an SSH Tunnel in Windows using MobaXTerm 
  - From the `Buttons` bar click *Tunneling*, or from the  `Tools` menu choose *MobaSSHTunnel* then *New SSH tunnel*.
  - BE sure that *local port forwarding* is the chosen radio button in the upper group 
  - Write down the following information anti-clockwise from the upper left:
    - **Forwarded Port** = whatever port number YYYY you want to connect from your *localhost*, but be careful not to interfere with other services already running on your system
    - **SSH Server** = the IP address of the droplet
    - **SshUsername** = the name of the user that started *Jupyter*
    - **SSH port** = 22 or the alternative port if the SSH service has been configured differently
    - **Remote port** = 8888 or a different port if *Jupyter* has been so instructed in the command line
    - **Remote server** = *localhost*
  - Click `Save`
  - Give a name to the new entry
  - Click the `play` icon
  - Open your browser and connect to [localhost:YYYY](localhost:YYYY)


  <a name="storage-engines"/>

## Storage engines

  <a name="mysql"/>

### MySQL Server (relational database)

  - install main program
    `sudo apt-get install mysql-server`
  - secure root login 
    `mysql_secure_installation`
  - login as root and create new user **username** with the desired privileges
    `mysql -u root -p`

  - create new user **username** with the desired privileges:
    ```
    CREATE USER 'username'@'localhost' IDENTIFIED BY 'pwd';
    GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost';
    FLUSH PRIVILEGES;
    ```
    See [here]() for a list of all possible specifications for the privileges 
  - open the configuration file for editing:
    `sudo nano /etc/mysql/my.cnf`
  - scroll at the end and add the desired credential(s):
    ```
    [groupname]
    host = ip_address
    user = username
    password = 'password'
    database = dbname
    ```
  - restart the server:
    `sudo service mysql restart`

  <a name="tweak-mysql"/>

#### Tweak MySQL Server



  <a name="rmysql"/>

#### RMySQL

  - `library(RMySQL)` 
  - `conn <- dbConnect(MySQL(), host = 'hostname', username = 'usrname', password = 'pwd', dbname = 'dbname')` 
  - `conn <- dbConnect(MySQL(), group = 'grpname')` 
  - `dbGetQuery(conn, 'strSQL')` 
  - `dbReadTable(conn, 'tblname')`  
  - `dbSendQuery(conn, 'strSQL')` 
  - `dbWriteTable(conn, 'tblname', dfname, row.names = FALSE, append = TRUE)` 
  - `dbRemoveTable(con, 'tblname)` 
  - `dbDisconnect(conn) ` 


  <a name="dbninja"/>

#### Install Web interface to MySQL Server
This step requires to have a Web server, like *Apache* or *Nginx*, and a *php* interpreter already installed on the system.

  - install php, plus its mysql extensions and JSON functionalities:
    ```
    sudo apt-get install php
    sudo apt-get install php-mysql
    sudo apt-get install php-json
    ```
  - download the MySQL client software:
    ```
    cd ~/software
    wget http://dbninja.com/download/dbninja.tar.gz
    ```
  - create subdirectory in web root
    `mkdir /vwr/www/html/myperfectpath`
  - copy content of zip file in the above directory:
    `tar -xvzf dbninja.tar.gz -C /var/www/html/myperfectpath --strip-components=1`


  <a name="mongodb"/>

### MongoDB (document database)

  - add the repository key to the apt keychain:
    `sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5`
  -  add the repository to the list of  `apt`  sources:
    `echo -e "\n# MONGODB\ndeb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse\n" | sudo tee -a /etc/apt/sources.list`
  - update as usual the repository information:
    `sudo apt-get update`
  - install the software:
    `sudo apt-get install mongodb-org`
  - to connect to the server:
    ` mongo --host 127.0.0.1:27017`
 If the feedback is negative, run the following command
 `sudo rm /var/lib/mongodb/mongod.lock`
then restart the server:
`sudo service mongod restart`
before trying to connect again.


  <a name="neo4j"/>

### Neo4j
[Neo4j](https://neo4j.com/) is an extremely popular [graph database](https://en.wikipedia.org/wiki/Graph_database) used to store and query connected data. Rather than having foreign keys and select statements, it uses *edges* and graph *traversals* to query the data. This method of querying data is extremely powerful in any situation where data is best represented as items that have relationships with other items in the dataset, such as social networks, biology, and chemistry.

Neo4j is implemented in Java, so you’ll need to have the Java Runtime Environment (JRE) installed. You can check it using the command: `java -version`. If the feedback is negative:
  -  add the java repository to the list of  `apt`  sources:
    `sudo add-apt-repository ppa:webupd8team/java`
  - update the repository information:
    `sudo apt-get update`
  - install the software:
    `sudo apt-get install oracle-java8-installer`

Once you've installed java, you can proceed with Neo4j:
  - add the repository key to the apt keychain:
    `wget --no-check-certificate -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add -`
  -  add the repository to the list of  `apt`  sources:
    `echo -e "\n# NEO4J\ndeb http://debian.neo4j.org/repo stable/\n" | sudo tee -a /etc/apt/sources.list`
  - update as usual the repository information:
    `sudo apt-get update`
  - install the software:
    `sudo apt-get install neo4j`

You can now head to [http://ip_address:7474/browser/]() to access the *neo4j* dashboard, using the default username and password `neo4j` and `neo4j`. You will be prompted to set a new password. If you find yourself in trouble logging in the first time, try to delete the file `/var/lib/neo4j/data/dbms/auth` and restart the server before trying to access again.

If the browser refuse to connect:
  - open the configuration file for editing:
    `sudo nano /etc/neo4j/neo4j.conf`
  - uncomment the following line:
    `dbms.connectors.default_listen_address=0.0.0.0`
  - restart the service:
    `sudo service neo4j restart`

The server should have started automatically, and should also be restarted at boot. If necessary the server can be:
  - started with `sudo service neo4j start`
  - stopped with `sudo service neo4j stop`
  - restarted with `sudo service neo4j restart`

    
  <a name="redis"/>
 
### Redis (in-memory database)

TBD


  <a name="postgresql"/>

### PostgreSQL (relational database)

TBD



  <a name="mssqlserver"/>

### MS SQL Server (relational database)

TBD



  <a name="monetdblite"/>

### MonetDBLite (columnar database)

TBD


  <a name="hive-hbase"/>

### Hive/Hbase (hadoop store)

TBD


  <a name="influxdb"/>

### Influx DB (time database) 

TBD



  <a name="nginx"/>

## Ngnix 
[Nginx](https://www.nginx.com/) is a free, open-source, high-performance HTTP server software, that also works as a proxy, load balancer, and Reverse Proxy. It's been developed with the intention to run on small resources, yet with the capacity to handle a large volume of concurrent connections. For these reasons, it is a great alternative to the more commonly used [Apache](https://httpd.apache.org/) web server.

  <a name="nginx-install"/>

### Install Nginx
  - Just in case Apache is already installed, stop the server and remove the package:
    `sudo systemctl stop apache2`
    `sudo apt-get remove -y apache*`
 - if you changed the *Shiny Server* listening port to **80**, edit its configuration file again to change the port to whatever else, as **80** has to be dedicated to the web server. 
 - if you haven't done it before, open port **80** for unencrypted traffic:
    `sudo ufw allow 80` or `sudo ufw allow http`
  - now we're ready to install the *nginx* server:
    `sudo apt-get install nginx`
  - After the completion of the installation process, the Nginx web server should start and run automatically. To ensure that the service is actually up and running, run the following command:
    `sudo systemctl nginx status`
	To test that the service is actually working, enter the **server_ip** directly into the browser's address bar, and you should see the default Nginx landing page.
  - To start, stop, restart, or reload the web server, run respectively the following standard command:
    `sudo systemctl stop nginx`
    `sudo systemctl start nginx`
    `sudo systemctl restart nginx`
    `sudo systemctl relaod nginx`
  - Nginx is automatically started when the server boots. To avoid it, simply disable the server:
    `sudo systemctl disable nginx`
	and enable it again if you want to start the Nginx server at boot:
    `sudo systemctl enable nginx`
    
  <a name="nginx-configuration"/>

### Nginx Configuration
  - The following are the location and names of the configuration and logs files:
    - `/etc/nginx` the Nginx parent directory that contain all the server configuration file
    - `/etc/nginx/nginx.conf` the main configuration file of Nginx
    - `/etc/nginx/sites-available/` you can store the *server blocks* in this directory. It has the configuration files which will not be used until they are linked with sites-enable directory.
    - `/etc/nginx/sites-enabled/` This directory stores the "server blocks". They link to the configuration file in the sites-available directory.
    - `/etc/nginx/snippets/` Here the configuration fragments are stored and they can be used anywhere in the Nginx Configuration. If you are using specific configuration segments repeatedly, then they can be added to this directory.
    - `/var/log/nginx/` the Nginx parent directory for the server log files
    - `/var/log/nginx/access.log` stores all the entry requests to the web server (it has to be configured to do that).
    - `/var/log/nginx/error.log` Nginx errors are recorded in this file
    - `/var/www/html/` the default directory for the content of the website(s)

The default Nginx installation will have only one default server block, enabled with a document root set to:
`/var/www/html/`
It is possible to add as many blocks as desired as follows:
  - create a new domain document root:
    `sudo mkdir -p /var/www/newdomain.com`
  - in the above folder, create a basic welcome web page:
    `sudo nano /var/www/newdomain.com/index.html`
	like the following:
	```
	<html>
  		<head>
      		<title>Welcome to the "newdomain.com>" nginx webserver!</title>
  		</head>
  		<body bgcolor="white" text="black">
    		<center><h1>newdomain.com is working!</h1></center>
		</body>
	</html>
	```
  - create a new server block:
    `sudo nano /etc/nginx/sites-available/newdomain.com.conf`
	and add the following content:
	```
	server {
		listen 80;
		listen [::]:80;
		server_name newdomain.com www.newdomain.com;
		root /var/www/newdomain.com;

		index index.html;

		location / {
			try_files $uri $uri/ =404;
		}
	}
	```
  - Activate the server block by creating a symbolic link in the list of available websites: 
    `sudo ln -s /etc/nginx/sites-available/newdomain.com.conf /etc/nginx/sites-enabled/newdomain.com.conf`
  - eventually, test that the above configuration is actually correct:
    `sudo nginx -t`
  - restart the nginx web server:
    `sudo systemctl restart nginx`
  - check with the browser that `newdomain.com` is working as desired.

  <a name="domain-name"/>

### Add Domain Name
How boring and annoying is to always remember an IP address? Enter [domain names](https://en.wikipedia.org/wiki/Domain_name)! For the current purpose, there's no point though in spending lots of money to own a fancy domain. Head to [Freenom World](http://www.freenom.org) to grab a free one! The catch here is that the choice of [Top-Level Domain](https://en.wikipedia.org/wiki/Top-level_domain) is restricted in the set: *tk*, *ga*, *ml*, *cf* and *gq*. 

Anyway, once you're on the *Freenom* landing page, look for a domain name you like, and click Get it Now and then move to the checkout page. Once there, click first `Use DNS` then the tab `Use your own DNS`, and in the texboxes labelled with `Nameserver` insert respectively:
`ns1.digitalocean.com` 
`ns2.digitalocean.com`
Go on and complete the sign up and checkout processes.

Once you own a domain, head to the [Digital Ocean](https://cloud.digitalocean.com/) website. 
  - from the main menu on the left click `Networking`, then enter the tab `Domains`. 
  - in the textbox *Enter domain* under `Add a domain` write your hostname, 
  - from the listbox on the right choose the project that include the server you want to apply the domain to
  - finally click `Add Domain`, and the domain should appear in the list below. Click on it!
    - in the `HOSTNAME` textbox enter `@`, 
    - in the `WILL DIRECT TO` choose the server
    - finally click `Create Record`
  - repeat the last steps entering `www`  in the `HOSTNAME` textbox 

Now you should simply wait from a few seconds to a few hours, depending on how fast the global sytem will update your changes, and if you head to [http://hostname]() you should see the same content as [http://ip_address]()

  <a name="pretty-url"/>

### Make pretty URLs for RStudio Server and Shiny Server
  - open the *Nginx* configuration file for editing
    `sudo nano /etc/nginx/sites-enabled/default`
  - add the following lines for *Shiny Server*, substituting `XXXX` with the correct port:
    ```
    location /shiny/ {
        proxy_pass http://127.0.0.1:XXXX/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        rewrite ^(/shiny/[^/]+)$ $1/ permanent;
    }
    ```
  - add the following lines for *RStudio Server*, substituting `XXXX` with the correct port:
    ```
    location /rstudio/ {
        proxy_pass http://127.0.0.1:XXXX/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
    ```
  - find the existing line:
    `server_name _;`
    and replace the underscore **_** with the domain name	of your choice
  - quit the editor, saving the file
  - verify that the syntax of the above configuration editings is actually correct:
    `sudo nginx -t`
	If you get any errors, reopen the file and check for typos, then test it again, until you get a succesful feedback.
  - once the configuration's syntax is correct, reload *Nginx* to load the new configuration:
    `sudo systemctl reload nginx`

  <a name="ssl-certificate"/>

### Add SSL Certificate for encrypted *https* connection
We will use [Let's Encrypt](https://letsencrypt.org/) to obtain a free SSL certificate.
  - open port **443** to allow SSL/TSL encrypted traffic through the firewall:
    `sudo ufw allow 443` or `sudo ufw allow https`
  - install the Certbot software:
    ```
    sudo add-apt-repository ppa:certbot/certbot
	sudo apt-get update
	sudo apt-get install python-certbot-nginx
    ```
  - Ask for the certificate:
	`sudo certbot --nginx -d hostname.tld -d www.hostname.tld`
    

  <a name="shiny-auth"/>

### Add Authentication to Shiny Server 

TBD


  <a name="docker"/>

## Docker

  <a name="docker-install"/>

### Install Docker
  - install the dependencies:
    `sudo apt-get install apt-transport-https ca-certificates curl software-properties-common`
  - add the docker repository in the *apt* source list:
    `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`
    `sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"`
  - update the package management source:
    `sudo apt-get update `
  - let's make sure, you're going to install docker from Docker repo,
    `apt-cache policy docker-ce`
  - install Docker:
    `sudo apt-get install docker-ce`
  - check the status:
    `sudo systemctl status docker`
  - check the version of both client and server:
    `sudo docker version`
  - verify the installation with a basic image:
    `sudo docker run hello-world`
  - returns a bunch of info about the Docker daemon:
    `sudo system info`

  <a name="docker-commands"/>

### Basic Commands
  - download the image **imgname** from the cloud repository:
    `sudo docker pull imgname`
  - run a container with the image **imgname**:
    `sudo docker run imgname`
  - see running containers
    `sudo docker ps` 
  - stop a container (look up cont_name running previous command)
    `sudo docker stop cont_name`
  - stop every running container
    `sudo docker stop $(sudo docker ps -q)`
  - stop container with a specified label
    `sudo docker stop $(sudo docker ps -q -f )`

  <a name="dockerfile"/>

### Dockerfile
A **Dockerfile** is a script that contains a collection of dockerfile instructions and operating system commands (tipycally Linux commands), that will be automatically executed in sequence in the docker environment for building a new docker image.

Below are some of the most used dockerfile instructions:
  - **FROM**  *registry/image:tag* The base image for building a new image. This command must be on top of the dockerfile.
  - **MAINTAINER** Optional, it contains the name of the maintainer of the image.
  - **RUN** Used to execute a command during the build process of the docker image.
  - **COPY** Copy a file from the host machine to the new docker image. There is an option to use an URL for the file, docker will then download that file to the destination directory. Thre is an additional `ADD` command which is not suggested to be used.
  - **ENV** Define an environment variable.
  - **CMD** Used for executing commands when we build a new container from the docker image.
  - **ENTRYPOINT** Define the default command that will be executed when the container is running.
  - **WORKDIR** This is directive for CMD command to be executed.
  - **USER** Set the user or UID for the container created with the image.
  - **VOLUME** Enable access/linked directory between the container and the host machine.

The following is an example of Dockerfile that creates an image similar to the server we're currently building on Digital Ocean: 
```
# Download base image ubuntu 16.04
FROM ubuntu:16.04
 
RUN \
    # Update software repository
    apt-get update \
    # Install missing basic commands
    && apt-get install -y --no-install-recommends apt-utils  \
    && apt-get install -y sudo wget gdebi-core libapparmor1  \
    # Upgrade system
    && apt-get upgrade -y  \
    # Install R packages dependencies
    && apt-get install -y  \
        curl  \
		libssl-dev  \ 
        libcurl4-gnutls-dev  \
		libssl-dev  \
		libxml2-dev  \
        libcairo2-dev  \
        libxt-dev  \
		pandoc  \
        pandoc-citeproc  \
        xtail \
    # cleaning
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/  \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
    
RUN \ 
    # add CRAN repository to apt
    echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | sudo tee -a /etc/apt/sources.list  \
    # add public key of CRAN maintainer
    && gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9  \
    && gpg -a --export E084DAB9 | sudo apt-key add -  \
    # Update software repository
    && sudo apt-get update  \
    # install R
    && sudo apt-get install -y r-base r-base-dev  \
    # install shiny package
    && su - -c "R -e \"install.packages('shiny', repos='https://cran.rstudio.com/')\""

RUN \
    # download and install RStudio Server
    wget -O rstudio https://s3.amazonaws.com/rstudio-ide-build/server/trusty/amd64/rstudio-server-1.2.830-amd64.deb  \
    && gdebi rstudio  \
    && rm rstudio  \
    # download and install Shiny Server
    && wget -O shiny https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.7.907-amd64.deb  \
    && gdebi shiny  \
    && rm shiny
    
# Copy shiny configuration files into the Docker image (change the port ? the user ? the app directory ?)
# COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

# install R packages using R script (plus cleaning)
# RUN Rscript -e "install.packages()" \
#    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN \
    adduser shiny  \
    # add a new group "public"
    && groupadd public  \
    # add "shiny"" to the "public" group
    && usermod -aG public shiny  \
    # Create a new directory as a base for the shared directory with the host and modify permissions to be used by the "public" group
    && mkdir -p /usr/local/share/public  \
    && chgrp -R public /usr/local/share/public/  \
    && chmod -R 2775 /usr/local/share/public/

# Volume configuration
VOLUME ["/usr/local/share/public"]

# Add the "public" path to the R configuration file 
# RUN 
 
```
  <a name="docker-selenium"/>

### Example: Selenium for Web Driving
  - pull Selenium image:
    `sudo docker pull selenium/standalone-firefox`
  - start a "simple" container listening to the port 4445:
    `sudo docker run -d -p 4445:4444 selenium/standalone-firefox`
  - start a "simple" container listening to the port 4445:
    `sudo docker run -d -p 4445:4444 selenium/standalone-firefox`
  - start a container with a mapping between some host directory and the guest browser download directory
    `docker run -d -p 4445:4444 -v /home/usrname/some/path:/home/seluser/Downloads selenium/standalone-firefox`   
    - to ensure the above actually works, you have to correctly configure the browser: 

  <a name="docker+resources"/>

### Resources

  - [main website](https://www.docker.com/) 
  - [Docker Hub](https://hub.docker.com/), the default public image registry
  - join the [community](dockercommunity.slack.com)
  - [*official* documentation](https://docs.docker.com)
  - exercise with an [online interactive environment](http://labs.play-with-docker.com/)


  <a name="additional-tools"/>

## Additional Tools

  <a name="spark"/>

### Spark

TBD


  <a name="install-fonts"/>
 
### Install Additional Fonts

#### Preliminaries

  - Change permissions to the font repository in `/usr/share/fonts/`
    ```
    sudo chown -R root:public /usr/share/fonts/
    sudo chmod -R 644 /usr/share/fonts/*
    sudo chmod 755 /usr/share/fonts/
    ```
  - install **fontconfig**
    `sudo apt-get install fontconfig`
  - install the *R* package **extrafont**
    ```
    sudo su
    R
    
    install.packages('extrafont')
    q()
    
    exit
    ```

#### Register fonts

  - (re)build the font information cache file (avoid printing output)
    `sudo fc-cache -fv > /dev/null`
  - open *R* as sudoer, load the `extrafont` package and import the new installed fonts (takes time...):
    ```
    sudo su
    R
    
    library(extrafont)
    font_import()
    q()
    
    exit
    ```

#### Google Fonts

  - Create a dedicated folder in the above font directory:
    ```
    cd /usr/share/fonts/  
    sudo mkdir google
    cd google
    ```
  - Download the complete google fonts archive, unzip and clean
    ```
    sudo wget https://github.com/google/fonts/archive/master.zip
    sudo unzip master.zip
    sudo rm master.zip
    ```
  - Rebuild the system font cache, and import the new fonts in *R* as described above

  
#### Microsoft Core Fonts

  - download the fonts
    `sudo apt-get install ttf-mscorefonts-installer`
    All fonts are copied in:
    `/usr/share/fonts/truetype/msttcorefonts`
  - Rebuild the system font cache, and import the new fonts in *R* as described above

  
#### Windows Fonts

  - create a dedicated folder in the usual font directory:
    ```
    cd /usr/share/fonts/
    sudo mkdir windows
    ```
  - open an ftp session in *MobaXterm*, and copy the content of `C:\Windows\fonts` to a temporary folder in the shared repository `/usr/local/share/public/fonts`
  - copy the above fonts in the previous directory:
    `cp /usr/local/share/public/fonts/*  /usr/share/fonts/windows/`
  - remove the temporary directory in the shared repository:
    `rm -rf /usr/local/share/public/fonts/*`
  - rebuild the system font cache, and import the new fonts in *R* as described above


 
  <a name="add-ssh-key"/>

### Add SSH Key Pair for Enhanced Security

  <a name="with-key-windows"/>

#### Windows Users
Open *MobaXTerm*, then follow these steps:

    Tools > 
	  MobaKeyGen > 
	    (leave parameters as default) > 
	    Generate > 
	    Move the mouse around in the big empty area over the **Generate** button >
		insert a password twice in the textboxes called **passphrase** >
	Save both public and private keys >
	Close

  <a name="with-key-linux-macos"/>

#### Linux and macOS Users
  - run the command `ssh-keygen`. 
    The keys are immediately created and stored in `/home/usrname/.ssh` with the displayed names (usually id_rsa.pub and id_rsa for the [public and respectively private key). Both the files should be copied somewhere safe, and the private key promptly deleted from the server. The public key is a simple text that can be shared with anyone, and can be easily read with a simple `cat` command if in need of pasting its content.
  - go to Account / Security / SSH keys / Add SSH key
  - Paste the Key in the big textbox, then give it a name in the small textbox below
<br/>

  <a name="resources"/>

## Resources 

 - [WeR Meetup](https://www.meetup.com/WeR-stats/)
 - [WeR GitHub Repository](https://github.com/WeR-stats)
 - [WeR Trello Board](https://trello.com/b/OrAZjOfx/01-set-up-cloud-machine-for-data-science)
 - [WeR Slack Channel](https://we-r-stats.slack.com/messages/CER9296DP/) To join this channel you have to send me a meetup message, including your email and permission to add you as a user.

---
<font size="10">**Disclaimer**</font>

I’m not a *devOps* or *sysAdmin*, and most of this document has been built over years of experience trying to overcome the problem of the hour. So it’s very possible that some steps here are not the very best way of performing the tasks they refer to. 

If anyone has any comments on anything in this document, [I’d love to hear about it!]()

---

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTYyMzgyMTQ4MCwtMjI0MzQ5ODMzLC0xND
c4MjQ5MjQxLC0xMTEyNTc2NzkxLDMzMDAxODI1MiwxODg3NzMx
MjQ4LDEwNTc2OTk5NzIsMTA2MjY3OTg3NiwxODI1Nzc3NTE2LC
0xODEzMzAyMjQ4LDEzMjU2NjM2NTgsODUyMTk1NjgsOTk3NDUy
MjMyLDY4MzUwMDEzNCw4MzY1NjkzNTgsLTk1MDY3ODU4NSwzND
UwMDg3MSwtMTE5MTg3ODY4MSwtODc2MDM2MTk3LC00MDk0MTI0
NjZdfQ==
-->