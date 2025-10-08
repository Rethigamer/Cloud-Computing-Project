variable "location" {
  type        = string
  description = "The Azure region for resource deployment. Must be an unblocked location (e.g., eastus)."
  default     = "eastus" 
}

variable "project_prefix" {
  type        = string
  description = "A unique prefix for all resources (e.g., mhchatbot)."
  default     = "mhchatbot"
}

variable "aks_version" {
  type        = string
  description = "The Kubernetes version for the AKS cluster."
  default     = "1.27" 
}