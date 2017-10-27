output "boshlite_ip" {
  value = "${aws_eip.boshlite.public_ip}"
}

output "boshlite_uri" {
  value = "https://${aws_eip.boshlite.public_ip}.nip.io"
}


output "boshlite_ec2_id" {
  value = "${aws_instance.boshlite.id}"
}
