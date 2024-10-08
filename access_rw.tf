resource "scaleway_iam_application" "rw" {
  name        = format("SDB - %s - RW", var.name)
  description = format("Read and write access to Serverless SQL Database %s", var.name)
}

resource "scaleway_iam_policy" "rw" {
  name           = format("SDB - %s - RW", var.name)
  description    = format("Read and write access to Serverless SQL Database %s", var.name)
  application_id = scaleway_iam_application.rw.id

  rule {
    project_ids          = [data.scaleway_account_project.current.id]
    permission_set_names = ["ServerlessSQLDatabaseReadWrite"]
  }
}

resource "scaleway_iam_api_key" "rw" {
  application_id     = scaleway_iam_application.rw.id
  default_project_id = data.scaleway_account_project.current.id
  expires_at         = var.keys_ttl > 0 ? time_rotating.keys_ttl[0].rotation_rfc3339 : null
}
