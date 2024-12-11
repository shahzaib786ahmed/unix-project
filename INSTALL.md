# Install debian and kali linux and set the vms
1. https://www.osboxes.org/debian/ 
2. https://www.techspot.com/downloads/6738-kali-linux.html
# Installing Prometheus
1. sudo apt update 
2. sudo apt install prometheus prometheus-node-exporter
3. sudo nano /etc/prometheus/prometheus.yml
you canconfigure change the configuration if needes.
4. sudo systemctl status prometheus
5. Check your ip address with: ip a
6. Go to browser and type your ipaddress:9090 to access prometheus

# Connecting Kali linux vm to Prometheus 
1. When kalilinus is turned-off go to setting > networks and select Bridged Adapter for attached to so that the vm will have a different ip than the Debian one.
2. Open terminal in kali linux and check its ip address with:
ip a
3. Install node explorer in kalilinux:
sudo apt-get install prometheus-node-exporter
4. Start it
sudo systemctl start prometheus-node-exporter
5. Enable it at boot time
sudo systemctl enable prometheus-node-exporter
6. Check status
sudo systemctl status prometheus-node-exporter
7. Go to debian vm terminal and change the Prometheus.yml:
 sudo nano /etc/prometheus/prometheus.yml 
 your scrape congig should look like thsi:
scrape_configs:
  - job_name: 'prometheus'

    scrape_interval: 5s
    scrape_timeout: 5s

    static_configs:
      - targets: ['localhost:9090']

  - job_name: node
    
    static_configs:
      - targets: ['localhost:9100']
  - job_name: 'kali-linux'
    static_configs:
      - targets: ['192.168.2.36:9100']

 8. put the ip of your machine kali linux vm in targets of kali linux, mine is 192.168.2.36
 9. Exit file and restart prometheus to apply changes
sudo systemctl restart prometheus

# Writting alerts for Cpu and Memory
1. With sudo nano /etc/prometheus/alerts.yml write this: 

groups:
  - name: memory_alerts
    rules:
      - alert: HighMemoryUsage
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100 > 90
        for: 5m
        labels:
          severity: critical
        annotations:
         summary: "High Memory Usage on {{ $labels.instance }}"
         description: "Memory usage on instance {{ $labels.instance }} is above 90% for the last 5 minutes."

  - name: cpu_alerts
    rules:
      - alert: HighCPUUsage
        expr: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[1m]))) > 80
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High CPU Usage on {{ $labels.instance }}"
          description: "CPU usage on instance {{ $labels.instance }} has been over 80% for the last 10 minutes."
# Go to prometheus.yml and add alerts to it so that you can have it on prometheus
sudo nano /etc/prometheus/prometheus.yml
1. add this 
rule_files:
    - "/etc/prometheus/alerts.yml"
2. the file should look like this:

global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
      monitor: 'example'

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets: ['localhost:9093']

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
- "/etc/prometheus/alerts.yml"
  # - "second_rules.yml"
# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s
    scrape_timeout: 5s

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:9090']

  - job_name: node
    # If prometheus-node-exporter is installed, grab stats about the local
    # machine by default.
    static_configs:
      - targets: ['localhost:9100']
  - job_name: 'kali-linux'
    static_configs:
      - targets: ['192.168.2.36:9100']
      
3. Exit file and then validate the alert with: 
promtool check rules /etc/prometheus/alerts.yml
4. Restart prometheus to apply changes
sudo systemctl restart prometheus

# Go to prometheus Website and select graph and add this expressions to check your metrics: 
rate(node_cpu_seconds_total{mode="idle", instance="192.168.2.36:9100"}[1m])

rate(node_cpu_seconds_tota[1m])

node_memory_MemTotal_bytes-node_memory_MemAvailable_bytes

node_filesystem_size_bytes{device="/dev/sda1"}-node_filesystem_free_bytes{device="/dev/sda1"}
1. Change this 192.168.2.36 to your kali linux ip address

# Create scripts that will use the metrics
1. For simulating disk usage do this:
nano simulate_disk_usage.sh

DISK_DIR="/tmp/dummy_disk_usage"
FILE_SIZE_MB=2  
TOTAL_FILES=15  
DELAY=2  
mkdir -p "$DISK_DIR"
echo "Starting disk usage simulation..."
for i in $(seq 1 $TOTAL_FILES); do
    FILE_PATH="$DISK_DIR/dummy_file_$i"
    echo "Creating file: $FILE_PATH ($FILE_SIZE_MB MB)"
    dd if=/dev/zero of="$FILE_PATH" bs=1M count=$FILE_SIZE_MB status=none
    echo "Disk usage increased. File $i of $TOTAL_FILES created."
    sleep $DELAY
done
2. Exit file and make the script executable and run it to test it:
chmod +x simulate_disk_usage.sh
./simulate_disk_usage.sh

3. Write a script for CPU usage alerts:
nano cpu_monitor.sh

THRESHOLD=80
CHECK_INTERVAL=60  # Check every minute
ALERT_TIME=600     # 10 minutes

CPU_HISTORY_FILE="/tmp/cpu_usage_history.txt"

get_cpu_usage() {

  cpu_usage=$(mpstat 1 1 | awk '/Average/ {print 100 - $12}')
  echo $cpu_usage
}

log_cpu_usage() {
  local cpu_usage=$1
  echo "$(date +%s),$cpu_usage" >> $CPU_HISTORY_FILE
}

check_high_cpu_usage() {
  local count=0
  local total_time=0
  current_time=$(date +%s)

  while IFS=, read -r timestamp usage; do
    # Calculate time difference
    time_diff=$((current_time - timestamp))

    # Only consider logs within the ALERT_TIME window
    if [[ $time_diff -le $ALERT_TIME ]]; then
      if (( $(echo "$usage > $THRESHOLD" | bc -l) )); then
        ((count++))
      fi
    fi
  done < $CPU_HISTORY_FILE

  if ((count >= ALERT_TIME / CHECK_INTERVAL)); then
    echo "ALERT: CPU usage has been over $THRESHOLD% for the past 10 minutes."
  fi
}

while true; do

  cpu_usage=$(get_cpu_usage)

  log_cpu_usage $cpu_usage

   check_high_cpu_usage

  sleep $CHECK_INTERVAL
done

4. Exit file and in order to analize cpu you should install this package: 
sudo apt-get install sysstat
6. Make it executable and run it
chmod +x cpu_monitor.sh
./cpu_monitor.sh

5. Write script to clean the fake file used to simulate disk usage

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

6. Exit file and make it executable and run it
chmod +x cleanup_disk_usage.sh
./cleanup_disk_usage.sh
7. Write script for security check
nano security_check.sh

LOG_FILE="/var/log/security_check.log"

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] Checking for failed SSH login attemps..." >> $LOG_FILE
grep "FAILED password" /var/log/auth.log | tail -n 5 >> $LOG_FILE

echo "[$TIMESTAMP] Checking for available security updates..." >> $LOG_F>
UPDATES=$(apt list --upgradable 2>/dev/null | grep -i security)
if [ -z "$UPDATES" ]; then
        echo "No security updates available ." >> $LOG_FILE
else
        echo "Security update available:" >> $LOG_FILE
        echo "$UPDATES" >> $LOG_FILE
fi

echo "[$TIMESTAMP] Verifying critcal services are running..." >> $LOG_FI>
SERVICES=("ssh" "ufw")
for SERVICE in "${SERVICES[@]}"; do
        systemctl is-active --quiet $SERVICE
        if [ $? -eq 0 ]; then
                echo "Service $SERVICE is running." >> $LOG_FILE
        else
                echo "ALERT: Service $SERVICE is NOT running!" >> $LOG_F>
        fi
done

echo "[$TIMESTAMP] Checking for recent file change in /etc..." >> $LOG_F>
find /etc -type f -mtime -1 >> $LOG_FILE

echo  "[$TIMESTAMP] Checking disk space usage..." >> $LOG_FILE
df -h / >> $LOG_FILE

echo "[$TIMESTAMP] Security check completed." >> $LOG_FILE
8. Exit file and make it executable and run it
chmod +x security_check.sh
./security_check.sh

# Write automated tasks of those scripts with systemd

1. Create systemd file for the disk usage 
sudo nano /etc/systemd/system/simulate_disk_usage.service

[Unit]
Description=Simulate Disk Usage
After=network.target

[Service]
ExecStart=put the path to /simulate_disk_usage.sh/
Restart=on-failure

[Install]
WantedBy=multi-user.target


2. Create systemd file for the disk cleanup
sudo nano /etc/systemd/system/cleanup_disk_usage.service

[Unit]
Description=Cleanup Simulated Disk Usage
After=simulate_disk_usage.service

[Service]
ExecStart=put the path to/cleanup_disk_usage.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target


3. Create systemd file for securuty check
sudo nano /etc/systemd/system/security_check.service

[Unit]
Description=Perform Security Checks
After=network.target

[Service]
ExecStart=put the path to /security_check.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target

4. Create systemd for cpu monitoring
sudo nano /etc/systemd/system/cpu_usage_alert.service
#add the folowing lines
[Unit]
Description=CPU Monitoring Service
After=network.target

[Service]
ExecStart=/usr/local/bin/cpu_monitor.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target

# Reload systemd to recognize the created files
sudo systemctl daemon-reload
# Enable them so that they start running when you open the machine
sudo systemctl enable simulate_disk_usage.service
sudo systemctl enable cleanup_disk_usage.service
sudo systemctl enable security_check.service
sudo systemctl enable cpu_monitor.service

# If you want to make sure that everything is good do the following lines 
sudo systemctl start simulate_disk_usage.service
sudo systemctl start cleanup_disk_usage.service
sudo systemctl start security_check.service
sudo systemctl start cpu_monitor.service
# Do this to check if they're running
sudo systemctl status simulate_disk_usage.service
sudo systemctl status cleanup_disk_usage.service
sudo systemctl status security_check.service
sudo systemctl status cpu_monitor.service

