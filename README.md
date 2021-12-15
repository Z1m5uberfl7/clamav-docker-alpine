# clamav-docker-alpine
This minimalistic alpine image provides clamd and freshclam with preloaded main.cvd from clamav. Incremental updates are loaded on container startup by freshclam.

Dockerhub: https://hub.docker.com/repository/docker/j1mprime/clamav-docker-alpine

Github: https://github.com/j1mprime/clamav-docker-alpine.git

<b>Using this container will save the ClamAV project some bandwidth.</b>
The main.cvd database is downloaded just before the build manually as Cloudflares rate limiting blocks automatic downloads with wget, curl etc. even at build time.

Naming convention of specific docker image tags:

      j1mprime/clamav-docker-alpine:[image version]-alpine-[alpine version]-clamav-[clamav version]-maincvd-[timestamp of maincvd download]

for example:

      j1mprime/clamav-docker-alpine:1.0.3-alpine-3.14-clamav-0.103.3-r0-maincvd-20211215

Alternatively use latest tag. All tags schould be stable.

## Usage
Clamd  will listen on port 3310. Publish port 3310 on the host:

      docker run -d -p 3310:3310 j1mprime/clamav-docker-alpine:latest

## Custom configuration

### Provide custom 'freshclam.conf' or 'clamd.conf' and mount into container on startup
Use environment variable USE_FRESHCLAM_CONF_FILE or USE_CLAMD_CONF_FILE to enable feature.
Provide dedicated freshclam.conf or clamd.conf in source path and set target to /mnt/:

      docker run --mount type=bind,source=d:/mnt/,target=/mnt/ --env "USE_FRESHCLAM_CONF_FILE=true" -d -p 3310:3310 j1mprime/clamav-docker-alpine:latest
### Provide updated clamav database file 'main.cvd' and mount into container on startup
Use environment variable USE_MAIN_CVD_FILE to enable feature.
Provide dedicated main.cvd in source path and set target to /mnt/:

      docker run --mount type=bind,source=d:/mnt/,target=/mnt/ --env "USE_MAIN_CVD_FILE=true" -d -p 3310:3310 j1mprime/clamav-docker-alpine:latest

### Build and run the image locally
1. Checkout https://github.com/j1mprime/clamav-docker-alpine.git
1. Download https://database.clamav.net/main.cvd from clamav server.
2. Copy main.cvd next to Dockerfile
2. Build, Deploy and Run
    <pre>docker build . -t j1mprime/clamav-docker-alpine:latest
   docker push j1mprime/clamav-docker-alpine:latest
   docker run -d -p 3310:3310 j1mprime/clamav-docker-alpine:latest</pre>