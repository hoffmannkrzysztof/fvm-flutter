FROM dart:stable AS build


RUN apt-get update && apt-get -y install sudo

ARG FLUTTERVERSION

RUN dart pub global activate fvm
ENV PATH="$PATH":"/root/.pub-cache/bin"
RUN fvm install $FLUTTERVERSION

RUN curl -sL https://firebase.tools | bash
