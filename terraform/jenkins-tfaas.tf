provider "jenkins" {
  server_url = "http://localhost:8080/" # Or use JENKINS_URL env var
  # use JENKINS_USERNAME env var
  # create an API token here: http://localhost:8080/cjoc/user/<eua-id>/configure
  # you MUST separately hit "Save" at the bottom of this page to store the generated token
  # use JENKINS_PASSWORD env var
  # Or use JENKINS_CA_CERT env var
}

terraform {
  required_providers {
    jenkins = {
      source  = "taiidani/jenkins"
      version = ">= 0.5.0"
    }
  }
}

locals {
  tfaas = yamldecode(file("jenkins-tfaas.yaml"))
  # steps = tomap({
  #   "test" = {
  #     name: "test",
  #     folder_id: jenkins_folder.test.id
  #     trigger_xml: ""
  #   },
  #   "prod" = {
  #   name: "prod",
  #   folder_id: jenkins_folder.infrastructure.id
  #     trigger_xml: ""
  #   }
  # })
  flattened_jobs = flatten([
    for service_key, service in local.tfaas.services : [
      for env_key, env in service.environments : [
        for region, tfvars in env : {
          service_key = service_key
          env_key     = env_key
          region      = region
          tfvarsfile  = tfvars
          module_path = service.module_path
        }   
      ]
    ]
  ])
}

resource "jenkins_folder" "tfaas" {
  name        = "tfaas"
}

resource "jenkins_folder" "tfaas_services" {
  name        = "services"
  folder      = jenkins_folder.tfaas.id
}

resource "jenkins_folder" "services" {
  for_each = local.tfaas.services
  name     = each.key
  folder   = jenkins_folder.tfaas_services.id
}

# resource "jenkins_folder" "environments" {
#   for_each = {
#     for job in local.flattened_jobs : "${job.env_key}_${job.region}" => job
#   }
#   name     = "${each.value.env_key}_${each.value.region}"
#   folder   = jenkins_folder.services[each.value.service_key].id
# }

resource "jenkins_job" "these" {
  for_each = {
    for job in local.flattened_jobs : "${job.env_key}_${job.region}" => job
  }
  name     = "${each.value.env_key}_${each.value.region}"
  folder   = jenkins_folder.services[each.value.service_key].id
  template = templatefile("${path.module}/${each.value.module_path}/config.xml", { var: each.value})
}


resource "jenkins_credential_ssh" "sshgithub" {
  name       = "sshgithub"
  username   = "jcii"
  privatekey = file("/home/jimmy/.ssh/id_ed25519")
  passphrase = ""
}