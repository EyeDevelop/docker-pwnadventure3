FROM ubuntu:14.04

# Install prerequisite software.
RUN apt-get update && apt-get install -y bash postgresql

# Environment variables.
ENV PGID 1001
ENV PUID 1001
ENV ADMIN_TEAM_NAME AmazingAdmins
ENV MOTD_SERVER_NAME MyServer
ENV MOTD_TEXT "Welcome to my private server"

# Setup the server files.
COPY PwnAdventure3Server.tar.gz /server.tar.gz
RUN mkdir -p /data &&\
    mkdir -p /server &&\
    tar -C /server -xvf /server.tar.gz

# Setup entrypoint.
COPY entrypoint.sh /
CMD ["/entrypoint.sh"]