# Kubernetes Configuration
kubeconfig_path = "~/.kube/config"

# Application Configuration
namespace   = "todo-app"
environment = "production"

# Docker Images
backend_image  = "todo-backend"
frontend_image = "todo-frontend"
image_tag      = "latest"

# Replica Configuration
backend_replicas  = 2
frontend_replicas = 2
