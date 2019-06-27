# Rmlint
# VERSION 0.0.1
# Website: https://github.com/bobbintb/docker-rmlint

FROM jlesage/baseimage-gui:alpine-3.9-v3.5.2
ENV PATH /rmlint:$PATH
ENV APP_NAME="rmlint"

RUN \
    add-pkg --virtual build-dependencies \
        build-base \
        python \
        git \
        scons \
        glib \
        glib-dev \
        libelf \
        libelf-dev \
        sqlite-libs \
        json-glib-dev
COPY rootfs/ /
RUN git clone -b develop https://github.com/sahib/rmlint.git
WORKDIR rmlint
RUN scons config 
RUN scons -j4
CMD ["/bin/sh"]
