locals {
  name                = var.service_name == "" ? "/st/microservice/${var.environment}-${var.name}" : "/aws/${var.service_name}/${var.environment}-${var.name}"
  name_override_value = var.name
}
