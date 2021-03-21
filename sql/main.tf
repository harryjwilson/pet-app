#################################################
### CLOUD SQL
#################################################

resource "google_sql_database_instance" "pet_app" {
  name = "pet-app-mysql-db"
  database_version = "MYSQL_5_7"
  region = var.gcp_region
  deletion_protection = false
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        name = "node_pool"
        value = var.sql_authorized_network
      }
    }
  }
}

resource "google_sql_user" "dbuser" {
  name = "dbuser"
  instance = google_sql_database_instance.pet_app.name
  host = var.sql_authorized_network
  password = var.sql_dbuser_password
}
