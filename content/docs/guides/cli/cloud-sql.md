---
layout: default
title: Cloud SQL instances
section: CLI
---

Cloud SQL instances are relational database servers you can build and manage via the Brightbox Cloud API (and therefore via our CLI tool and web based GUI).

This guide will take you through creating a new Cloud SQL instance, setting it up for use as a blog and finally snapshotting and cloning it.

### Creating a new Cloud SQL instance

Cloud SQL instances are managed using the `brightbox sql` command. First let's choose an instance type from the ones available:

    #!shell
    $ brightbox sql types
    
     id         name    description  ram   disk  
    ----------------------------------------------
     dbt-k63ry  Small                2048  81920 
     dbt-6n6d0  Medium               4096  163840
     dbt-uz09d  Large                8192  327680
    ----------------------------------------------

Let's create a `Medium` Cloud SQL instance called `My first MySQL server`:

    #!shell
    $ brightbox sql instances create --type dbt-6n6d0 --name "My first MySQL server" 
                id: dbs-2yazz
              name: My first MySQL server
       description: 
            status: creating
              type: dbt-6n6d0
            engine: mysql
           version: 5.5
              zone: gb1-a
        created_on: 2014-01-27
    admin_username: admin
    admin_password: gkro6e8f4ib3nixa
      allow_access: 
      cloud_ip_ids: 
         cloud_ips:

This starts creating a new instance with a MySQL user named `admin`. The `admin_password` is generated once and not stored, so you need to note that down so you can log into the MySQL server.

So once this instance is built, it will change from status `creating` to status `active`:

    #!shell
    $ brightbox sql instances 
    
     id         status  type       db_engine  zone   created_on  cloud_ip_ids  name                 
    -------------------------------------------------------------------------------------------------
     dbs-2yazz  active  dbt-6n6d0  mysql-5.5  gb1-a  2014-01-27                My first MySQL server
    -------------------------------------------------------------------------------------------------

#### Map a Cloud IP

We now have to map a Cloud IP to the instance, so we can access it:

    #!shell
    $ brightbox cloudips create --name "My MySQL IP"
    
     id         status    public_ip       destination  reverse_dns                           name       
    -----------------------------------------------------------------------------------------------------
     cip-wgemn  unmapped  109.107.38.255               cip-109-107-38-255.gb1.brightbox.com  My MySQL IP
    -----------------------------------------------------------------------------------------------------

    $ brightbox cloudips map cip-wgemn dbs-2yazz
    Mapping cip-wgemn to destination dbs-2yazz
    
     id         status  public_ip       destination  reverse_dns                           name       
    ---------------------------------------------------------------------------------------------------
     cip-wgemn  mapped  109.107.38.255  dbs-2yazz    cip-109-107-38-255.gb1.brightbox.com  My MySQL IP
    ---------------------------------------------------------------------------------------------------

#### Access control

And the last step before we can actually access the instance is to allow access from our IP. We can grant access to Cloud Servers, server groups or just directly to known IP addresses.

In this case I want to access the instance from my office, so I'll grant access to my IP address.

    #!shell
    $ brightbox sql instances update --allow-access=93.184.216.119 dbs-2yazz
    Updating dbs-2yazz
    
     id         status  type       db_engine  zone   created_on  cloud_ip_ids  name                 
    -------------------------------------------------------------------------------------------------
     dbs-2yazz  active  dbt-6n6d0  mysql-5.5  gb1-a  2014-01-27  cip-wgemn     My first MySQL server
    -------------------------------------------------------------------------------------------------

You can add multiple IPs (or cloud servers etc.) by comma separating them.

### First login

So now we can access the new MySQL instance via the Cloud IP using the standard mysql command line tools. Use the `admin` user and the `admin_password` that was generated when the instance was created:

    #!shell
    $ mysql -h 109.107.38.255 -u admin -p
    Enter password: gkro6e8f4ib3nixa
    
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 71
    Server version: 5.5.35-33.0-log Percona Server (GPL), Release 33.0
    
    mysql>


### Create a new MySQL user

We don't want to have our blog using the `admin` user, as it has too many privileges, so let's create a new user with less powers:

    #!shell
    mysql> CREATE USER 'blog'@'%' IDENTIFIED BY 'zoow9peR';
    Query OK, 0 rows affected (0.02 sec)
    
    mysql> GRANT Alter, Alter routine, Create, Create routine, Create temporary tables, Create view, Delete, Drop, Index, Insert, Lock tables, References, Select, Show view, Update on blog.* TO 'blog'@'%';
    Query OK, 0 rows affected (0.02 sec)

Then reconnect as the new user and create the database. Here I'm loading a previous mysqldump I have of my blog's database too:

    #!shell
    $ mysql -u blog -p -h 109.107.38.255
    Enter password: zoow9peR
    
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 81
    Server version: 5.5.35-33.0-log Percona Server (GPL), Release 33.0
    
    mysql> CREATE DATABASE blog;
    Query OK, 1 row affected (0.04 sec)
    
    mysql> USE blog;
    Database changed
    
    mysql> source ~/blog.sql
    Query OK, 1857 rows affected (0.11 sec)
    Records: 1857  Duplicates: 0  Warnings: 0
    Query OK, 3986 rows affected (0.26 sec)
    Records: 3986  Duplicates: 0  Warnings: 0
    Query OK, 1023 rows affected (0.13 sec)
    Records: 1023  Duplicates: 0  Warnings: 0
    Query OK, 2363 rows affected (0.13 sec)
    Records: 2363  Duplicates: 0  Warnings: 0
    Query OK, 1424 rows affected (0.07 sec)
    Records: 1424  Duplicates: 0  Warnings: 0

### Grant access to web servers

Now I need to allow my web servers access to the SQL instance. My web servers are in a server group:

    #!shell
    $ brightbox groups 
    
     id         server_count  name              
    ---------------------------------------------
     grp-51s4o  22            default           
     grp-od82x  13            admin access
     grp-xpd1q  2             web servers       
    ---------------------------------------------

So I can add that server group identifier to the access list for this SQL instance:

    #!shell
    $ brightbox sql instances update --allow-access=93.184.216.119,grp-1ljcx dbs-2yazz
    Updating dbs-2yazz
    
     id         status  type       db_engine  zone   created_on  cloud_ip_ids  name                 
    -------------------------------------------------------------------------------------------------
     dbs-2yazz  active  dbt-6n6d0  mysql-5.5  gb1-a  2014-01-27  cip-wgemn     My first MySQL server
    -------------------------------------------------------------------------------------------------

And now all my web servers in my server group `grp-1ljcx` have access, and any servers added to that group in the future will automatically be granted access.

### Snapshotting a Cloud SQL instance

Let's take a snapshot of this new Cloud SQL instance before we go live with the blog:

    #!shell
    $ brightbox sql instances snapshot dbs-2yazz
    Creating snapshot for dbs-2yazz
    
     id         status  type       db_engine  zone   created_on  cloud_ip_ids  name                 
    -------------------------------------------------------------------------------------------------
     dbs-2yazz  active  dbt-6n6d0  mysql-5.5  gb1-a  2014-01-27  cip-wgemn     My first MySQL server
    -------------------------------------------------------------------------------------------------

And we can then view the snapshot using the `brightbox sql snapshots` command:

    #!shell
    $ brightbox sql snapshots
    
     id         status     created_on  name                                description
    -----------------------------------------------------------------------------------
     dbi-ydtnk  available  2014-01-27  Snapshot of dbs-2yazz 27 Jan 20:28             
    -----------------------------------------------------------------------------------

And now we'll create another Cloud SQL instance, using the snapshot of the other instance as a starting point. Just specify the snapshot identifier when building:

    #!shell
    $ brightbox sql instances create --type dbt-6n6d0 --name "My cloned MySQL server"  --snapshot=dbi-ydtnk
                id: dbs-rkl8e
              name: My cloned MySQL server
       description: 
            status: creating
              type: dbt-6n6d0
            engine: mysql
           version: 5.5
              zone: gb1-a
        created_on: 2014-01-27
    admin_username: admin
    admin_password: 
      allow_access: 
      cloud_ip_ids: 
         cloud_ips:

In this case, the `admin_password` is blank as it inherits the password in the snapshot. You can reset it at any time using the `brightbox sql instances reset-password` command, if you lose track of which snapshot has what admin password (or if you lock yourself out of an instance).

### Remapping a Cloud IP

Let's say we upgraded our blog software and it went crazy and deleted some records from our live Cloud SQL instance (the one with the identifier `dbs-2yazz`). We can quickly switch to the cloned SQL instance (`dbs-rkl8e`) just by remapping the Cloud IP:

    #!shell
    $ brightbox cloudips unmap cip-wgemn
    Unmapping Cloud IP cip-wgemn
    
     id         status    public_ip       destination  reverse_dns                           name       
    -----------------------------------------------------------------------------------------------------
     cip-wgemn  unmapped  109.107.38.255               cip-109-107-38-255.gb1.brightbox.com  My MySQL IP
    -----------------------------------------------------------------------------------------------------
    
    $ brightbox cloudips map cip-wgemn dbs-rkl8e
    Mapping cip-wgemn to destination dbs-rkl8e
    
     id         status  public_ip       destination  reverse_dns                           name       
    ---------------------------------------------------------------------------------------------------
     cip-wgemn  mapped  109.107.38.255  dbs-rk18e    cip-109-107-38-255.gb1.brightbox.com  My MySQL IP
    ---------------------------------------------------------------------------------------------------

And the blog is back to where we started! Snapshots are stored on a highly-available storage system, replicated across two zones, so they're ideal for backups.

