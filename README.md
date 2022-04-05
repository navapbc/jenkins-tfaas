# jenkins-tfaas
A proof-of-concept service using Terraform and Jenkins to implement a CI/CD pipeline for infrastructure-as-code development
# Design assumptions
This implementation assumes the following terraform organization:
* AWS is the cloud provider
* region-generic resources are organized into Modules
* region-specific data is put into tfvars files
  * each tfvar file represents a unique environment AND cloud region
  * Example: environments/\<env_name\>/\<region\>/module.tfvars

## Requires
* docker
* docker-compose
* terraform

## Setup
```
docker-compose build
docker-compose up
export JENKINS_USERNAME=admin
export JENKINS_PASSWORD=admin
export JENKINS_URL=http://localhost:8080/
cd terraform && terraform apply -auto-approve

TODO: script adding github.com's ssh fingerprint to known_hosts
```

## Jenkins
https://localhost:8080/