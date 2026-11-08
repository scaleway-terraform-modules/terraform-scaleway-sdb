resource "scaleway_iam_application" "admin" {
  name        = format("SDB - %s - Admin", var.name)
  description = format("Full access to Serverless SQL Database %s", var.name)
}

resource "scaleway_iam_policy" "admin" {
  name           = format("SDB - %s - Admin", var.name)
  description    = format("Full access to Serverless SQL Database %s", var.name)
  application_id = scaleway_iam_application.admin.id

  rule {
    project_ids          = [scaleway_sdb_sql_database.main.project_id]
    permission_set_names = ["ServerlessSQLDatabaseFullAccess"]
  }
}

resource "scaleway_iam_api_key" "admin" {
  application_id     = scaleway_iam_application.admin.id
  default_project_id = scaleway_sdb_sql_database.main.project_id
  expires_at         = local.keys_expires_at

  lifecycle {
    create_before_destroy = true
  }
}
