output "web_server_ip" {
  value = module.compute.public_ip
}

output "alb_url" {
  value = "http://${module.alb.alb_dns_name}"
}