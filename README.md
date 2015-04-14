# docker-oskari
Oskari Dockerfile

This repository contains Dockerfile and an entrypoint file of Oskari mapservice's automated build. It is published through Docker Hub Registry.

ENV OSKARI_VERSION set oskari version. Current version on 11.4.2015 is 1.27.1

The container is built so, that when it is run one can set the location, username and password for the container. If a version is supplied Oskari is minified. The version must be the same as the enviroment variable OSKARI_VERSION set in the Dockerfile.

$DB_PORT_5432_TCP_ADDR address of the database
$USER username for the database
$PASSWORD password of the database user
$VERSION oskari version this must be 

USAGE
docker run -e "DB_PORT_5432_TCP_ADDR=<db>" -e "PASSWORD=<passwd>" -e "USER=<db_user>" -e "VERSION=<version>" -d --name="oskari" -p 80:2373 ekohalsti/docker-oskari
