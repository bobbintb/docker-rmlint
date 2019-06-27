# Rmlint
# VERSION 0.0.1
# Website: https://github.com/bobbintb/docker-rmlint

FROM jlesage/baseimage-gui:alpine-3.9-v3.5.2
ENV PATH /rmlint:$PATH

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

RUN git clone -b develop https://github.com/sahib/rmlint.git
WORKDIR rmlint
RUN scons config 
RUN scons DEBUG=1 -j4  # For releases you can omit DEBUG=1
CMD ["/bin/sh"]
