# CakePHP 3 with Docker on Ubuntu 16.04
Dear friends,\
i played around with Docker for a while now and wanted to share my approach to setup CakePHP 3 within Docker containers running PHP with Apache and MySQL.

I hope this repository might help some of you get started. Please **read** this file carefully. I'll explain step by step what to do :)

## Requirements
* Done with **Ubuntu 16.04 LTS**
* [Docker](https://store.docker.com/editions/community/docker-ce-server-ubuntu "Docker") **with** docker-compose

## Hint (A little control kickin)
This is just FYI if you want to know the differences on how to work with the containers.

> **exec** is used in this case because we want to run commands on already running containers.

If you are **inside the containers bash** you can use commands like this:

* ```php -v```
* ```ls /usr/local/lib/php/extensions```

Otherwise you can do the equivalent when **not inside the container bash** with:

* ```docker-compose exec php php -v```
* ```docker-compose exec php ls /usr/local/lib/php/extensions```

> The name of the container matches the name of the service in your **docker-compose.yml**.\
docker-compose exec **SERVICENAME** COMMAND

It is also possible to use the **docker** command instead like this:

* ```docker exec php-5-cake3 php -v```
* ```docker exec php-5-cake3 ls /usr/local/lib/php/extensions```

> The name of the container matches the name generated when running the containers.\
docker exec **CONTAINERNAME** COMMAND

however there is a slight difference when trying to access the bash:

* ```docker-compose exec php bash```
* ```docker exec -ti php-5-cake3 bash```

It is necessary to use the **-ti** argument when using **docker** to start an interactive terminal mode.\
**docker-compose** does that for you automatically.

Check out the docs of the exec commands of both if you want to learn more.

## Adjust your virtual host domain
* Open the **apache-config.conf** file in the root directory.
* Change: ServerName "**YOUR-NAME.local**" to the domain you want to use for development
* Edit your **hosts** file on your machine
    * Locate the file at: **```/etc/hosts```**
    * Open it with a file editor (You need root privilegs to edit this file)
    * Search for this line: **```127.0.0.1 localhost```**
    * Change it to this: **```127.0.0.1 localhost YOUR-NAME.local```**
    * Save the file. That should be it :)

## Installation of CakePHP
* Start terminal in the root directory
* ```docker-compose up --build -d```
* ```docker-compose exec php composer create-project --prefer-dist cakephp/app app```
* ```sudo chmod 0777 -R app```

> If there is a better way than **chmod** here please let me know. For development cases it's good enough in my case.

## How to use Composer and install PHPUnit
* ```docker-compose exec php bash```
* ```cd app```
* ```composer require --dev phpunit/phpunit:"^5.7"```
* ```composer test```

> This isn't necessary if you don't need Unit/Functional Tests. Maybe you should consider Tests anyway ;)

## Check if XDebug is available

* ```php -v``` or ```docker-compose exec php php -v```

The output should be *something* like that:

> PHP 5.6.30 (cli) (built: Jul  4 2017 04:28:04)\
 Copyright (c) 1997-2016 The PHP Group\
 Zend Engine v2.6.0, Copyright (c) 1998-2016 Zend Technologies\
     with **Xdebug v2.5.5**, Copyright (c) 2002-2017, by Derick Rethans
     
### If XDebug is not available check the php extension path

* ```ls /usr/local/lib/php/extensions```
* ```docker-compose exec php ls /usr/local/lib/php/extensions```

The output should be something like that:

> no-debug-non-zts-20131226

Open the **docker-php-ext-xdebug.ini** in the root directory and replace the bold part with the correct name:

> zend_extension=/usr/local/lib/php/extensions/**no-debug-non-zts-20131226**/xdebug.so

Rebuild the image with **```docker-compose build```**

## What's next?
Start developing!

You can start and stop your containers with these commands:

* To start: ```docker-compose up -d```
* To stop: ```docker-compose down```
* Check running containers: ```docker-compose ps```

> It is necessary to be in the directory where your **docker-compose.yml** file is located. Otherwise docker-compose won't work!

## Final words

Please don't hestitate to improve this repository by sending Pull Requests. I would much appreciate any help.

I hope you enjoy this setup process. Have fun with CakePHP!