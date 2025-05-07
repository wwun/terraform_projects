output "aws_security_group_http_server_details" { #esto es un valor qe se va a mostrar luego de cada ejecución de terraform apply
  value = aws_security_group.http_server_sg
}