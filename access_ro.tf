resource "scaleway_iam_application" "ro" {
  name        = format("SDB - %s - RO", var.name)
  description = format("Read access to Serverless SQL Database %s", var.name)
}

resource "scaleway_iam_policy" "ro" {
  name           = format("SDB - %s - RO", var.name)
  description    = format("Read access to Serverless SQL Database %s", var.name)
  application_id = scaleway_iam_application.ro.id

  rule {
    project_ids          = [data.scaleway_account_project.current.id]
    permission_set_names = ["ServerlessSQLDatabaseReadOnly"]
  }
}

resource "scaleway_iam_api_key" "ro" {
  application_id     = scaleway_iam_application.ro.id
  default_project_id = data.scaleway_account_project.current.id
  expires_at         = var.keys_ttl > 0 ? time_rotating.keys_ttl[0].rotation_rfc3339 : null
}
