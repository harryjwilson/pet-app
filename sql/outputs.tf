output "sql_external_ipv4" {
  value = google_sql_database_instance.pet_app.ip_address.0.ip_address
}
