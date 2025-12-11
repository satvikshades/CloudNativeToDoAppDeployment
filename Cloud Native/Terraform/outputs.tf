output "namespace" {
  description = "Kubernetes namespace"
  value       = kubernetes_namespace.todo_app.metadata[0].name
}

output "backend_service_url" {
  description = "Backend service URL"
  value       = "http://localhost:30081"
}

output "frontend_service_url" {
  description = "Frontend service URL"
  value       = "http://localhost:30080"
}

output "backend_deployment_name" {
  description = "Backend deployment name"
  value       = kubernetes_deployment.backend.metadata[0].name
}

output "frontend_deployment_name" {
  description = "Frontend deployment name"
  value       = kubernetes_deployment.frontend.metadata[0].name
}
