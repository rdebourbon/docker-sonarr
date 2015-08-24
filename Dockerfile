FROM rdebourbon/docker-base:latest
MAINTAINER rdebourbon@xpandata.net

# add our user and group first to make sure their IDs get assigned regardless of what other dependencies may get added.
RUN groupadd -r librarian && useradd -r -g librarian librarian

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
    echo "deb http://apt.sonarr.tv/ master main" | tee -a /etc/apt/sources.list && \
    apt-get update -q && \
    apt-get install -qy nzbdrone mediainfo && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/tmp/* && \
    rm -rf /tmp/* 

RUN mkdir -p /volumes/config && \
    mkdir -p /volumes/media && \
    chown -R librarian:librarian /volumes && \
    chown -R librarian:librarian /opt/NzbDrone

VOLUME ["/volumes/config","/volumes/media"]

EXPOSE 8989 9898

ADD develop/start.sh /
RUN chmod +x /start.sh

ADD develop/sonarr-update.sh /sonarr-update.sh
RUN chmod 755 /sonarr-update.sh \
  && chown librarian:librarian /sonarr-update.sh

USER librarian

WORKDIR /opt/NzbDrone

ENTRYPOINT ["/start.sh"]
