### DATABASE
output "cluster_endpoint" {
  value = module.aurora_cluster.cluster_endpoint
}
output "cluster_reader_endpoint" {
  value = module.aurora_cluster.cluster_reader_endpoint
}
output "cluster_database_name" {
  value = module.aurora_cluster.cluster_database_name
}
output "cluster_master_password" {
  value     = module.aurora_cluster.cluster_master_password
  sensitive = true
}
output "cluster_master_username" {
  value     = module.aurora_cluster.cluster_master_username
  sensitive = true
}
