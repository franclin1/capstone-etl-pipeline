resource "docker_registry_image" "endpoint_image" {
  name = "${module.fargate_endpoint.repository_url}"
  
  build {
    platform = "linux/amd64"
    context = "../python"
    dockerfile = "Dockerfile"    
}
}