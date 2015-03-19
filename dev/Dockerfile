# References used:
# https://github.com/phusion/baseimage-docker
# http://oskari.org/documentation/backend/server-embedded-developer
FROM phusion/baseimage:0.9.16
MAINTAINER nakanaa

# Set correct environment variables
ENV REFRESHED_AT 20.02.2015
ENV HOME /root
WORKDIR $HOME

RUN \  
  apt-get -q -y update && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    #java
    openjdk-7-jdk \
    #maven
    maven \
      # Install Wget for download (weird problem with cURL)
	  #wget \
      # Install packages required by PhantomJS
#      libfontconfig1-dev libfreetype6 && \
  # Clean up APT when done
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV OSKARI_VERSION 1.25.4

RUN \
  # Download Oskari frontend
  curl -LkO https://github.com/nls-oskari/oskari/archive/${OSKARI_VERSION}.tar.gz && \
  # Extract
  tar -xvf *.tar.gz && \
  # Create a folder for the service
  mkdir /opt/mapservice && \
  # Move the extracted folder to the correct location and change name to Oskari as per 
  # documentation http://oskari.org/documentation/backend/server-embedded-developer
  mv */ /opt/mapservice/Oskari && \
  # Remove unneeded packages
  rm -f * && \
  
  # Download Oskari backend
  curl -LkO https://github.com/nls-oskari/oskari-server/archive/${OSKARI_VERSION}.tar.gz && \
  # Copy binary
  tar -xvf *.tar.gz && \
  # Move the extracted folder to the correct location and change name to Oskari as per 
  # documentation http://oskari.org/documentation/backend/server-embedded-developer
  mv */ /opt/mapservice/oskari-server && \
  # Remove downloaded files
  rm -f * && \
  # Move to correct directory
  cd /opt/mapservice/ && \
  # Install oskari backend
  mvn clean install

# Use baseimage-docker's init system
ENTRYPOINT ["/sbin/my_init", "--"]

# Define default command
CMD ["/usr/bin/phantomjs"]