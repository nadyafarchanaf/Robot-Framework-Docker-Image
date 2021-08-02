#base image
FROM python:3

MAINTAINER Nadya Farchana Fidaroina <nadyafarchanaf@gmail.com>
LABEL description Robot Framework in Docker

# set working directory to project for the container
WORKDIR /project

# copy all the files to the project folder( uses dockerignore to ignore the unnecessary files)
COPY . /project

RUN apt-get update \
	&& apt-get install -y build-essential libssl-dev libffi-dev python-dev \
		xvfb zip wget ca-certificates ntpdate \
		libnss3-dev libasound2 libgbm1 libxss1 libappindicator3-1 libindicator7 gconf-service libgconf-2-4 libpango1.0-0 xdg-utils fonts-liberation \
	&& rm -rf /var/lib/apt/lists/*

#Set dependency
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade robotframework && \
    python3 -m pip install --upgrade robotframework-seleniumlibrary && \
    python3 -m pip install --upgrade robotframework-requests && \
    python3 -m pip install --upgrade robotframework-jsonlibrary && \
    python3 -m pip install --upgrade robotframework-metrics && \
    python3 -m pip install --upgrade robotframework-faker && \
    python3 -m pip install --upgrade robotframework-robocop

# install latest chrome and chromedriver in one run command to clear build caches for new versions (both version need to match)
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
	&& dpkg -i google-chrome*.deb \
	&& rm google-chrome*.deb \
    && wget -q https://chromedriver.storage.googleapis.com/91.0.4472.101/chromedriver_linux64.zip \
	&& unzip chromedriver_linux64.zip \
	&& rm chromedriver_linux64.zip \
	&& mv chromedriver /usr/local/bin \
	&& chmod +x /usr/local/bin/chromedriver

RUN mkdir -p testresults/
VOLUME /project/testresults