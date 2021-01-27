ARG FROM_IMAGE
ARG FROM_TAG
FROM ${FROM_IMAGE}:${FROM_TAG}

ARG GHC_VER
ARG CABAL_VER

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

ENV PATH="/root/.cabal/bin:/root/.ghcup/bin:${PATH}"

RUN DEBIAN_FRONTEND=noninteractive \
    && cd /tmp \
    && apt-get -q -y update \
    && apt-get \
      -o Dpkg::Options::="--force-confdef" \
      -o Dpkg::Options::="--force-confold" \
      -q -y install \
      build-essential \
      libffi-dev  \
      libgmp-dev \
      libncurses-dev \
      libnuma-dev \
      libtinfo-dev \
      zlib1g-dev \
    && chmod a+x /usr/local/bin/entrypoint.sh

RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org |\
    BOOTSTRAP_HASKELL_NONINTERACTIVE=true \
    BOOTSTRAP_HASKELL_GHC_VERSION=$GHC_VER \
    BOOTSTRAP_HASKELL_CABAL_VERSION=$CABAL_VER \
    sh && \
    chmod -R 777 /root

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/bin/bash"]
