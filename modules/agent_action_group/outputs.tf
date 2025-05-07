output "api_schema" {
  value = "${local.use_api_schema}-${local.api_schema_from_file}"
}