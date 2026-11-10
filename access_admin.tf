resource "scaleway_iam_application" "admin" {
  count = contains(keys(var.access_levels), "admin") ? 1 : 0

  name        = format("SDB - %s - Admin", var.name)
  description = format("Read and write access to data and schema of the Serverless SQL Databases in the project of %s", var.name)
}

resource "scaleway_iam_policy" "admin" {
  count = contains(keys(var.access_levels), "admin") ? 1 : 0

  name           = format("SDB - %s - Admin", var.name)
  description    = format("Read and write access to data and schema of the Serverless SQL Databases in the project of %s", var.name)
  application_id = scaleway_iam_application.admin[0].id

  rule {
    project_ids          = [scaleway_sdb_sql_database.this.project_id]
    permission_set_names = ["ServerlessSQLDatabaseReadWrite"]
  }
}

resource "scaleway_iam_api_key" "admin" {
  count = contains(keys(var.access_levels), "admin") ? 1 : 0

  application_id     = scaleway_iam_application.admin[0].id
  default_project_id = scaleway_sdb_sql_database.this.project_id
  expires_at         = local.keys_expires_at
  secret_id          = local.key_secret_ids["admin"]

  lifecycle {
    create_before_destroy = true
  }
}
