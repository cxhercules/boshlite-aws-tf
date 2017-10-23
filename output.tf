output "boshlite_ip" {
  value = "${aws_instance.boshlite.public_ip}"
}

output "boshlite_uri" {
  value = "https://${aws_instance.boshlite.public_ip}.nip.io"
}
