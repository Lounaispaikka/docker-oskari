# References used:
# https://github.com/phusion/baseimage-docker
# http://oskari.org/documentation/backend/server-embedded-developer
FROM phusion/baseimage:0.9.16
MAINTAINER ekohalsti

# Set correct environment variables
ENV REFRESHED_AT 20.02.2015
ENV HOME /root
ENV OSKARI_TOOLS /opt/mapservice/oskari-server/public/Oskari/tools
WORKDIR $HOME

ENV OSKARI_VERSION 1.27.1

# Update
RUN \
  # Get dependencies
  apt-get -q -y update > /dev/null && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    maven \
    openjdk-7-jdk > /dev/null

# Oskari backend
RUN \
  # Create a folder for the service
  mkdir /opt/mapservice && \
  # Download Oskari backend
  curl -LkO https://github.com/nls-oskari/oskari-server/archive/${OSKARI_VERSION}.tar.gz && \
  # Copy binary
  tar -xf *.tar.gz
  # Install backend
RUN \
  cd */ && \
  mvn -q clean install && \
  cd - && \
  # Move the extracted folder to the correct location and change name to Oskari as per 
  # documentation http://oskari.org/documentation/backend/server-embedded-developer
  mv */standalone-jetty/dist/ /opt/mapservice/oskari-server/ && \
  mv /opt/mapservice/oskari-server/*.jar /opt/mapservice/oskari-server/oskari.jar && \
  # Remove downloaded files
  rm -rf * 

# Oskari frontend
RUN \
  # Download Oskari frontend
  curl -LkO https://github.com/nls-oskari/oskari/archive/${OSKARI_VERSION}.tar.gz && \
  # Extract
  tar -xf *.tar.gz && \
  # Move the extracted folder to the correct location and change name to Oskari as per 
  # documentation http://oskari.org/documentation/backend/server-embedded-developer
  mv */ /opt/mapservice/oskari-server/public/Oskari && \
  rm -f *

WORKDIR $OSKARI_TOOLS

# Node.js and code compression && clean-up of unneeded packages
RUN \
  curl -LkO https://deb.nodesource.com/setup && \
  chmod +x setup && \
  /bin/sh setup && \
  apt-get install -qy nodejs graphicsmagick && \
  npm install -q && \
  npm install -g -q grunt-cli && \
  grunt release:${OSKARI_VERSION}:../applications/paikkatietoikkuna.fi/full-map/minifierAppSetup.json && \
  mkdir /opt/mapservice/oskari-server/public/Oskari/dist/${OSKARI_VERSION}/servlet && \
  mv /opt/mapservice/oskari-server/public/Oskari/dist/${OSKARI_VERSION}/full-map/* /opt/mapservice/oskari-server/public/Oskari/dist/${OSKARI_VERSION}/servlet && \
  mv /opt/mapservice/oskari-server/public/Oskari/dist/${OSKARI_VERSION}/servlet/ /opt/mapservice/oskari-server/public/Oskari/dist/${OSKARI_VERSION}/full-map/ && \
  rm setup && \
  # Remove unneeded packages 
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false maven nodejs graphicsmagick && \
  # Clean up APT when done
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

WORKDIR /opt/mapservice/oskari-server/ 

EXPOSE 2373

# Use baseimage-docker's init system
#ENTRYPOINT ["/sbin/my_init", "--", "/docker-entrypoint.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

# Define default command
CMD ["java", "-jar", "oskari.jar"]
