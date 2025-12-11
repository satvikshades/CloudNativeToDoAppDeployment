terraform {
  required_version = ">= 1.0"
  
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

# Create namespace
resource "kubernetes_namespace" "todo_app" {
  metadata {
    name = var.namespace
    labels = {
      name        = var.namespace
      environment = var.environment
    }
  }
}

# Deploy backend
resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.todo_app.metadata[0].name
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = var.backend_replicas

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "3001"
          "prometheus.io/path"   = "/metrics"
        }
      }

      spec {
        container {
          name  = "backend"
          image = "${var.backend_image}:${var.image_tag}"
          
          port {
            container_port = 3001
            name          = "http"
          }

          env {
            name  = "PORT"
            value = "3001"
          }

          resources {
            requests = {
              memory = "128Mi"
              cpu    = "100m"
            }
            limits = {
              memory = "256Mi"
              cpu    = "200m"
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 3001
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 3001
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
      }
    }
  }
}

# Backend service
resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend-service"
    namespace = kubernetes_namespace.todo_app.metadata[0].name
    labels = {
      app = "backend"
    }
  }

  spec {
    type = "NodePort"
    
    selector = {
      app = "backend"
    }

    port {
      port        = 3001
      target_port = 3001
      node_port   = 30081
      protocol    = "TCP"
      name        = "http"
    }
  }
}

# Deploy frontend
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.todo_app.metadata[0].name
    labels = {
      app = "frontend"
    }
  }

  spec {
    replicas = var.frontend_replicas

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          name  = "frontend"
          image = "${var.frontend_image}:${var.image_tag}"
          
          port {
            container_port = 80
            name          = "http"
          }

          resources {
            requests = {
              memory = "64Mi"
              cpu    = "50m"
            }
            limits = {
              memory = "128Mi"
              cpu    = "100m"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
      }
    }
  }
}

# Frontend service
resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend-service"
    namespace = kubernetes_namespace.todo_app.metadata[0].name
    labels = {
      app = "frontend"
    }
  }

  spec {
    type = "NodePort"
    
    selector = {
      app = "frontend"
    }

    port {
      port        = 80
      target_port = 80
      node_port   = 30080
      protocol    = "TCP"
      name        = "http"
    }
  }
}
