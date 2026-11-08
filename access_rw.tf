resource "scaleway_iam_application" "rw" {
  name        = format("SDB - %s - RW", var.name)
  description = format("Read and write access to Serverless SQL Database %s", var.name)
}

resource "scaleway_iam_policy" "rw" {
  name           = format("SDB - %s - RW", var.name)
  description    = format("Read and write access to Serverless SQL Database %s", var.name)
  application_id = scaleway_iam_application.rw.id

  rule {
    project_ids          = [scaleway_sdb_sql_database.main.project_id]
    permission_set_names = ["ServerlessSQLDatabaseReadWrite"]
  }
}

resource "scaleway_iam_api_key" "rw" {
  application_id     = scaleway_iam_application.rw.id
  default_project_id = scaleway_sdb_sql_database.main.project_id
  expires_at         = local.keys_expires_at

  lifecycle {
    create_before_destroy = true
  }
}
