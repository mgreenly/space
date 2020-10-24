ARG FROM_IMAGE
ARG FROM_TAG
ARG GHC_VER
ARG CABAL_VER

FROM ${FROM_IMAGE}:${FROM_TAG}

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN USERNAME=haskell \
    DEBIAN_FRONTEND=noninteractive \
    && cd /tmp \
    && apt-get -q -y update \
    && apt-get \
      -o Dpkg::Options::="--force-confdef" \
      -o Dpkg::Options::="--force-confold" \
      -q -y install \
      build-essential \
      curl \
      libffi-dev  \
      libffi6 \
      libgmp-dev \
      libgmp10 \
      libncurses-dev \
      libncurses5 \
      libtinfo5 \
      libz-dev \
    && adduser --disabled-password --gecos "" --uid 1000 $USERNAME \
    && chmod +x /usr/local/bin/entrypoint.sh

ENV PATH="/home/haskell/.cabal/bin:/home/haskell/.ghcup/bin:${PATH}"

USER "haskell"

RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org |\
    BOOTSTRAP_HASKELL_NONINTERACTIVE=true \
    BOOTSTRAP_HASKELL_GHC_VERSION=${GHC_VER} \
    BOOTSTRAP_HASKELL_CABAL_VERSION=${CABAL_VER} \
    sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
