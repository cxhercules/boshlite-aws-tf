provider "aws" {
  region = "${var.region}"
}

data "template_file" "user_data" {
  template = "${file("scripts/prep_bosh_n_cf.sh")}"
}

resource "aws_instance" "boshlite" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${aws_key_pair.boshkey.key_name}"
  vpc_security_group_ids = ["${aws_security_group.boshlite_sg.id}"]
  subnet_id              = "${var.subnet_id}"

  user_data = "${data.template_file.user_data.rendered}"

  root_block_device {
    volume_type = "gp2"
  }

  tags {
    Name = "${var.prefix}${var.instance_name}"
  }
}

resource "aws_key_pair" "boshkey" {
  key_name   = "${var.prefix}${var.key_name}"
  public_key = "${var.pub_key}"
}
