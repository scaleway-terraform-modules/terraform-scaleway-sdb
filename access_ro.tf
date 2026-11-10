resource "scaleway_iam_application" "ro" {
  count = contains(keys(var.access_levels), "ro") ? 1 : 0

  name        = format("SDB - %s - RO", var.name)
  description = format("Read access to the Serverless SQL Databases in the project of %s", var.name)
}

resource "scaleway_iam_policy" "ro" {
  count = contains(keys(var.access_levels), "ro") ? 1 : 0

  name           = format("SDB - %s - RO", var.name)
  description    = format("Read access to the Serverless SQL Databases in the project of %s", var.name)
  application_id = scaleway_iam_application.ro[0].id

  rule {
    project_ids          = [scaleway_sdb_sql_database.this.project_id]
    permission_set_names = ["ServerlessSQLDatabaseReadOnly"]
  }
}

resource "scaleway_iam_api_key" "ro" {
  count = contains(keys(var.access_levels), "ro") ? 1 : 0

  application_id     = scaleway_iam_application.ro[0].id
  default_project_id = scaleway_sdb_sql_database.this.project_id
  expires_at         = local.keys_expires_at
  secret_id          = local.key_secret_ids["ro"]

  lifecycle {
    create_before_destroy = true
  }
}
