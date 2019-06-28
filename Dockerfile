# Rmlint
# VERSION 0.0.1
# Website: https://github.com/bobbintb/docker-rmlint

FROM jlesage/baseimage-gui:alpine-3.9-v3.5.2
ENV PATH /rmlint:$PATH
ENV APP_NAME="rmlint"

RUN add-pkg build-base \
          python \
          git \
          scons \
          glib \
          glib-dev \
          libelf \
          libelf-dev \
          sqlite-libs \
          json-glib-dev \
          gtk+3.0 \
          librsvg \
          py-gobject \
          py-sphinx \
          elfutils \
          libc6-compat \
          py-cairo \
          dconf \
          gtksourceview \
          python3 \
          py-gobject3 \
          py3-gobject3 \
          polkit
COPY rootfs/ /
RUN git clone -b develop https://github.com/sahib/rmlint.git
WORKDIR rmlint
RUN scons config 
RUN scons DEBUG=1
RUN scons DEBUG=1 --prefix=/usr install
CMD ["/bin/sh"]
