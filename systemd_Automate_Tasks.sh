# create systemd file for the disk usage 
sudo nano /etc/systemd/system/simulate_disk_usage.service
# add the followinf lines
[Unit]
Description=Simulate Disk Usage
After=network.target

[Service]
ExecStart=put the path to /simulate_disk_usage.sh/
Restart=on-failure

[Install]
WantedBy=multi-user.target
#exit the file 

# create systemd file for the disk cleanup
sudo nano /etc/systemd/system/cleanup_disk_usage.service
# add the following lines
[Unit]
Description=Cleanup Simulated Disk Usage
After=simulate_disk_usage.service

[Service]
ExecStart=put the path to/cleanup_disk_usage.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
#exit file

#create systemd file for securuty check
sudo nano /etc/systemd/system/security_check.service
#add the following lines 
[Unit]
Description=Perform Security Checks
After=network.target

[Service]
ExecStart=put the path to /security_check.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
#exit file 
#create systemd for cpu monitoring
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
#exit the file
# reload systemd to recognize the created files
sudo systemctl daemon-reload
#enable them so that they start running when you open the machine
sudo systemctl enable simulate_disk_usage.service
sudo systemctl enable cleanup_disk_usage.service
sudo systemctl enable security_check.service
sudo systemctl enable cpu_monitor.service

#if you want to make sure that everything is good do the following lines 
sudo systemctl start simulate_disk_usage.service
sudo systemctl start cleanup_disk_usage.service
sudo systemctl start security_check.service
sudo systemctl start cpu_monitor.service
#and do this to check if they're running
sudo systemctl status simulate_disk_usage.service
sudo systemctl status cleanup_disk_usage.service
sudo systemctl status security_check.service
sudo systemctl status cpu_monitor.service
