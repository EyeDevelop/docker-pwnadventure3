#!/bin/bash

# Create a user for permissions if none created yet.
if ! grep "pwn3" /etc/passwd > /dev/null; then
    echo "[!] No user found. Creating one..."
    groupadd -g "$PGID" pwn3
    useradd -M -g "$PGID" -u "$PUID" pwn3

    # Setup permissions.
    chown pwn3:pwn3 -R /client
    chown pwn3:pwn3 -R /data
fi

if [[ -f /data/master/game_creds.txt ]]; then
    echo "[+] Found credentials for master server!"
    GAME_USERNAME=$(cat /data/master/game_creds.txt | grep Username | cut -d ' ' -f 2)
    GAME_PASSWORD=$(cat /data/master/game_creds.txt | grep Password | cut -d ' ' -f 2)
fi

# Populate the config with the required data.
if [[ ! -f /.setup_done ]]; then
    cat << EOF > /client/PwnAdventure3/PwnAdventure3/Content/Server/server.ini
[MasterServer]
Hostname=$MASTER_HOSTNAME
Port=$MASTER_PORT

[GameServer]
Hostname=$GAME_HOSTNAME
Port=$GAME_PORT
Username=$GAME_USERNAME
Password=$GAME_PASSWORD
EOF

    # Only add instances if specified.
    [[ -n "$GAME_INSTANCES" ]] && echo "Instances=$GAME_INSTANCES" >> /client/PwnAdventure3/PwnAdventure3/Content/Server/server.ini

    # Setup is done.
    touch /.setup_done
fi

# Start the server.
echo "[+] Starting server..."
su pwn3 -c "cd /client/PwnAdventure3/PwnAdventure3/Binaries/Linux/ && ./PwnAdventure3Server 2> /dev/null"