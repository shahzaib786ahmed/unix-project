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
