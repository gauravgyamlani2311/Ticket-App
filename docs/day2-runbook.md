Subject: Automated Operations and Incident Response

Project: Ticket-App Maintenance

Automation Engine: Ansible

1. CONFIGURATION MANAGEMENT (ANSIBLE)
To eliminate manual intervention and configuration drift, Ansible roles are utilized for environment self-healing.

Role: Bridge Management This role handles network recovery. It identifies and terminates conflicting Socat processes (addressing Status 000 errors) and re-establishes the connection tunnel.

Role: Database Provisioning This role manages the state of the MySQL instance. It dynamically discovers the database pod name using label selectors and executes SQL schema commands to ensure table structures are intact.

2. CONTINUOUS INTEGRATION WORKFLOW
The project adheres to a GitOps methodology managed through Jenkins.

Pipeline Stages: 1. Source Code Management: Pulls updated PHP code and Ansible playbooks from the repository.

2. Infrastructure Sync: Executes Ansible tasks to refresh the network bridge and database schema.

3. Automated Validation: Runs health check and smoke test scripts to verify 200 OK status and database connectivity.

3. DATA PERSISTENCE AND BACKUP PROCEDURES
Backups are critical for disaster recovery and are stored locally on the EC2 host under the backups directory.

Database Backup: The backup script utilizes a dynamic selector (app=ticket-db) to ensure it targets the active pod regardless of the pod's unique hash suffix. This prevents script failure during pod redeployments.

4. INCIDENT RESPONSE MATRIX
Network Timeout (Status 000): Trigger the Ansible bridge role. Verify the EC2 security group allows traffic on port 30007.

Database Error (Table Not Found): Trigger the Ansible database role to re-apply the schema. Verify that the MySQL pod is in a "Running" state.

Permission Denied: Ensure the execution bit is set on all maintenance scripts and that the Jenkins user is a member of the Docker and Sudo groups.

5. COMMAND REFERENCE
Log Inspection: Use kubectl logs with label selectors to monitor application behavior in real-time.

Process Audit: Utilize "ps aux" or "lsof" to verify that the Socat bridge is active and bound to the correct port.