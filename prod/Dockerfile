# References used:
# https://github.com/phusion/baseimage-docker
# http://oskari.org/documentation/backend/server-embedded-developer
FROM phusion/baseimage:0.9.16
MAINTAINER ekohalsti

# Set correct environment variables
ENV REFRESHED_AT 20.02.2015
ENV HOME /root
WORKDIR $HOME

ENV OSKARI_VERSION 1.25.4

# Update
RUN \
  # Dependencies, which are needed for the build only
  #buildDeps="\
  #  maven \
  #"; \
  # Dependencies needed after build
  #runDeps="\
  #  openjdk-7-jdk \
  #"; \
  # Get dependencies
  apt-get -q -y update && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
	  maven \
	  openjdk-7-jdk

# Oskari backend
RUN \
  # Create a folder for the service
  mkdir /opt/mapservice && \
  # Download Oskari backend
  curl -LkO https://github.com/nls-oskari/oskari-server/archive/${OSKARI_VERSION}.tar.gz && \
  # Copy binary
  tar -xvf *.tar.gz
  # Install backend
RUN \
  cd */ && \
  mvn clean install && \
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
  tar -xvf *.tar.gz && \
  # Move the extracted folder to the correct location and change name to Oskari as per 
  # documentation http://oskari.org/documentation/backend/server-embedded-developer
  mv */ /opt/mapservice/oskari-server/public/Oskari && \
  # Remove unneeded packages
  rm -f * && \
  # Clean up unneeded packages when done
  
  # Clean up APT when done
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

WORKDIR /opt/mapservice/oskari-server/ 

EXPOSE 2373

# Use baseimage-docker's init system
#ENTRYPOINT ["/sbin/my_init", "--", "/docker-entrypoint.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

# Define default command
CMD ["java", "-jar", "oskari.jar"]
