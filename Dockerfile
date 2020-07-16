FROM golang:1.14-buster AS easy-novnc-build
WORKDIR /src
RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

FROM debian:buster

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends openbox supervisor gosu && \
    rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/desktop-directories

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends lxterminal nano wget openssh-client rsync ca-certificates xdg-utils htop tar xzip gzip bzip2 zip unzip && \
    rm -rf /var/lib/apt/lists

#rmlint install
RUN apt-get install git scons python3-sphinx python3-nose gettext build-essential
    # Optional dependencies for more features:
RUN apt-get install libelf-dev libglib2.0-dev libblkid-dev libjson-glib-1.0 libjson-glib-dev
    # Optional dependencies for the GUI:
RUN apt-get install python3-gi gir1.2-rsvg gir1.2-gtk-3.0 python-cairo gir1.2-polkit-1.0 gir1.2-gtksource-3.0
RUN git clone https://github.com/sahib/rmlint.git
WORKDIR rmlint/
RUN scons config
RUN scons DEBUG=1
    # Install (and build if necessary). For releases you can omit DEBUG=1
RUN sudo scons DEBUG=1 --prefix=/usr install
    rm -rf /var/lib/apt/lists

COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
ADD etc /etc
#COPY menu.xml /etc/xdg/openbox/
#COPY supervisord.conf /etc/
EXPOSE 8080

RUN groupadd --gid 1000 app && \
    useradd --home-dir /data --shell /bin/bash --uid 1000 --gid 1000 app && \
    mkdir -p /data
VOLUME /data

CMD ["sh", "-c", "chown app:app /data /dev/stdout && exec gosu app supervisord"]
