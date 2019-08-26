FROM ubuntu:16.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

COPY ./scripts scripts
RUN chmod -R +x scripts

ENV IMAGE_VERSION=dev \
    METADATA_FILE=/scripts/metadatafile.log \
    HELPER_SCRIPTS=/scripts/helpers

RUN apt-get update \
  && apt-get dist-upgrade -y \
  && systemctl disable apt-daily.service \
  && systemctl disable apt-daily.timer \
  && systemctl disable apt-daily-upgrade.timer \
  && systemctl disable apt-daily-upgrade.service \
  && echo '* soft nofile 50000 \n* hard nofile 50000' >> /etc/security/limits.conf \
  && echo 'session required pam_limits.so' >> /etc/pam.d/common-session \
  && echo 'session required pam_limits.so' >> /etc/pam.d/common-session-noninteractive

# install core apps
RUN apt-get update
RUN apt-get install apt-utils -y
RUN apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        file \
        ftp \
        jq \
        git \
        gnupg \
        iputils-ping \
        libcurl3 \
        libicu55 \
        libunwind8 \
        locales \
        lsb-release \
        netcat \
        rsync \
        software-properties-common \
        sudo \
        time \
        unzip \
        wget \
        zip

# setup installs
RUN ./scripts/base/repos.sh \
  && ./scripts/installers/1604/preparemetadata.sh \
  && ./scripts/installers/1604/basic.sh\
  && ./scripts/installers/7-zip.sh \
  && ./scripts/installers/azcopy.sh \
  && ./scripts/installers/azure-cli.sh \
  && ./scripts/installers/azure-devops-cli.sh \
  && ./scripts/installers/build-essential.sh \
  && ./scripts/installers/clang.sh \
  && ./scripts/installers/cmake.sh \
  && ./scripts/installers/1604/dotnetcore-sdk.sh \
  && ./scripts/installers/erlang.sh \
  && ./scripts/installers/gcc.sh \
  && ./scripts/installers/git.sh \
  && ./scripts/installers/1604/go.sh \
  && ./scripts/installers/hhvm.sh \
  && ./scripts/installers/nodejs.sh \
  && ./scripts/installers/1604/powershellcore.sh \
  && ./scripts/installers/vcpkg.sh \
  && ./scripts/installers/boost.sh

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]