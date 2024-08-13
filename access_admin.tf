data "scaleway_account_project" "current" {}

resource "scaleway_iam_application" "admin" {
  name        = format("SDB - %s - Admin", var.name)
  description = format("Full access to Serverless SQL Database %s", var.name)
}

resource "scaleway_iam_policy" "admin" {
  name           = format("SDB - %s - Admin", var.name)
  description    = format("Full access to Serverless SQL Database %s", var.name)
  application_id = scaleway_iam_application.admin.id

  rule {
    project_ids          = [data.scaleway_account_project.current.id]
    permission_set_names = ["ServerlessSQLDatabaseFullAccess"]
  }
}

resource "scaleway_iam_api_key" "admin" {
  application_id     = scaleway_iam_application.admin.id
  default_project_id = data.scaleway_account_project.current.id
}
