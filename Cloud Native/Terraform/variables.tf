variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "todo-app"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "backend_image" {
  description = "Backend Docker image"
  type        = string
  default     = "todo-backend"
}

variable "frontend_image" {
  description = "Frontend Docker image"
  type        = string
  default     = "todo-frontend"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "backend_replicas" {
  description = "Number of backend replicas"
  type        = number
  default     = 2
}

variable "frontend_replicas" {
  description = "Number of frontend replicas"
  type        = number
  default     = 2
}
