# Rmlint
# VERSION 0.0.2
# Website: https://github.com/bobbintb/docker-rmlint

FROM alpine:latest
ENV PATH /rmlint:$PATH
ENV APP_NAME="rmlint"
RUN apk add build-base \
          git \
          scons \
          glib \
          glib-dev \
          libelf \
          sqlite-libs \
          json-glib-dev \
          gtk+3.0 \
          librsvg \
          py3-sphinx \
          elfutils \
          libc6-compat \
          py-cairo \
          dconf \
          gtksourceview \
          python3 \
          py3-gobject3 \
          polkit
COPY rootfs/ /
RUN git clone -b develop https://github.com/sahib/rmlint.git
WORKDIR rmlint
RUN scons config 
RUN scons DEBUG=1
RUN scons DEBUG=1 --prefix=/usr install
###
RUN apk add --no-cache openbox terminus-font
# Additional setup for x11docker option --wm=container
# Creates a custom config file /etc/x11docker/openbox-nomenu.rc
# Disable menus and minimize button.
#RUN mkdir -p /etc/x11docker && \
#    cp /etc/xdg/openbox/rc.xml /etc/x11docker/openbox-nomenu.rc && \
#    sed -i /ShowMenu/d    /etc/x11docker/openbox-nomenu.rc && \
#    sed -i s/NLIMC/NLMC/  /etc/x11docker/openbox-nomenu.rc && \
#    echo "x11docker:-:1999:1999:x11docker,,,:/tmp:/bin/sh" >> /etc/passwd && \
#    echo "x11docker:-:1999:" >> /etc/group

#CMD openbox
