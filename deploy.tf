#provider "google" {
#  project = "mausam-pandey"       # Replace with your GCP project ID
#  region  = "us-central1"           # Replace with your desired region
#  zone    = "us-central1-c"         # Replace with your desired zone
#}

resource "google_container_cluster" "my-cluster" {
  name     = "my-gke-cluster"
  location = "us-central1-c"

  initial_node_count = 3

  # Optional: Node pool configuration
  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }


  # Enable network policies
  network_policy {
    enabled = true
  }


# Configure Google Kubernetes Engine (GKE) authentication
resource "google_container_cluster" "gke-cluster" {
  name     = "gke-cluster"
  location = "us-central1-c"

  initial_node_count = 3

  node_config {
    machine_type = "e2-medium"
    image_type   = "COS"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# Output the cluster name and kubeconfig
output "kube_config" {
  value = google_container_cluster.my-cluster.kube_config[0].raw_kube_config
}

