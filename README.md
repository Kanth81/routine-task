# Routine Task Automation

A collection of Shell scripts for automating routine Unix/Linux system administration, infrastructure monitoring, maintenance and operational support activities.

The objective of this repository is to simplify repetitive administration tasks, improve operational efficiency, reduce manual intervention and provide reusable automation scripts for infrastructure support teams.

## Repository Overview

This repository contains scripts covering the following areas:

- **System Monitoring:** CPU, memory, disk, filesystem and uptime monitoring.
- **Process Management:** Identification and monitoring of zombie/defunct processes.
- **Filesystem Management:** Filesystem utilisation checks and log cleanup.
- **Infrastructure Administration:** Agent and service management across multiple servers.
- **Database Monitoring:** CPU, disk and database lock statistics.
- **Log Management:** Cleanup, compression and organisation of system performance logs.
- **AIX Administration:** Platform-specific Unix administration scripts.
- **Operational Automation:** Support utilities for routine infrastructure operations.

## Repository Structure

```text
routine-task/
│
├── AIX/
│   └── AIX-specific administration scripts
│
├── Sos_Report_Upload.sh
│   └── SOS report upload utility
│
├── Var_cleanup.sh
│   └── /var filesystem and SAR log cleanup
│
├── agent_check.sh
│   └── Start, stop and validate infrastructure agents
│
├── cpu_disk_db_locks_stats.sh
│   └── CPU, disk and database lock statistics
│
├── dime3-monitor.sh
│   └── DIME3 monitoring utility
│
├── fs_usage.sh
│   └── Filesystem utilisation monitoring
│
├── uptime.sh
│   └── Server uptime monitoring
│
├── zombie_defunct.sh
│   └── Zombie and defunct process identification
│
└── README.md
    └── Repository documentation
```

## Script Inventory

| Script | Description |
|---|---|
| `Sos_Report_Upload.sh` | Utility for uploading SOS diagnostic reports |
| `Var_cleanup.sh` | Compresses and organises older SAR performance logs |
| `agent_check.sh` | Manages and validates infrastructure agents and services across multiple nodes |
| `cpu_disk_db_locks_stats.sh` | Collects CPU, disk and database lock statistics |
| `dime3-monitor.sh` | DIME3 environment monitoring utility |
| `fs_usage.sh` | Checks filesystem utilisation |
| `uptime.sh` | Retrieves server uptime information |
| `zombie_defunct.sh` | Identifies zombie and defunct processes |
| `AIX/` | Contains AIX-specific administration scripts |

## Prerequisites

The scripts are primarily intended for Unix/Linux environments.

Depending on the script, the following tools and utilities may be required:

- Bash / KornShell (KSH)
- Standard Unix utilities: `awk`, `sed`, `grep`, `find`, `ps`, `df`, `du`
- SSH connectivity for remote server administration
- Appropriate operating system permissions
- Platform-specific utilities such as Veritas commands
- Database client utilities where applicable

Some scripts are environment-specific and may require additional configuration before execution.

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/Kanth81/routine-task.git

cd routine-task
```

### 2. Review the script

Before executing any script, review its contents and update environment-specific paths, hostnames, service names and configuration parameters.

```bash
cat fs_usage.sh
```

### 3. Provide execution permissions

```bash
chmod +x fs_usage.sh
```

### 4. Execute the script

```bash
./fs_usage.sh
```

For scripts requiring arguments, refer to the script's comments and usage instructions.

### 5. Execute using the appropriate shell

```bash
bash script_name.sh
```

For KornShell scripts:

```bash
ksh script_name.ksh
```

## Operational Considerations

Before using these scripts in production environments:

1. Review the source code and understand the operations performed.
2. Validate commands and filesystem paths.
3. Confirm appropriate user permissions.
4. Test scripts in a non-production environment.
5. Ensure appropriate logging and error handling.
6. Validate remote SSH connectivity where required.
7. Follow organisational change-management procedures before making production changes.

**Important:** Some scripts perform administrative operations such as starting/stopping services, compressing files or moving logs. Always review the impact before executing them on production servers.

## Future Enhancements

Planned improvements for this repository:

- Standardised logging and error handling.
- Command-line argument validation.
- Email and notification-based alerting.
- Improved monitoring and threshold-based alerts.
- Python-based infrastructure automation.
- Ansible integration for configuration management.
- Improved portability across Linux and AIX.
- ShellCheck validation and automated testing.
- CI/CD integration using GitHub Actions.

## Technology Stack

- Shell Scripting (Bash / KSH)
- Unix / Linux / AIX
- SSH
- AWK / SED / GREP
- Infrastructure Monitoring
- System Administration
- Automation and Operational Support

## Author

**Lakshmikanth**

GitHub: [Kanth81](https://github.com/Kanth81)

---

*This repository is intended as a practical collection of reusable system administration and infrastructure automation utilities. Contributions, improvements and suggestions are welcome.*
