variable "gcp_region" {
  type    = string
  default = "europe-west2"
}

variable "sql_authorized_network" {
  type        = string
  description = "Set to the External IP of the Compute Instance Node Pool"
}

variable "sql_dbuser_password" {
  type        = string
  description = "Defines the dbuser password for the SQL server. Ensure you have stored this value securely"
}
