ARG REDIS_VERSION
FROM redis:${REDIS_VERSION:-latest}

ENV DEBIAN_FRONTEND='noninteractive'

ARG TIMEZONE
ENV TZ=${TIMEZONE:-America/New_York}

ARG BUILD_CONTEXT_PATH
COPY ${BUILD_CONTEXT_PATH}bin/root-certs.sh /root/.local/bin/root-certs.sh
COPY ${BUILD_CONTEXT_PATH}cert[s]/* /tmp/certs/

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        debconf-utils \
        build-essential \
        lsb-release \
        procps \
        git \
        ca-certificates \
        openssl \
        wget \
        libc6 \
        libgcc-s1 \
        libgssapi-krb5-2 \
        libicu72 \
        libssl3 \
        libstdc++6 \
        libgdiplus \
        zlib1g && \
    bash /root/.local/bin/root-certs.sh /tmp/certs/ && \
    wget -q https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -P /tmp/ && \
    dpkg -i /tmp/packages-microsoft-prod.deb && \
    rm /tmp/packages-microsoft-prod.deb && \
    apt-get -y update && \
    apt-get install -y --no-install-recommends powershell && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

    ENTRYPOINT ["/docker-entrypoint.sh"]

    CMD ["redis-server"]
