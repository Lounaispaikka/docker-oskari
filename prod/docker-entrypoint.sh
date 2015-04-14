#!/bin/bash
set -e

if [ "$1" = 'java' ]; then
	if [ "$DB_PORT_5432_TCP_ADDR" ]; then #check set the address of db server. 
		sed -ri "s/(^db\.url=.+)localhost(.+)/\1${DB_PORT_5432_TCP_ADDR}\2/" /opt/mapservice/oskari-server/oskari-ext.properties
	else #if not set we have no database at all and cannot start the server
		cat >&2 <<-'EOWARN'
			****************************************************
			WARNING: No database set. Either link database with
			name "db" or set "-e DB_PORT_5432_TCP_ADDR=<address>"
			****************************************************
		EOWARN
	fi

	if  [ "$USER" ]; then 
		#set user
		sed -ri "s/(^db\.username=).+/\1${USER}/" /opt/mapservice/oskari-server/oskari-ext.properties

	else 
		#if not set assume 'postgres'
		sed -ri "s/(^db\.username=).+/\1postgres/" /opt/mapservice/oskari-server/oskari-ext.properties

	fi

	if [ "$PASSWORD" ]; then
		#set password
		sed -ri "s/(^db\.password=).+/\1${PASSWORD}/" /opt/mapservice/oskari-server/oskari-ext.properties

	else 
		#if password is not set assume user 'postgres' and set it to empty
		sed -ri "s/(^db\.password=).+/\1/" /opt/mapservice/oskari-server/oskari-ext.properties		
	fi
    
    if [ "$VERSION" ]; then #setting version minifies the oskari instance & sets development to false
        #set development to false
        echo "development=false" >> /opt/mapservice/oskari-server/oskari-ext.properties &&
        #set version
        echo "oskari.client.version=dist/${VERSION}/full-map" >> /opt/mapservice/oskari-server/oskari-ext.properties
    fi
    echo "oskari.locales=fi_FI,en_EN,sv_SE" >> /opt/mapservice/oskari-server/oskari-ext.properties
fi

exec "$@"
