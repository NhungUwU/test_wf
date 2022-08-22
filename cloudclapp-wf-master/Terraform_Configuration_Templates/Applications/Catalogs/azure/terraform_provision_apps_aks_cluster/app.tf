#deployment
resource "kubernetes_deployment" "app_deploy" {
  metadata {
    name = "app_name"
    labels = {
      app = "app_label"
    }
  }
  spec {
    replicas = app_replicas
    selector {
      match_labels = {
        app = "app_label"
      }
    }
    template {
      metadata {
        labels = {
          app = "app_label"
        }
      }
      spec {
        container {
          image = "app_image"
          name  = "app_container_name"
          port {
        container_port = app_port
          }
        }
      }
    }
  }
}

#service 
resource "kubernetes_service" "app_service" {
    depends_on = [
    kubernetes_deployment.app_deploy,
  ]
  metadata {
    name = "app-service"
  }
  spec {
    selector = {
      app = "app_name"
    }
    port {
      port = app_port
      target_port = app_port
      #node_port = app_node_port
    }

    type = "LoadBalancer"
  }
}

output "app_load_balancer_ip" {
  value = kubernetes_service.app_service.status.0.load_balancer.0.ingress.0.ip
}
