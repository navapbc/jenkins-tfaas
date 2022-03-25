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
  steps = tomap({
    "test" = {
      name: "test",
      folder_id: jenkins_folder.test.id
      trigger_xml: ""
    },
    "prod" = {
    name: "prod",
    folder_id: jenkins_folder.infrastructure.id
      trigger_xml: ""
    }
  })
}

resource "jenkins_folder" "test" {
  name        = "test"
}

resource "jenkins_folder" "infrastructure" {
  name        = "infrastructure"
}

resource "jenkins_job" "these" {
  for_each = local.steps
  name     = "tf_job"
  folder   = each.value.folder_id
  template = templatefile("${path.module}/config.xml", { var: each.value})
}
