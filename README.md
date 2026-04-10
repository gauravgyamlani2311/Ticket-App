1. Project Overview
The Ticket-App is a DevOps-centric project demonstrating the end-to-end integration of Cloud Infrastructure (AWS), Infrastructure as Code (Terraform), Configuration Management (Ansible), and Container Orchestration (Kubernetes). The primary objective is to provide a self-healing, automated deployment pipeline for a professional-grade web application stack.

2. Setup Instructions
Prerequisites
AWS Account with an IAM user possessing Programmatic Access.

Terraform and Ansible installed on the control machine.

SSH client (OpenSSH) for remote instance management.

Local Initialization
Clone the repository to your local workstation: git clone https://github.com/gauravgyamlani2311/Ticket-app.git

Navigate to the project root: cd Ticket-app

Initialize Infrastructure: Navigate to the terraform directory and execute terraform init followed by terraform apply.

3. How to Run on AWS Premises
The application is optimized to run on a single AWS EC2 (t3.medium) instance to balance cost and performance.

SSH Access: Connect to the instance using the public IP provided by the Terraform output.

Cluster Bootstrap: Initialize the environment by running minikube start --driver=docker.

Application Deployment: Deploy the stack using kubectl apply -k k8s/overlays/prod.

Traffic Routing: Establish external access by executing the Socat bridge command to map the internal NodePort (30007) to the public interface.

4. How to Run via Docker
For local development environments where Kubernetes is not required:

Image Construction: Build the local images using docker-compose build.

Stack Execution: Launch the containers with docker-compose up -d.

Endpoint: Access the local development server at http://localhost:8080.

5. CI/CD Explanation
The project utilizes a declarative Jenkins pipeline to automate the software delivery lifecycle.

Trigger Mechanism: A GitHub Webhook detects changes on the main branch and notifies the Jenkins server.

Ansible Integration: The pipeline invokes Ansible roles to handle the "Heavy Lifting"—specifically resetting the network bridge and ensuring the MySQL schema is present.

Automated QA: The build only passes if the health check and smoke test scripts return successful status codes.

6. Kubernetes Approach
The system architecture follows a microservices pattern within Kubernetes:

Resource Isolation: All components reside within the ticket-app-ns namespace.

State Management: MySQL utilizes Persistent Volume Claims (PVC) to ensure data is not lost during pod recreations or updates.

Service Discovery: Internal communication between the PHP frontend and MySQL backend is handled via Kubernetes internal DNS.

7. Scripts Usage
A set of specialized Bash scripts is located in the scripts/ directory for operational maintenance:

healthcheck.sh: Performs an external HTTP probe to verify the 200 OK status.

test_smoke.sh: Executes a connectivity test from the app container to the database.

backup_db.sh: Automates a timestamped SQL dump for data recovery purposes.

restore_all.sh: A disaster recovery script used to reset the environment state.

8. Known Limitations
Single Node Constraint: Running on Minikube lacks the high availability provided by a multi-node EKS cluster.

Persistence Layer: The Socat bridge is a process-level tool and requires manual restart after a host reboot unless converted to a systemd service.

Secrets Management: Credentials are currently managed via environment variables; future iterations will move toward AWS Secrets Manager or Ansible Vault for enhanced security.