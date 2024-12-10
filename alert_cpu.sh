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
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:d5:78:82 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 73137sec preferred_lft 73137sec
    inet6 fe80::a00:27ff:fed5:7882/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
osboxes@osboxes:~$ 
