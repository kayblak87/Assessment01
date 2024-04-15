# Configure the Terraform backend for state storage
terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-state"
    storage_account_name  = "terraformstate123456788"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
