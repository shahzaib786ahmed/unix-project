#!/bin/bash
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
