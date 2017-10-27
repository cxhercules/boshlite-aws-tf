resource "aws_eip" "boshlite" {
  instance = "${aws_instance.boshlite.id}"
  vpc      = true
}
