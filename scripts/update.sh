# Update system
echo "Update system"
sudo apt update
sudo apt upgrade -y
echo "System update completed"

# Set timzone to Kolkata
echo "Set timzone to Kolkata"
sudo timedatectl set-timezone Asia/Kolkata
echo "timzone has been set to Kolkata"

# Define the entries to add to /etc/sysctl.conf
SYSCTL_ENTRIES="net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1"

# Check if any of the entries are missing in /etc/sysctl.conf
if ! grep -qF "$SYSCTL_ENTRIES" /etc/sysctl.conf; then

    # Append the entries to /etc/sysctl.conf
    echo "$SYSCTL_ENTRIES" | sudo tee -a /etc/sysctl.conf > /dev/null

    # Apply the changes
    sudo sysctl -p
else
    echo "IPv6 already disabled in /etc/sysctl.conf. Skipping."
fi