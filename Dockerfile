FROM ubuntu:bionic

LABEL maintainer="Maximilian Deubel <max@netz39.de>"

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN \
    apt-get update \
    && echo 'Installing native toolchain and build system functionality' >&2 && \
    apt-get -y --no-install-recommends install \
        curl \
        ccache \
        build-essential \
        git \
	python3-pip \
	python3-ply \
	python3-setuptools \
        python3-wheel \
        gdb-multiarch \
        gperf device-tree-compiler wget xz-utils file make gcc gcc-multilib \
    && echo 'Cleaning up installation files' >&2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
    curl -L -o /opt/zephyr-sdk-0.10.3-setup.run 'https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.10.3/zephyr-sdk-0.10.3-setup.run' && \
    bash /opt/zephyr-sdk-0.10.3-setup.run -- -d /opt/zephyr-sdk && \
    rm /opt/zephyr-sdk-0.10.3-setup.run

RUN \
    pip3 install -r https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/master/scripts/requirements.txt && \
    pip3 install -r https://raw.githubusercontent.com/maz3max/ble-coin/master/prod/requirements_build.txt

ENV CCACHE_DIR=/data/build/prod/build/ccache
ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr
ENV ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk/

WORKDIR /data/build

ENTRYPOINT ["make"]
CMD ["-C", "prod/"]
