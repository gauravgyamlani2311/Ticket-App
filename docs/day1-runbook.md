Subject: Infrastructure Provisioning and Cluster Bootstrap

Project: Ticket-App Deployment

Environment: Production (AWS EC2)

Document Owner: Gaurav Gyamlani

1. INFRASTRUCTURE SPECIFICATIONS
The deployment environment is hosted on an Amazon EC2 instance running Ubuntu 24.04 LTS. The container orchestration layer is managed by Minikube utilizing the Docker driver. External traffic is routed via a Layer 4 Socat bridge.

2. CLUSTER INITIALIZATION
To establish the baseline environment, the local Kubernetes cluster must be initialized with sufficient resource allocation.

Minikube Start: Execute the startup command with a minimum of 4096MB memory and 2 CPUs to ensure stability for both the application and database pods.

Namespace Configuration: Create a dedicated namespace labeled "ticket-app-ns" to ensure logical isolation. Set the current context to this namespace to streamline subsequent kubectl commands.

3. APPLICATION DEPLOYMENT
The application stack is deployed using Kustomize overlays to manage environment-specific configurations.

Resource Application: Apply the production overlays located in the k8s directory. This action provisions the PHP application pods, the MySQL database deployment, and the necessary Persistent Volume Claims (PVC).

Status Verification: Monitor the pod transition states. No further configuration should proceed until all pods report a "Running" status and 1/1 readiness.

4. NETWORK BRIDGING
Because Minikube operates on an internal virtual network, a Socat tunnel is required to map the internal NodePort (30007) to the EC2 host's public interface.

Bridge Execution: The Socat process must be initiated as a background task. It listens on all local interfaces (0.0.0.0) at port 30007 and forwards traffic to the internal Minikube IP on the same port.