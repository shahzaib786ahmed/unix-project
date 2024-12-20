nano simulate_disk_usage.sh

# Directory to store files
DISK_DIR="/tmp/dummy_disk_usage"

# Size of each file 
FILE_SIZE_MB=2  

# Total number of files to create (one at a time)
TOTAL_FILES=15  

# Delay between file creations (in seconds)
DELAY=2  

# Ensure the  directory exists
mkdir -p "$DISK_DIR"

# Simulate disk usage growth
echo "Starting disk usage simulation..."
for i in $(seq 1 $TOTAL_FILES); do
    FILE_PATH="$DISK_DIR/dummy_file_$i"
    echo "Creating file: $FILE_PATH ($FILE_SIZE_MB MB)"
    dd if=/dev/zero of="$FILE_PATH" bs=1M count=$FILE_SIZE_MB status=none
    echo "Disk usage increased. File $i of $TOTAL_FILES created."
    sleep $DELAY
done
#exit file

# Make the script executable
chmod +x simulate_disk_usage.sh

# run file
./simulate_disk_usage.sh
