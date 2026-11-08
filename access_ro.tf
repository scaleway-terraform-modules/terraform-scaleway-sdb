resource "scaleway_iam_application" "ro" {
  name        = format("SDB - %s - RO", var.name)
  description = format("Read access to the Serverless SQL Databases in the project of %s", var.name)
}

resource "scaleway_iam_policy" "ro" {
  name           = format("SDB - %s - RO", var.name)
  description    = format("Read access to the Serverless SQL Databases in the project of %s", var.name)
  application_id = scaleway_iam_application.ro.id

  rule {
    project_ids          = [scaleway_sdb_sql_database.main.project_id]
    permission_set_names = ["ServerlessSQLDatabaseReadOnly"]
  }
}

resource "scaleway_iam_api_key" "ro" {
  application_id     = scaleway_iam_application.ro.id
  default_project_id = scaleway_sdb_sql_database.main.project_id
  expires_at         = local.keys_expires_at

  lifecycle {
    create_before_destroy = true
  }
}
