# Check if user 'nani' exists
if ! id -u nani &>/dev/null; then
    echo "Adding user 'nani'"

    # Add user 'nani' with password '6264' and home directory '/home/nani'
    sudo useradd -m -p $(openssl passwd -1 6264) -d /home/nani nani

    # Set the shell for the user 'nani' to /bin/bash
    sudo usermod -s /bin/bash nani

    # Add 'nani' to sudo group (optional)
    sudo usermod -aG sudo nani

    echo "User 'nani' added successfully."
else
    echo "User 'nani' already exists. Skipping user creation."
fi

# Ensure vagrant and nani users are added to sudoers with NOPASSWD if not already present
if ! grep -q "^vagrant ALL=(ALL) NOPASSWD:ALL" /etc/sudoers; then
    echo "Adding vagrant to sudoers"
    echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
fi

if ! grep -q "^nani ALL=(ALL) NOPASSWD:ALL" /etc/sudoers; then
    echo "Adding nani to sudoers"
    echo "nani ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
fi

# Check if PasswordAuthentication is already enabled in sshd_config
if ! grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config; then
    echo "Enable Password Authentication"
    echo 'PasswordAuthentication yes' | sudo tee -a /etc/ssh/sshd_config > /dev/null
    sudo systemctl restart ssh
else
    echo "Password Authentication already enabled. Skipping."
fi

# Ensure the .ssh directory exists for nani and set correct permissions
mkdir -p /home/nani/.ssh
chown nani:nani /home/nani/.ssh

# Get the hostname dynamically
HOSTNAME=$(hostname)

# Define the file paths
PRIVATE_KEY="/home/nani/.ssh/id_ed25519_${HOSTNAME}"
PUBLIC_KEY="${PRIVATE_KEY}.pub"
TARGET_DIR="/vagrant/ssh_keys"
AUTHORIZED_KEYS="/home/nani/.ssh/authorized_keys"

# Debugging output
echo "DEBUG: TARGET_DIR is set to: $TARGET_DIR"
echo "DEBUG: AUTHORIZED_KEYS is set to: $AUTHORIZED_KEYS"

# Generate the ED25519 key pair with the dynamic hostname in the comment, if not already generated
if [ ! -f "$PUBLIC_KEY" ]; then
    ssh-keygen -t ed25519 -C "${HOSTNAME}" -f "$PRIVATE_KEY" -N "" -q

    # Check if key generation was successful
    if [ $? -ne 0 ]; then
        echo "$HOSTNAME: Failed to generate SSH key pair."
        exit 1
    fi

    # Change ownership of the SSH key files to nani
    chown nani:nani "$PRIVATE_KEY" "$PUBLIC_KEY"
    
    # Create the ssh_keys directory at the TARGET_DIR and copy the public key there
    mkdir -p "$TARGET_DIR"
    cp "$PUBLIC_KEY" "$TARGET_DIR"
    echo "$HOSTNAME: SSH public key generated and copied to $TARGET_DIR."
fi

# Append all .pub files from TARGET_DIR to authorized_keys
for pubkey in "$TARGET_DIR"/*.pub; do
    cat "$pubkey" >> "$AUTHORIZED_KEYS"
    echo "Appended $pubkey to $AUTHORIZED_KEYS."
done

# Set ownership of authorized_keys to nani
chown nani:nani "$AUTHORIZED_KEYS"

echo "SSH public keys appended to /home/nani/.ssh/authorized_keys."
