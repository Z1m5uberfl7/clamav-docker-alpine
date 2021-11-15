# clamav-docker-alpine
Dockerhub: https://hub.docker.com/repository/docker/j1mprime/clamav-docker-alpine

Github: https://github.com/j1mprime/clamav-docker-alpine.git

This image provides the clamav alpine image with preloaded main.cvd.
<b>Using this container will save the ClamAV project some bandwidth.</b>
The main.cvd database is downloaded just before the build manually as Cloudflares rate limiting blocks automatic downloads with wget, curl etc. even at build time.

Naming convention of docker image tags:

      j1mprime/clamav-docker-alpine:[image version]-alpine-[alpine version]-maincvd-[timestamp of maincvd download]

for example:

      j1mprime/clamav-docker-alpine:1.0.0-alpine-3.14-maincvd-20211115

## Usage
Clamd  will listen on port 3310. Publish port 3310 on the host:

      docker run -d -p 3310:3310 j1mprime/clamav-docker-alpine:1.0.0-alpine-3.14-maincvd-20211115

## Build and run the image locally
1. Checkout https://github.com/j1mprime/clamav-docker-alpine.git
1. Download https://database.clamav.net/main.cvd from clamav server.
2. Copy main.cvd next to Dockerfile
2. Build, Deploy and Run
    <pre>docker build . --no-cache -t j1mprime/clamav-docker-alpine:1.0.0-alpine-3.14-maincvd-20211115
   docker push j1mprime/clamav-docker-alpine:1.0.0-alpine-3.14-maincvd-20211115
   docker run -d -p 3310:3310 j1mprime/clamav-docker-alpine:1.0.0-alpine-3.14-maincvd-20211115</pre>