#output "redis_connection_string" {
#  sensitive   = true
#  value       = "${rediscloud_subscription_database.mc-example.private_endpoint},user=default,password=${rediscloud_subscription_database.mc-example.password}"
#  description = "The connection string used in the 'Cart Service' to connect to redis"
#}


output "db_private_endpoint" {
  value = "redis-enterprise-database-headless:13188"
}

output "db_password" {
  value = data.external.env.result["db_password"]
}

output "redis_connection_string" {
  value       = "redis-enterprise-database-headless:13188,user=default,password=${data.external.env.result["db_password"]}"
  description = "The connection string used in the 'Cart Service' to connect to Redis Enterprise"
}

