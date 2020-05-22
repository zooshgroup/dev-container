# Zoosh Development base container

This is a base container to be used for local nodejs application development. Goal is to provide a complete and easy to use environment when using vscode remote containers.
> Do not use this for production containers

## How to use
This container is published to docker hub with the name 'zoosh/node-dev'. Add `image: zoosh/node-dev:latest` to the project docker compose file to use the latest version.
To run chromium without issues this container is setup with a non root user, to make things easier for development I recommend also adding sysadmin permissions back to the container in the docker compose file:
```
    image: zoosh/node-dev:latest
    cap_add:
      - SYS_ADMIN
```
Once running the container you are logged in as user `zoosh` which is in the sudo group and has password `zoosh`.

## Adding functionality to this container
After adding new functions to the Dockerfile, test the container by building it:
`docker build --no-cache -t zoosh-node-dev:v1 .`
and then run:
`docker run -it --cap-add SYS_ADMIN zoosh-node-dev:v1`

## Pushing a new version to docker hub
1. Create a pull request to this repo
2. Once it is approved and merged a github actions runs and publishes the new container automagically


