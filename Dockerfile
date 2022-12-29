FROM dart:stable AS build

RUN apt-get update && apt-get -y install sudo wget git tar unzip make autoconf automake  lcov default-jdk gnupg

ENV PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/android-sdk-linux/platform-tools/:/root/.pub-cache/bin

ARG FLUTTERVERSION
RUN dart pub global activate fvm
RUN fvm install $FLUTTERVERSION

ENV ANDROID_COMPILE_SDK=30
ENV ANDROID_BUILD_TOOLS=30.0.3
ENV ANDROID_SDK_TOOLS=6858069
ENV ANDROID_HOME=/opt/android-sdk-linux

RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip     && unzip android-sdk.zip -d /opt/android-sdk-linux/     && echo "y" | /opt/android-sdk-linux/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "platforms;android-${ANDROID_COMPILE_SDK}"     && echo "y" | /opt/android-sdk-linux/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "platform-tools"     && echo "y" | /opt/android-sdk-linux/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "build-tools;${ANDROID_BUILD_TOOLS}"     && echo "y" | /opt/android-sdk-linux/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "extras;android;m2repository"     && echo "y" | /opt/android-sdk-linux/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "extras;google;google_play_services"     && echo "y" | /opt/android-sdk-linux/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "extras;google;m2repository"     && yes | /opt/android-sdk-linux/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME --licenses || echo "Failed"     && rm android-sdk.zip
RUN echo "y" | /opt/android-sdk-linux/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "emulator"     && echo "y" | /opt/android-sdk-linux/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "system-images;android-18;google_apis;x86"     && echo "y" | /opt/android-sdk-linux/cmdline-tools/bin/sdkmanager --sdk_root=$ANDROID_HOME "system-images;android-27;google_apis_playstore;x86"


RUN curl -sL https://firebase.tools | bash

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list &&  \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - &&  \
    apt-get update -y &&  \
    apt-get install google-cloud-cli -y


