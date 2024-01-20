###
# STAGE 1: BUILD HERCULES
###
FROM ubuntu/mysql
WORKDIR /sandbox
COPY . .

# Set this to "classic" or "renewal" to build the relevant server version (default: classic).
ARG HERCULES_SERVER_MODE=classic

# Set this to a YYYYMMDD date string to build a server for a specific packet version.
# Set HERCULES_PACKET_VERSION to "latest" to build the server for the packet version
# defined in the Hercules code base as the current supported version.
# As a recommended alternative, a "Noob Pack" client download available on the
# Hercules forums is using the packet version 20180418.
# -----------------------------------------------------------
# CLIENT PACKET VERSION: `20190605`
# This must be explicitly set to work with the client provided.

ARG HERCULES_PACKET_VERSION=20190605

# You can pass in any further command line options for the build with the HERCULES_BUILD_OPTS
# build argument.
ARG HERCULES_BUILD_OPTS

ENV HERCULES_PACKET_VERSION=${HERCULES_PACKET_VERSION}
ENV HERCULES_SERVER_MODE=${HERCULES_SERVER_MODE}
ENV HERCULES_BUILD_OPTS=${HERCULES_BUILD_OPTS}

# Install base dependencies
RUN \
  apt-get update && \
  apt-get autoclean && \
  apt-get install -y \
  mysql-server nano

# If sudo is needed, you'll have to install it.
RUN apt install sudo
 
RUN \
  apt install -y \
  build-essential zlib1g-dev libpcre3-dev libmysqlclient-dev 

# Login server, Character server, Map server, SQL server
EXPOSE 6900 6121 5121 3306