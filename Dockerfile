FROM alpine:latest
WORKDIR /src

RUN apk add go




RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

RUN apk update && \
    apk add openbox supervisor su-exec && \
    rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/desktop-directories

RUN apk add lxterminal nano wget openssh-client rsync ca-certificates xdg-utils htop tar gzip bzip2 zip unzip && \
    rm -rf /var/lib/apt/lists

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

RUN git clone -b develop https://github.com/sahib/rmlint.git
WORKDIR rmlint
RUN scons config 
RUN scons DEBUG=1
RUN scons DEBUG=1 --prefix=/usr install

#RUN apt-get update -y && \
#    apt-get install -y --no-install-recommends thunderbird && \

RUN rm -rf /var/lib/apt/lists

#COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
ADD etc /etc
#COPY menu.xml /etc/xdg/openbox/
#COPY supervisord.conf /etc/
EXPOSE 8080

RUN adduser -D -h /data --shell /bin/bash --uid 1000 -g 1000 app && \
    mkdir -p /data
VOLUME /data

CMD ["sh", "-c", "chown app:app /data /dev/stdout && exec su-exec app supervisord"]
