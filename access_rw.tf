resource "scaleway_iam_application" "rw" {
  count = contains(var.access_levels, "rw") ? 1 : 0

  name        = format("SDB - %s - RW", var.name)
  description = format("Read and write access to data of the Serverless SQL Databases in the project of %s", var.name)
}

resource "scaleway_iam_policy" "rw" {
  count = contains(var.access_levels, "rw") ? 1 : 0

  name           = format("SDB - %s - RW", var.name)
  description    = format("Read and write access to data of the Serverless SQL Databases in the project of %s", var.name)
  application_id = scaleway_iam_application.rw[0].id

  rule {
    project_ids          = [scaleway_sdb_sql_database.main.project_id]
    permission_set_names = ["ServerlessSQLDatabaseDataReadWrite"]
  }
}

resource "scaleway_iam_api_key" "rw" {
  count = contains(var.access_levels, "rw") ? 1 : 0

  application_id     = scaleway_iam_application.rw[0].id
  default_project_id = scaleway_sdb_sql_database.main.project_id
  expires_at         = local.keys_expires_at

  lifecycle {
    create_before_destroy = true
  }
}
