variable "azure_tenant_details" {
  default = ""
  description = "This is Azure Tenant ID"
}

variable "azure_subscription_details" {
  default = ""
  description = "This is Azure Subscription ID"
}

locals {
   tags = {
    Deployed_By = "Manjunatha"
    Environment = "Test"
    Department = "finance"
    Source = "Terraform"
  }
}

variable "resource_group_location" {
  default     = "uaenorth"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "rg-"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}
