ARG FROM_IMAGE
ARG FROM_TAG
FROM ${FROM_IMAGE}:${FROM_TAG}

RUN DEBIAN_FRONTEND=noninteractive \
    && cd /tmp \
    && apt-get -q -y update \
    && apt-get \
      -o Dpkg::Options::="--force-confdef" \
      -o Dpkg::Options::="--force-confold" \
      -q -y install \
      curl \
      libffi6 \
      libgmp10 \
      libncurses5 \
      libnuma1 \
      libtinfo5 \
      zlib1g
