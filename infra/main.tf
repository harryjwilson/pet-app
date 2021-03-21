#################################################
### NETWORK
#################################################

resource "google_compute_network" "pet_app" {
  name                    = "pet-app"
  description             = "The VPC to be created for the pet-app project"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "pet_app" {
  name = "pet-app"
  ip_cidr_range = "10.0.0.0/29"
  region = var.gcp_region
  network = google_compute_network.pet_app.name
}

#################################################
### KUBERNETES CLUSTER
#################################################

resource "google_service_account" "k8s" {
  account_id   = "k8s-service-account"
  display_name = "Service Account for the Kubernetes Cluster"
}

resource "google_container_cluster" "pet_app" {
  name                     = "pet-app"
  location                 = var.gcp_zone
  remove_default_node_pool = true
  initial_node_count       = 1
  network = google_compute_network.pet_app.name
  subnetwork = google_compute_subnetwork.pet_app.name
}

resource "google_container_node_pool" "pet_app" {
  name       = "pet-app"
  location   = var.gcp_zone
  cluster    = google_container_cluster.pet_app.name
  node_count = 1

  node_config {
    machine_type = "n1-standard-1"
    service_account = google_service_account.k8s.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
