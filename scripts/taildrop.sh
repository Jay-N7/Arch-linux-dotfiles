#!/bin/bash

# Taildrop helper script

echo "Do you want to send (s) or receive (r) a file? (s/r)"
read action

if [[ "$action" == "s" || "$action" == "S" ]]; then
    # Sending a file
    read -p "Enter the full path of the file to send: " file_path
    read -p "Enter the device name to send to: " device_name
    
    # Run the tailscale send command
    echo "Sending $file_path to $device_name..."
    tailscale file cp "$file_path" "$device_name:"
    
    if [[ $? -eq 0 ]]; then
        echo "File sent successfully!"
    else
        echo "Failed to send the file."
    fi

elif [[ "$action" == "r" || "$action" == "R" ]]; then
    
    echo "Receiving file..."
    sudo tailscale file get /home/archer/Downloads/taildrop/
    
else
    echo "Invalid option. Please enter 's' to send or 'r' to receive."
fi
