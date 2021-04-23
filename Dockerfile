FROM ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update
RUN apt-get install -y wget gnupg
# https://dotnet.microsoft.com/download/linux-package-manager/ubuntu16-04/sdk-current
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
   
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt update
   
RUN apt-get install \
 unzip \
 mono-devel \
 mono-complete \
 nuget \
 msbuild \
 referenceassemblies-pcl \
 curl \
 lxd \
 openjdk-8-jdk \
 dotnet-sdk-5.0 \
 apt-transport-https \
 -y


RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Install Android SDK tools
RUN mkdir -p /android/sdk && \
    curl -k https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -o sdk-tools-linux-3859397.zip && \
    unzip -q sdk-tools-linux-3859397.zip -d /android/sdk && \
    rm sdk-tools-linux-3859397.zip

RUN cd /android/sdk && \
    yes | ./tools/bin/sdkmanager --licenses && \
    ./tools/bin/sdkmanager 'build-tools;30.0.2' platform-tools 'platforms;android-29' 'ndk-bundle'
	
RUN export AndroidSdkDirectory=/android/sdk

RUN cd /

# Install Xamarin Android
RUN wget -O xamarinAndroid.zip https://artprodcus3.artifacts.visualstudio.com/Ad0adf05a-e7d7-4b65-96fe-3f3884d42038/6fd3d886-57a5-4e31-8db7-52a1b47c07a8/_apis/artifact/cGlwZWxpbmVhcnRpZmFjdDovL3hhbWFyaW4vcHJvamVjdElkLzZmZDNkODg2LTU3YTUtNGUzMS04ZGI3LTUyYTFiNDdjMDdhOC9idWlsZElkLzM4OTI2L2FydGlmYWN0TmFtZS9pbnN0YWxsZXJzLXVuc2lnbmVkKy0rTGludXg1/content?format=zip
RUN unzip -q xamarinAndroid.zip -d xamarinAndroid
RUN dpkg -i 'xamarinAndroid/installers-unsigned - Linux/xamarin.android-oss_11.2.99.0_amd64.deb'

RUN rm -r xamarinAndroid/
RUN rm xamarinAndroid.zip


RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu60 \
        libunwind8 \
        netcat \
        libssl1.0

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
