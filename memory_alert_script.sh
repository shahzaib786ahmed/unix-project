sudo nano /etc/prometheus/alerts.yml
#input this:
rule_files:
- "alerts.yml"
groups:
  - name: memory_alerts
    rules:
      - alert: HighMemoryUsage
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_Memtotal_bytes * 100 > 90
        for: 5m
        labels:
          severity: critical
        annotations:
         summary: "High Memory Usage on {{ $labels.instance }}"
        description: "Memory usage on instance {{ $labels.instance }} is above 90% for the last 5 minutes."
#exit file
