# DevOps-Ready Web Application

## Project Overview

This project demonstrates a complete DevOps workflow for deploying and managing a PHP-based web application with a MySQL backend on AWS infrastructure. It includes application development, containerization, CI/CD pipeline design, Kubernetes deployment, infrastructure-as-code, and operational scripting.

The application provides a simple website with multiple pages (Home, About, Contact) and supports form submission with persistent storage in a MySQL database.

---

## Repository Structure

app/        → Application source (HTML, PHP, DB config, SQL)

docker/     → Dockerfile and Docker Compose setup

ci/         → Jenkins pipeline definition

k8s/        → Kubernetes manifests (base setup)

infra/      → Terraform and Ansible configuration (AWS provisioning)

scripts/    → Operational scripts (backup, restore, healthcheck, etc.)

docs/       → Runbooks, architecture, validation

logs/       → Runtime logs

Makefile    → Command automation

README.md   → Project documentation

---

## Setup Instructions

### Prerequisites

* AWS Account (IAM user with EC2 permissions)
* Terraform
* Ansible
* Docker
* Kubernetes (Minikube)
* kubectl
* Jenkins (optional)
* Make
* SSH key configured for EC2

---

### Clone Repository

git clone <repo-url>
cd Ticket-App

---

## How to Run on AWS (EC2)

### Provision Infrastructure

cd infra
terraform init
terraform apply

This creates EC2 instance and networking components.

---

### Connect to EC2

ssh -i your-key.pem ubuntu@<EC2-PUBLIC-IP>

---

### Configure Environment (Ansible)

ansible-playbook -i ansible/inventory.ini ansible/playbook.yml

---

### Start Kubernetes Cluster

minikube start --driver=docker

---

### Deploy Application

kubectl apply -f k8s/base/

---

## How to Run via Docker (Manual Build)

eval $(minikube docker-env)
docker build -t ticket-app:latest -f docker/Dockerfile .

---

## Kubernetes Deployment

### Apply Manifests

kubectl apply -f k8s/base/

### Verify

kubectl get pods -n ticket-app-ns
kubectl get svc -n ticket-app-ns

---

## Access Application (AWS Setup)

nohup socat TCP-LISTEN:8081,fork,reuseaddr TCP:$(minikube ip):30007 &

Access in browser:
http://<EC2-PUBLIC-IP>:8081

---

## CI/CD Pipeline (Jenkins)

Pipeline stages:

* Checkout code
* Validation / linting
* Application build
* Docker image build
* Smoke testing
* Deployment (Kubernetes)

Image is built on EC2 and loaded into Minikube using:
minikube image load

---

## Infrastructure Approach

### Terraform

* Provisions AWS infrastructure (EC2, networking)
* Defines resources using Infrastructure-as-Code

### Ansible

* Automates EC2 configuration
* Installs dependencies
* Deploys application
* Performs health checks

---

## Scripts Usage

All scripts are located in:
scripts/

Backup Database
./scripts/backup_db.sh

Backup Site
./scripts/backup_site.sh

Restore Application & Database
./scripts/restore_all.sh

Health Check
./scripts/healthcheck.sh

Smoke Test
./scripts/test_smoke.sh

Log Review
./scripts/log_review.sh

---

## Makefile Commands

make build     → Build application
make up        → Start services
make down      → Stop services
make logs      → View logs
make test      → Run smoke tests
make clean     → Cleanup resources

---

## Validation

* Application accessible via http://<EC2-PUBLIC-IP>:8081
* Kubernetes pods running successfully
* Database connectivity verified
* Data insertion confirmed via SQL queries
* Healthcheck and smoke tests returning HTTP 200
* Backup and restore scripts validated

---

## Known Limitations

* Application exposed via socat bridge (not production-grade)
* Single-node cluster using Minikube
* MySQL access via Kubernetes exec
* Terraform setup is basic
* Logging is file-based

---

## Conclusion

This project demonstrates a structured DevOps workflow on AWS infrastructure, covering application deployment, containerization, CI/CD, Kubernetes orchestration, infrastructure automation, and operational tooling, ensuring a reliable and reproducible environment.
