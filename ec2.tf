provider "aws" {
  region = "${var.region}"
}

data "template_file" "user_data" {
  template = "${file("scripts/set_bosh_hosts.sh")}"
}

data "template_file" "cf_script" {
  template = "${file("templates/setup_boshlite_cf.tpl")}"

  vars {
    public_ip_address = "${aws_instance.boshlite.public_ip}"
  }
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

resource "null_resource" "create_script" {
  # connect to our boshlite instance
  connection {
    user     = "ubuntu"
    host = "${aws_instance.boshlite.public_ip}"
  }

  # Creates script that is ready to be executed with public ip updated
  provisioner "file" {
    destination = "/home/ubuntu/kickoff_cf_setup.sh"
    content     = "${data.template_file.cf_script.rendered}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/kickoff_cf_setup.sh",
      "chown ubuntu /home/ubuntu/kickoff_cf_setup.sh",
    ]
  }
}
