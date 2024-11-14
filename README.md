Course: Unix (420-321-VA) – Fall 2024 
Teacher: Tassia Camoes Araujo 
Team Composition: Jkini Manal, Dania Iriqat, Shahzaib Ahmad
License: CC0
Project Proposal: System Monitoring Server in a Local Network Simulated with VMs
1. Project Description/Goals 
Our goal is to set up a system monitoring server in a simulated local network using virtual machines. This server will track key metrics like CPU, memory, disk space, and network activity, alerting us when resources exceed set limits. It will act as a practical tool for managing network resources and simulating real sysadmin tasks.
2. Platform of Choice
The platform chosen for this project is a virtualized Linux server environment. We will use virtual machines (VMs) to simulate a local network and install a GNU/Linux distribution suitable for monitoring.
3. Demonstration Plan
For our demonstration, we plan to use VMs on a laptop. The VMs will run on VirtualBox, an embedded hypervisor that allows easy network configuration to simulate a local network environment.
 
4. Requirements
Basic system setup and security:
We will create necessary user accounts for managing the system and set up SSH access for remote configuration and monitoring. We’ll also configure file permissions to restrict access and set up a firewall for basic security.
Process or service management/scheduling:
Using the system simplifies managing and scheduling monitoring tasks like alerts and logging. Journalctl provides easy log access for quick troubleshooting. This ensures monitoring tools stay active, keeping the system running smoothly and sending alerts when needed.
Automated tasks using a script language:
We will create shell scripts to automate system checks like CPU, memory, and disk, log rotation, and alert notifications. The script will monitor resource usage, trigger alerts when thresholds are exceeded, and manage logs by either compressing, storing, or deleting old files.
5. Major Technical Solutions Compared 
Nagios: Shahzaib
Nagios offers strong community support and is highly customizable, making it effective for small networks. However, it has a complex setup process, especially when scaling to larger networks. It's best suited for small setups with basic monitoring needs but may not be ideal for more complex configurations or large-scale systems.
Zabbix: Dania
Zabbix excels with advanced data visualization and great scalability, making it a good choice for growing systems. It is open-source and flexible, but the setup can be hard, particularly for larger environments. It's best suited for projects that require detailed monitoring, complex visualizations, and scalability as they grow.
Prometheus: Manal
Prometheus is known for its efficient storage and customizable data retrieval, making it a powerful tool for monitoring. It also has built-in alerting capabilities. However, the user interface is basic, and long-term storage requires additional setup. 
Ubuntu Server: Offers newer packages by default, including monitoring tools like Nagios and Zabbix, making setup easier. It has frequent updates and extensive documentation, which supports easier troubleshooting but is considered less stable than Debian for critical, long-term use.
Debian: Known for stability and low resource usage, it uses older, well-tested packages ideal for reliable server environments. While its community and documentation are strong, setup may require more experience than Ubuntu Server.
We will also choose Debian packages since they are advantageous due to their stability, security, and the ease of integration with system management tools.
6.Timeline
Week 1: 
Complete research and install VMs with Ubuntu  and Debian. Do initial setup, we’re going to find different monitoring tools and each one of us is going to explore one.
Week 2: 
Write basic scripts for automated monitoring tasks. We are going to find the best monitoring tool to work on individually.
Week 3:
Finally,we are going to do the requirements: Basic System Setup and Security,Process or Service Management/Scheduling and  Automated Tasks using a Script Language. We’re also going to do user account configuration and basic security.
