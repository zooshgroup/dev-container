FROM ubuntu:latest

# install essentials and tools we need for other steps
RUN apt-get update && apt-get install -y git sudo wget vim curl ssh ca-certificates --no-install-recommends

# Setup timezone
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata --no-install-recommends
RUN ln -fs /usr/share/zoneinfo/Europe/Budapest /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata


# Add user so we don't run everything as root
# This is needed to run puppeteer whithout disabling the sandbox
# Added the user also to the sudo group and set its password as zoosh
RUN groupadd --gid 1000 zoosh && adduser --uid 1000 --ingroup zoosh zoosh && echo "zoosh:zoosh" | chpasswd && adduser zoosh sudo
# we will need the downloads dir later for chromium
# we need to setup the app dir to avoid permission issues when mounting a volume
RUN  mkdir -p /home/zoosh/Downloads && mkdir -p /home/zoosh/app && mkdir -p /home/zoosh/.ssh && chown -R zoosh:zoosh /home/zoosh
WORKDIR /home/zoosh

# Install node
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs


# Setup puppeteer dependencies
# install manually all the missing chrome libraries 
RUN apt-get install -y gconf-service libappindicator3-1 libasound2 libatk1.0-0 libcairo2 libcups2 libfontconfig1 libgbm1 libgdk-pixbuf2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libxss1 fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils
# install chrome
RUN wget -nv https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install
RUN rm google-chrome-stable_current_amd64.deb

# set env vars so puppeteer will use downloaded chrome version
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome


# Run everything after as non-privileged user.
USER zoosh

# Add github and bitbucket to known hosts
RUN ssh-keyscan -t rsa -H github.com >> ~/.ssh/known_hosts
RUN ssh-keyscan -t rsa -H bitbucket.org >> ~/.ssh/known_hosts
