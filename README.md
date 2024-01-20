# Docker Start
Only for the first time starting your local instance of RO, you must build the Image for Docker:

- `docker build -t hercules-docker .`

Then start it up with: 
- `docker-compose up`

## SQL Table Setup (first time only)
Fix User permissions and create a unique admin profile for phpmyadmin.

- Access the sql server through the docker terminal: `database`
- Log in to mySQL with root `mysql -u ` (empty password is allowed, as set on line 73 in the `docker-compose` file)

- `mysql -u`
- `SHOW DATABASES;` // sanity check I'm in the right terminal/db instance
- `CREATE USER 'admin'@'%' IDENTIFIED BY 'admin';`
- `GRANT ALL PRIVILEGES ON * . * TO 'admin'@'%' WITH GRANT OPTION;`
- `FLUSH PRIVILEGES;`

### Add Essential Data Tables
I used PHPMYADMIN to set up the tables because I don't know SQL syntax very well.

*Log in as your new superadmin to phpmyadmin.*

- Phpmyadmin should be running on `localhost:8081` as soon as you `docker compose up`
- Copy contents of `main.sql` and `logs.sql`

The rest of the .sql files are referenced internally by the engine, so is not required that you import them for Hercules to run, but is great for website databases of your mobs and whatnot. :) 

*Grant all privileges to the `ragnarok` user while you are in here, to prevent issues with the user hercules needs to read/write*

# Building and Compiling Hercules
Now you can log into the app container and create a user for non-root execution of the emulator. Hercules gets VERY angry at you if you try to tell him what to do with more authority than he has. :)

## Create a non-root user 
- login to terminal of container `sandbox-game_servers`
- add new user with the password something simple, like 'admin'
    - `useradd --create-home --shell /bin/bash hercules1 && passwd hercules1`
    - set your password
- chmod the entire hercules directory now to avoid permission denied issues later.
    - `chmod 777 -R app/hercules`

## Hercules Compiling & Packet Version
The PACKETVER must match what the client you intend to use is Hexed to! Don't change it unless you can Hex a new client. :| As of this writing, all of those DiffPatchers have done extinct.

CLIENT PACKET VERSION: `20190605`
This must be explicitly set to work with the client provided. Otherwise you have to figure out how to get another hexed client. ...

[Compiling Hercules Ref](https://wiki.herc.ws/wiki/Compiling)

- login as your non-root user before configuring.
- `login hercules1`
- `cd app/hercules && ./configure --enable-packetver=20190605`
- `make clean` (optional) and `make sql` to set up SQL configurations from confs

## Start Athena and cross your fingers ...

- `./athena-start start`


# Hercules Repo Reference
Since this is meant to be a 'fixed' image of this game, updating shouldn't really be necessary.

- Hercules Github: https://github.com/HerculesWS/Hercules 
- Copy the config files from `/config-templates/import-tmpl` to `/app/hercules/conf/import`. This is where all of the server connection and other settings are stored.

Clone this as your nonroot user, or before continuing or if you have permission denied errors.

Login as the nonroot user in another terminal window to continue with the configuration and setup.



## Stupid things that went wrong while working on this

### Bash interpreter mismatch (?)
I had all kinds of issues getting the `athena-start` script to run, and learned all about `sh`, `dash`, `bash` being different versions of the same utility that isn't always installed in the same place depending on your Linux version. `&^$#^#$%@!!! >:[` 

['Fixed' by making sure the linux/dos line endings were correct](https://www.howtogeek.com/884769/bad-interpreter-no-such-file-or-directory-linux-error/):

- `tr -d '\r' < athena-start.sh > athena-start_u.sh`


### [SQL]: Host '127.0.0.1' is not allowed to connect to this MySQL server
This was mostly due to some 'feature' with the mysql container setup in docker-compose creating the default user with no permissions.

Checking privileges for the sql users 

```
$ mysql -u root -p -h database
$ mysql -u ragnarok -p -h database

mysql> show grants for 'ragnarok'@'database';
```
------

`mysql`
`CREATE USER 'admin'@'%' IDENTIFIED BY 'admin';`
`GRANT ALL PRIVILEGES ON * . * TO 'admin'@'%' WITH GRANT OPTION;`
`FLUSH PRIVILEGES;`


# Special Thanks To

- Hercules Support Team for keeping Athena alive for another 10+ years!!
- 