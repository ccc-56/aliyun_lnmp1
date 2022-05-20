####setup a ec2 instance with public ip and lnmp stack
####and a db instance
####


terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.165.0"
    }
  }
}

# Configure the Alicloud Provider
provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "alicloud_instance_types" "c1g1" {
  cpu_core_count = 1
  memory_size    = 1
}

data "alicloud_images" "default" {
  name_regex  = "^ubuntu"
  most_recent = true
  owners      = "system"
}

# Create a web server
resource "alicloud_instance" "web" {
  image_id             = "${data.alicloud_images.default.images.0.id}"
  internet_charge_type = "PayByBandwidth"

  instance_type        = "${data.alicloud_instance_types.c1g1.instance_types.0.id}"
  system_disk_category = "cloud_efficiency"
  security_groups      = ["${alicloud_security_group.default.id}"]
  instance_name        = "web1"
  vswitch_id           = "${var.switchid}"
  internet_max_bandwidth_out = 4
  key_name = "${data.alicloud_ecs_key_pairs.ali1.pairs.0.id}"
  system_disk_size = 45
  user_data = file("user-data.sh")

}

data "alicloud_ecs_key_pairs" "ali1" {
  ids        = ["dongzh"]
  name_regex = "dongzh"
}

output "first_ecs_key_pair_id" {
  value = data.alicloud_ecs_key_pairs.ali1.pairs.0.id
}

# Create security group
resource "alicloud_security_group" "default" {
  name        = "default"
  description = "default"
  vpc_id      = "${var.vpcid}"
}

resource "alicloud_security_group_rule" "allow_all_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/1024"
  priority          = 1
  security_group_id = alicloud_security_group.default.id
  cidr_ip           = "0.0.0.0/0"
}

## create db
#resource "alicloud_db_instance" "mydb1" {
#  engine               = "MySQL"
#  engine_version       = "5.7"
#  instance_type        = "mysql.n1.micro.1"
#  instance_storage     = "30"
#  instance_charge_type = "Postpaid"
#  instance_name        = var.db1name
#  vswitch_id           = "${var.switchiddb}"
#  monitoring_period    = "60"
#  parameters {
#    name  = "innodb_large_prefix"
#    value = "ON"
#  }
#}

