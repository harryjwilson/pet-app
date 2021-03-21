variable "sql_dbuser_password" {
  type        = string
  description = "The dbuser password for the SQL server"
}

variable "sql_host_ipv4" {
  type        = string
  description = "The IPv4 address of the SQL instance"
}

locals {
  env_variables = {
    "SERVER_HOST" : var.sql_host_ipv4,
    "USER_DB" : "dbuser",
    "PASS_DB" : var.sql_dbuser_password,
    "SCHEMA_DB" : "mysql"
  }
}
