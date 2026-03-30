# Microservices CI/CD with Jenkins and GitHub

Architecture: two microservices in the same repository. Jenkins builds each service from GitHub and deploys to a free-tier EC2 instance via SSH and systemd.

Free-tier AWS resources:
- EC2 t2.micro / t3.micro for Jenkins or application host (750 hours per month free for 12 months)

Setup summary:
1. Create an EC2 instance (Amazon Linux 2 or Ubuntu) and run `scripts/jenkins_setup.sh` as root.
2. Create a Jenkins pipeline job pointing to this repository and set environment variables: EC2_HOST, SSH_CREDENTIALS_ID, REPO_URL.
3. Install GitHub repository deploy key or use Jenkins credentials for SSH.
4. Run the pipeline. Jenkins will build both services and SSH to the EC2 host to run `scripts/deploy_app.sh service-a` and `service-b`.

Notes: replace placeholders in `scripts/deploy_app.sh` and the `Jenkinsfile` with your GitHub repo and Jenkins credential IDs.
