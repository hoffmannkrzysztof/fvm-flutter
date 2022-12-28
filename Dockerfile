FROM dart:stable AS build


RUN apt-get update && apt-get -y install sudo wget git

ARG FLUTTERVERSION

RUN dart pub global activate fvm
ENV PATH="$PATH":"/root/.pub-cache/bin"
RUN fvm install $FLUTTERVERSION

RUN curl -sL https://firebase.tools | bash

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-cli -y
