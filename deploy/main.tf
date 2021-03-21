#################################################
### KUBERNETES NAMESPACES
#################################################

resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
    labels = {
      app = "jenkins"
    }
  }
}

#################################################
### KUBERNETES DEPLOYMENTS
#################################################

resource "kubernetes_deployment" "pet_app" {
  metadata {
    name = "pet-app"
    labels = {
      app = "PetApp"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "PetApp"
      }
    }

    template {
      metadata {
        labels = {
          app = "PetApp"
        }
      }

      spec {
        container {
          image = "dockerexercisetest/docker_exercise:latest"
          name  = "pet-app"
          dynamic "env" {
            for_each = local.env_variables
            content {
              name  = env.key
              value = env.value
            }
          }

          resources {
            limits = {
              cpu    = "0.1"
              memory = "256Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "jenkins" {
  metadata {
    name = "jenkins"
    namespace = kubernetes_namespace.jenkins.metadata.0.name
    labels = {
      app = "Jenkins"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "Jenkins"
      }
    }

    template {
      metadata {
        labels = {
          app = "Jenkins"
        }
      }

      spec {
        container {
          image = "jenkins/jenkins:lts"
          name  = "jenkins"
          port {
            name = "http-port"
            container_port = 8080
          }
          volume_mount {
            name = "jenkins-volume"
            mount_path = "/var/jenkins-volume"
          }
        }
        volume {
          name = "jenkins-volume"
          empty_dir {}
        }
      }
    }
  }
}

#################################################
### KUBERNETES SERVICES
#################################################

resource "kubernetes_service" "pet_app" {
  metadata {
    name = "pet-app"
  }
  spec {
    selector = {
      app = kubernetes_deployment.pet_app.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "jenkins" {
  metadata {
    name = "jenkins"
    namespace = kubernetes_namespace.jenkins.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.jenkins.metadata.0.labels.app
    }
    port {
      port        = 8080
      target_port = 8080
      node_port = 30000
    }
    type = "NodePort"
  }
}
