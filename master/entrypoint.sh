#!/bin/bash

# Create a user for permissions if none created yet.
if ! grep "pwn3" /etc/passwd > /dev/null; then
    echo "[!] No user found. Creating one..."
    groupadd -g "$PGID" pwn3
    useradd -M -g "$PGID" -u "$PUID" pwn3

    # Setup permissions.
    chown pwn3:pwn3 -R /server
    chown pwn3:pwn3 -R /data
fi

# Start postgresql.
service postgresql start

# Wait until the database is up
sleep 5

# Setup.
if [[ ! -f /.setup_done ]]; then
    su pwn3 -c "mkdir -p /data/master"

    su postgres -c "createuser pwn3 && createdb -O pwn3 master"
    echo "[+] Preparing database..."
    su pwn3 -c "psql master -f /server/PwnAdventure3Servers/MasterServer/initdb.sql > /dev/null"

    # Setup the game server account.
    echo "[+] Creating account for game servers..."
    su pwn3 -c "/server/PwnAdventure3Servers/MasterServer/MasterServer --create-server-account" > /data/master/game_creds.txt

    # Setup the admin account.
    echo "[+] Creating admin account..."
    su pwn3 -c "/server/PwnAdventure3Servers/MasterServer/MasterServer --create-admin-team $ADMIN_TEAM_NAME" > /data/master/admin_creds.txt

    # Set MOTD.
    echo "[+] Setting MOTD..."
    cat << EOF > /server/PwnAdventure3Servers/MasterServer/update_motd.sql
UPDATE info SET contents='$MOTD_SERVER_NAME' WHERE name='login_title';
UPDATE info SET contents='$MOTD_TEXT' WHERE name='login_text';
EOF
    su pwn3 -c "psql master -f /server/PwnAdventure3Servers/MasterServer/update_motd.sql > /dev/null"

    # Setup is done.
    touch /.setup_done
fi

# Run the master server.
echo "[+] Starting server..."
su pwn3 -c "cd /server/PwnAdventure3Servers/MasterServer/ && ./MasterServer"