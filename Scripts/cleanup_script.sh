nano cleanup_disk_usage.sh

#Directory where dummy files were stored
DISK_DIR="/tmp/dummy_disk_usage"

#Clean up the dummy files
echo "Cleaning up dummy files..."
if [ -d "$DISK_DIR" ]; then
    rm -rf "$DISK_DIR"
    echo "All dummy files removed. Disk space reclaimed."
else
    echo "No dummy files found to clean up."
fi

#exit file
#Make the script executable
chmod +x cleanup_disk_usage.sh

#execute script
./cleanup_disk_usage.sh
