<B>Routine Task Automation</B>

A collection of Shell scripts for automating routine AIX/Linux system administration, infrastructure monitoring, maintenance and operational support activities.

The objective of this repository is to simplify repetitive administration tasks, improve operational efficiency, reduce manual intervention and provide reusable automation scripts for infrastructure support teams.

<B>Repository Overview</B>

This repository contains scripts covering the following areas:

System Monitoring: CPU, memory, disk, filesystem and uptime monitoring.

Process Management: Identification and monitoring of zombie/defunct processes.

Filesystem Management: Filesystem utilisation checks and log cleanup.

Infrastructure Administration: Agent and service management across multiple servers to speed up cluster recovery time

Database Monitoring: CPU, disk and database lock statistics.

Log Management: Cleanup, compression and organisation of system performance logs.

AIX Administration: Platform-specific Unix administration scripts.

<B>Prerequisites</B>

The scripts are primarily intended for Unix/Linux environments.

Depending on the script, the following tools and utilities may be required:

Bash / KornShell (KSH)

Standard Unix utilities: awk, sed, grep, find, ps, df, du

SSH connectivity for remote server administration

Appropriate operating system permissions

Platform-specific utilities such as Veritas commands

Database client utilities where applicable


Some scripts are environment-specific and may require additional configuration before execution.

<B>Getting Started</B>

1. Clone the repository

git clone https://github.com/Kanth81/routine-task.git

cd routine-task

2. Review the script

Before executing any script, review its contents and update environment-specific paths, hostnames, service names and configuration parameters.

cat fs_usage.sh

3. Provide execution permissions

chmod +x fs_usage.sh

4. Execute the script

./fs_usage.sh

For scripts requiring arguments, refer to the script's comments and usage instructions.

5. Execute using the appropriate shell

bash script_name.sh

For KornShell scripts:

ksh script_name.ksh

<B>Operational Considerations</B>

Before using these scripts in production environments:

Review the source code and understand the operations performed.

Validate commands and filesystem paths.

Confirm appropriate user permissions.

Test scripts in a non-production environment.

Ensure appropriate logging and error handling.

Validate remote SSH connectivity where required.

Follow organisational change-management procedures before making production changes.

<B>Future Enhancements<B>

Planned improvements for this repository:

Standardised logging and error handling.

Command-line argument validation.

CI/CD integration using GitHub Actions.

