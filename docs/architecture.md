This `architecture.md` document provides a comprehensive high-level and low-level technical overview of your current DevOps ecosystem. It covers the cloud networking layer, infrastructure as code, and the automation pipeline.

---

# PROJECT ARCHITECTURE DOCUMENTATION

## 1. CLOUD INFRASTRUCTURE (AWS VPC)
The network layer is designed to provide a secure environment for the application while allowing managed external access.

**Virtual Private Cloud (VPC)**
* **CIDR Block:** 10.0.0.0/16
* **Internet Gateway (IGW):** Attached to the VPC to provide a path for communication with the internet.

**Subnets**
* **Public Subnet:** 10.0.1.0/24. This subnet hosts the EC2 instance. It is associated with a Route Table that has a route to the IGW (0.0.0.0/0).

**Security Groups (SG)**
* **Name:** ticket-app-sg
* **Inbound Rules:**
    * SSH (Port 22): Restricted to Admin IP for management.
    * HTTP (Port 80): General web traffic.
    * Jenkins (Port 8080): Access to the CI/CD dashboard.
    * App NodePort (Port 30007): External access to the PHP application via the Socat bridge.
* **Outbound Rules:**
    * All Traffic (0.0.0.0/0): Allows the instance to pull updates, Docker images, and GitHub repositories.

---

## 2. INFRASTRUCTURE AS CODE (TERRAFORM)
Terraform is used to provision the EC2 instance and underlying network components to ensure environment reproducibility.

**Provisioning Logic**
* **Provider:** AWS
* **Resource: aws_instance:** A t3.medium instance type is utilized to support the memory requirements of Minikube.
* **Resource: aws_key_pair:** Public key injection for secure SSH access.
* **User Data:** A script used to pre-install Docker and basic utilities upon instance launch.

---

## 3. COMPUTE & CONTAINER ORCHESTRATION
The core of the application logic resides within a localized Kubernetes cluster on the EC2 host.

**Host Machine (EC2)**
* **Operating System:** Ubuntu 24.04 LTS.
* **Docker Engine:** Acts as the container runtime for Minikube.

**Kubernetes (Minikube)**
* **Namespace:** ticket-app-ns.
* **App Stack:** PHP-Apache frontend pods.
* **Database:** MySQL backend pod with Persistent Volume Claims (PVC) for data durability.
* **Service:** NodePort type service exposing the app internally on port 30007.

---

## 4. CI/CD & CONFIGURATION MANAGEMENT
The lifecycle of the code is automated from the moment a developer pushes to GitHub.

**Jenkins (Pipeline)**
* **Jenkinsfile:** Defines the declarative pipeline stages (Checkout, Build, Deploy, Test).
* **Integration:** Connected to GitHub via Webhooks to trigger builds on every push.

**Ansible (Automation)**
* **Inventory:** Localhost connection.
* **Roles:** * **Bridge Role:** Automates the Socat TCP tunnel between the EC2 public interface and Minikube internal IP.
    * **Database Role:** Ensures the MySQL schema and user tables are present upon deployment or pod restart.

---

## 5. TECHNICAL STACK SUMMARY
* **Cloud:** AWS (VPC, EC2, SG, IGW, Route Tables)
* **IaC:** Terraform
* **Configuration Management:** Ansible
* **CI/CD:** Jenkins, GitHub Webhooks
* **Orchestration:** Kubernetes (Minikube)
* **Web Server:** Apache (running PHP 8.x)
* **Database:** MySQL 8.0
* **Networking Utility:** Socat (Layer 4 Proxy)



---

## 6. DATA FLOW
1. **Developer** pushes code to **GitHub**.
2. **GitHub** sends a webhook to **Jenkins**.
3. **Jenkins** pulls the code and triggers the **Ansible Playbook**.
4. **Ansible** refreshes the **Socat Bridge** and verifies the **MySQL** state.
5. **External User** accesses the site via **EC2-Public-IP:30007**.
6. **Socat** routes traffic into **Minikube**, hitting the **PHP App Pod**.