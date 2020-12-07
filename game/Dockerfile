FROM ubuntu:14.04

# Install prerequisite software.
RUN apt-get update && apt-get install -y bash unzip

# Environment variables.
ENV PGID 1001
ENV PUID 1001
ENV MASTER_HOSTNAME master.pwn3
ENV MASTER_PORT 3333
ENV GAME_HOSTNAME game.pwn3
ENV GAME_PORT 3000
ENV GAME_USERNAME replaceme
ENV GAME_PASSWORD replaceme
ENV GAME_INSTANCES ""

# Install the game.
COPY PwnAdventure3_Linux.zip /client.zip
COPY PwnAdventure3Server.tar.gz /server.tar.gz
RUN mkdir -p /data &&\
    mkdir -p /client &&\
    unzip /client.zip -d /client &&\
    rm -rf /client.zip

RUN mkdir -p /tmp/server &&\
    tar -C /tmp/server -xvf /server.tar.gz &&\
    mv /tmp/server/PwnAdventure3Servers/GameServer/PwnAdventure3Server /client/PwnAdventure3/PwnAdventure3/Binaries/Linux/ &&\
    rm -rf /tmp/server &&\
    rm -rf /server.tar.gz

# Entrypoint setup.
COPY entrypoint.sh /
CMD ["/entrypoint.sh"]