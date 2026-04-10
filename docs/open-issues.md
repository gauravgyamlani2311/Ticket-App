# Open Issues & Future Roadmap

## 1. High Priority (Bugs)
* **Socat Process Resilience:** Currently, if the EC2 reboots, the Socat bridge does not start automatically.
    * *Proposed Fix:* Create a systemd service for the Socat bridge.
* **Jenkins User Permissions:** Jenkins occasionally loses access to the Docker socket after instance updates.
    * *Proposed Fix:* Ensure `usermod` commands are part of the Terraform User Data.

## 2. Technical Debt
* **Hardcoded Credentials:** Database passwords in Ansible roles are currently in plain text.
    * *Proposed Fix:* Implement **Ansible Vault** to encrypt sensitive variables.
* **Manual Port Management:** Port 30007 is hardcoded across scripts and Ansible.
    * *Proposed Fix:* Use environment variables in the Jenkinsfile to define ports.

## 3. Future Enhancements (Roadmap)
* **Monitoring & Alerting:** Integrate Prometheus and Grafana to monitor Pod CPU and Memory usage.
* **SSL/TLS Implementation:** Move from HTTP to HTTPS using Certbot and an Nginx Ingress Controller.
* **Multi-Node Scaling:** Move from Minikube to a production-grade EKS (Elastic Kubernetes Service) cluster.

## 4. Resolved Issues (Log)
* [Fixed] Database pod not found error in backup script (Updated to `app=ticket-db` label).
* [Fixed] Jenkins build failures due to Git local/remote conflicts (Implemented `git stash` in runbook).