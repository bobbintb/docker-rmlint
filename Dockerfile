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
ADD /apk /apk
RUN cp /apk/.abuild/-58b83ac3.rsa.pub /etc/apk/keys
RUN apk --no-cache add x11vnc
RUN apk --no-cache add xvfb openbox xfce4-terminal supervisor sudo \
&& addgroup alpine \
&& adduser  -G alpine -s /bin/sh -D alpine \
&& echo "alpine:alpine" | /usr/sbin/chpasswd \
&& echo "alpine    ALL=(ALL) ALL" >> /etc/sudoers \
&& rm -rf /apk /tmp/* /var/cache/apk/*
ADD etc /etc
WORKDIR /home/alpine
EXPOSE 5901
USER alpine
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
