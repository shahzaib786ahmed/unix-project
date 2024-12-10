# writenthis in /etc/prometheus/alerts/yml
groups:
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
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s
    scrape_timeout: 5s

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['192.168.2.36:9090']

  - job_name: node
    # If prometheus-node-exporter is installed, grab stats about the local
    # machine by default.
    static_configs:
      - targets: ['localhost:9100']
 - job_name: 'kali-linux'
    static_configs:
      - targets: ['192.168.2.36:9100']
