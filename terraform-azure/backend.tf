terraform {
  backend "gcs" {
    bucket      = "tf-dev-gcp-terraform-state"
    prefix      = "terraform-azure/state"
    credentials = "../terraform-gcp-datawarehouse-369d72c63b0e.json"
  }
}
