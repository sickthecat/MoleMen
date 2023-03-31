#!/bin/bash

# Set the SSH server information
SSH_SERVER="ssh.server.com"
SSH_USERNAME="username"
SSH_KEYFILE="/path/to/private/key"

# Set the local and remote port numbers
LOCAL_PORT=8888
REMOTE_PORT=80

# Define the function to start the SSH tunnel
start_tunnel() {
  echo "Starting SSH tunnel..."
  ssh -i $SSH_KEYFILE -N -L $LOCAL_PORT:localhost:$REMOTE_PORT $SSH_USERNAME@$SSH_SERVER &
  PID=$!
  echo "SSH tunnel started with PID $PID"
}

# Define the function to stop the SSH tunnel
stop_tunnel() {
  echo "Stopping SSH tunnel..."
  kill $PID
  echo "SSH tunnel stopped"
}

# Check if the SSH tunnel is already running
if pgrep -f "ssh -i $SSH_KEYFILE -N -L $LOCAL_PORT:localhost:$REMOTE_PORT $SSH_USERNAME@$SSH_SERVER" > /dev/null
then
  echo "SSH tunnel is already running"
else
  start_tunnel
fi

# Check if the -b option was passed to run the script in the background
if [ "$1" = "-b" ]
then
  echo "Running script in the background"
  exit 0
fi

# Wait for user input to stop the tunnel
echo "Press any key to stop the SSH tunnel"
read -n 1 -s
stop_tunnel
