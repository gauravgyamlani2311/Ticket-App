Project Directory Structure
Ticket-App/
├── ansible/ (Configuration Management)
│   ├── roles/ (Modular Automation)
│   │   ├── bridge/ (Socat/Network automation logic)
│   │   └── database/ (MySQL configuration & init tasks)
│   ├── inventory.ini (Target server definitions)
│   └── playbook.yml (Main execution entry point)
├── app/ (Application Layer - PHP/Web)
│   ├── config/ (Environment templates e.g., app.env.example)
│   ├── db/ (SQL assets: schema.sql, seed.sql)
│   ├── info.php (Connectivity & health test page)
│   ├── index.html (Main landing page)
│   └── style.css (Application styling)
├── ci/ (Continuous Integration)
│   └── Jenkinsfile (Declarative Build/Deploy logic)
├── docker/ (Containerization)
│   └── Dockerfile (Multi-stage Apache/PHP build)
├── docs/ (Project Documentation & Runbooks)
│   ├── architecture.png (System design diagram)
│   ├── architecture.md (Technical design specs)
│   └── day1-runbook.md (Step-by-step deployment guide)
├── infra/ (Infrastructure as Code - Terraform)
│   ├── main.tf (AWS Resource definitions)
│   └── .terraform/ (Provider binaries)
├── k8s/base/ (Kubernetes Orchestration)
│   ├── deployment.yaml (Pod & ReplicaSet definitions)
│   ├── service.yaml (Internal/External networking)
│   ├── configmap.yaml (Environment variables & DB Credentials)
│   └── ingress.yaml (Layer 7 Routing rules)
├── scripts/ (Operational Maintenance)
│   ├── healthcheck.sh (HTTP status verification)
│   ├── backup_db.sh (SQL dump automation)
│   └── restore_all.sh (Environment reset script)
├── Makefile (CLI shortcuts for builds/deploys)
└── docker-compose.yaml (Local development orchestration)

Project Overview
The Ticket-App is a DevOps-centric project demonstrating the full lifecycle of a web application. It integrates Cloud Infrastructure (AWS), Infrastructure as Code (Terraform), Configuration Management (Ansible), and Container Orchestration (Kubernetes). The primary goal is to showcase a self-healing, automated deployment pipeline that minimizes manual intervention and ensures environment consistency.

Setup Instructions
1. Prerequisites

AWS Account: IAM user with programmatic access and EC2 management permissions.

Control Machine: Local workstation with Terraform, Ansible, and Git installed.

SSH Access: Configured SSH keys for secure communication with AWS instances.

2. Local Initialization

Clone the Repository: Download the project using git clone https://github.com/gauravgyamlani2311/Ticket-App.git.

Infrastructure Provisioning: Navigate to the infra/ folder. Run terraform init followed by terraform apply to create the EC2 instance.

How to Run on AWS EC2
The application is optimized to run on a single t3.medium instance using Minikube for a cost-effective yet powerful Kubernetes demonstration.

Cluster Start: Connect via SSH and run minikube start --driver=docker.

Automation: Execute the Ansible playbook (ansible-playbook -i ansible/inventory.ini ansible/playbook.yml) to configure Docker permissions and networking.

K8s Deployment: Apply the manifests using kubectl apply -f k8s/base/.

Networking: Since Minikube is internal to the EC2, use socat in the background to bridge traffic: nohup socat TCP-LISTEN:8081,fork,reuseaddr TCP:$(minikube ip):30007 &.

Database Init: Manually import the schema into the MySQL pod: kubectl exec -i  -n ticket-app-ns -- mysql -u root -ppassword ticket_db < app/db/schema.sql.

How to Run via Docker
For local development where Kubernetes overhead is not required, use the Docker Compose stack.

Image Construction: Build the local images using docker-compose build.

Stack Launch: Start the environment with docker-compose up -d.

Local Access: View the application at http://localhost:8080.

CI/CD Explanation
The project utilizes a declarative Jenkins Pipeline (located in ci/Jenkinsfile) to manage the software delivery lifecycle.

Continuous Integration: GitHub webhooks trigger the pipeline on every push to the main branch.

Image Sideloading: Instead of pushing to a public registry, the pipeline builds the image on the EC2 host and uses minikube image load to inject it directly into the cluster.

Deployment Policy: The K8s deployment uses imagePullPolicy: IfNotPresent, forcing the cluster to use the newly sideloaded local image.

Automated Validation: The pipeline includes stages for linting and smoke testing before confirming a successful rollout.

Kubernetes Approach
The system architecture follows a microservices pattern designed for high availability within the cluster.

Resource Isolation: All project components (PHP frontend and MySQL backend) are isolated in the ticket-app-ns namespace.

Service Discovery: The PHP app communicates with the database using the internal DNS name db-service, ensuring connectivity even if pod IPs change.

Environment Management: Credentials and database names are managed via ConfigMaps, allowing for easy environment switching (Dev/Prod) without changing application code.

Scripts Usage
A suite of Bash scripts in the scripts/ directory simplifies common operational tasks:

healthcheck.sh: Sends HTTP requests to the public endpoint to verify a 200 OK response.

test_smoke.sh: Execs into the application pod to verify internal connectivity to the database.

backup_db.sh: Performs a mysqldump from the running Kubernetes pod to create timestamped SQL backups.

restore_all.sh: A disaster recovery script that wipes the namespace and redeploys the entire stack.

Known Limitations
Single-Node Cluster: Using Minikube is ideal for cost-savings but lacks the multi-zone redundancy of a full AWS EKS cluster.

Process-Based Bridge: The socat bridge is a background process; in a production environment, an Ingress Controller or AWS Load Balancer would be used for persistence.

Secrets Management: Currently, database passwords are stored in ConfigMaps. Future updates will transition to AWS Secrets Manager for enhanced security.