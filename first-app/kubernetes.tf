output "cluster_name" {
  value = "kubernetes.opsmonks.com"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-kubernetes-opsmonks-com.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-kubernetes-opsmonks-com.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-kubernetes-opsmonks-com.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-kubernetes-opsmonks-com.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.us-west-2a-kubernetes-opsmonks-com.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-kubernetes-opsmonks-com.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-kubernetes-opsmonks-com.name}"
}

output "region" {
  value = "us-west-2"
}

output "vpc_id" {
  value = "${aws_vpc.kubernetes-opsmonks-com.id}"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_autoscaling_group" "master-us-west-2a-masters-kubernetes-opsmonks-com" {
  name                 = "master-us-west-2a.masters.kubernetes.opsmonks.com"
  launch_configuration = "${aws_launch_configuration.master-us-west-2a-masters-kubernetes-opsmonks-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-west-2a-kubernetes-opsmonks-com.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "kubernetes.opsmonks.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-west-2a.masters.kubernetes.opsmonks.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "nodes-kubernetes-opsmonks-com" {
  name                 = "nodes.kubernetes.opsmonks.com"
  launch_configuration = "${aws_launch_configuration.nodes-kubernetes-opsmonks-com.id}"
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = ["${aws_subnet.us-west-2a-kubernetes-opsmonks-com.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "kubernetes.opsmonks.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.kubernetes.opsmonks.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "a-etcd-events-kubernetes-opsmonks-com" {
  availability_zone = "us-west-2a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "kubernetes.opsmonks.com"
    Name                 = "a.etcd-events.kubernetes.opsmonks.com"
    "k8s.io/etcd/events" = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "a-etcd-main-kubernetes-opsmonks-com" {
  availability_zone = "us-west-2a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "kubernetes.opsmonks.com"
    Name                 = "a.etcd-main.kubernetes.opsmonks.com"
    "k8s.io/etcd/main"   = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_iam_instance_profile" "masters-kubernetes-opsmonks-com" {
  name = "masters.kubernetes.opsmonks.com"
  role = "${aws_iam_role.masters-kubernetes-opsmonks-com.name}"
}

resource "aws_iam_instance_profile" "nodes-kubernetes-opsmonks-com" {
  name = "nodes.kubernetes.opsmonks.com"
  role = "${aws_iam_role.nodes-kubernetes-opsmonks-com.name}"
}

resource "aws_iam_role" "masters-kubernetes-opsmonks-com" {
  name               = "masters.kubernetes.opsmonks.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.kubernetes.opsmonks.com_policy")}"
}

resource "aws_iam_role" "nodes-kubernetes-opsmonks-com" {
  name               = "nodes.kubernetes.opsmonks.com"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.kubernetes.opsmonks.com_policy")}"
}

resource "aws_iam_role_policy" "masters-kubernetes-opsmonks-com" {
  name   = "masters.kubernetes.opsmonks.com"
  role   = "${aws_iam_role.masters-kubernetes-opsmonks-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.kubernetes.opsmonks.com_policy")}"
}

resource "aws_iam_role_policy" "nodes-kubernetes-opsmonks-com" {
  name   = "nodes.kubernetes.opsmonks.com"
  role   = "${aws_iam_role.nodes-kubernetes-opsmonks-com.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.kubernetes.opsmonks.com_policy")}"
}

resource "aws_internet_gateway" "kubernetes-opsmonks-com" {
  vpc_id = "${aws_vpc.kubernetes-opsmonks-com.id}"

  tags = {
    KubernetesCluster = "kubernetes.opsmonks.com"
    Name              = "kubernetes.opsmonks.com"
  }
}

resource "aws_key_pair" "kubernetes-kubernetes-opsmonks-com-842abc70c807f449aa465ad9c0563755" {
  key_name   = "kubernetes.kubernetes.opsmonks.com-84:2a:bc:70:c8:07:f4:49:aa:46:5a:d9:c0:56:37:55"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.kubernetes.opsmonks.com-842abc70c807f449aa465ad9c0563755_public_key")}"
}

resource "aws_launch_configuration" "master-us-west-2a-masters-kubernetes-opsmonks-com" {
  name_prefix                 = "master-us-west-2a.masters.kubernetes.opsmonks.com-"
  image_id                    = "ami-ac58c0cc"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-kubernetes-opsmonks-com-842abc70c807f449aa465ad9c0563755.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-kubernetes-opsmonks-com.id}"
  security_groups             = ["${aws_security_group.masters-kubernetes-opsmonks-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-west-2a.masters.kubernetes.opsmonks.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "nodes-kubernetes-opsmonks-com" {
  name_prefix                 = "nodes.kubernetes.opsmonks.com-"
  image_id                    = "ami-ac58c0cc"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-kubernetes-opsmonks-com-842abc70c807f449aa465ad9c0563755.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-kubernetes-opsmonks-com.id}"
  security_groups             = ["${aws_security_group.nodes-kubernetes-opsmonks-com.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.kubernetes.opsmonks.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.kubernetes-opsmonks-com.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.kubernetes-opsmonks-com.id}"
}

resource "aws_route_table" "kubernetes-opsmonks-com" {
  vpc_id = "${aws_vpc.kubernetes-opsmonks-com.id}"

  tags = {
    KubernetesCluster = "kubernetes.opsmonks.com"
    Name              = "kubernetes.opsmonks.com"
  }
}

resource "aws_route_table_association" "us-west-2a-kubernetes-opsmonks-com" {
  subnet_id      = "${aws_subnet.us-west-2a-kubernetes-opsmonks-com.id}"
  route_table_id = "${aws_route_table.kubernetes-opsmonks-com.id}"
}

resource "aws_security_group" "masters-kubernetes-opsmonks-com" {
  name        = "masters.kubernetes.opsmonks.com"
  vpc_id      = "${aws_vpc.kubernetes-opsmonks-com.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "kubernetes.opsmonks.com"
    Name              = "masters.kubernetes.opsmonks.com"
  }
}

resource "aws_security_group" "nodes-kubernetes-opsmonks-com" {
  name        = "nodes.kubernetes.opsmonks.com"
  vpc_id      = "${aws_vpc.kubernetes-opsmonks-com.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "kubernetes.opsmonks.com"
    Name              = "nodes.kubernetes.opsmonks.com"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-kubernetes-opsmonks-com.id}"
  source_security_group_id = "${aws_security_group.masters-kubernetes-opsmonks-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-kubernetes-opsmonks-com.id}"
  source_security_group_id = "${aws_security_group.masters-kubernetes-opsmonks-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-kubernetes-opsmonks-com.id}"
  source_security_group_id = "${aws_security_group.nodes-kubernetes-opsmonks-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-kubernetes-opsmonks-com.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-kubernetes-opsmonks-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-kubernetes-opsmonks-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-kubernetes-opsmonks-com.id}"
  source_security_group_id = "${aws_security_group.nodes-kubernetes-opsmonks-com.id}"
  from_port                = 1
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-kubernetes-opsmonks-com.id}"
  source_security_group_id = "${aws_security_group.nodes-kubernetes-opsmonks-com.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-kubernetes-opsmonks-com.id}"
  source_security_group_id = "${aws_security_group.nodes-kubernetes-opsmonks-com.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-kubernetes-opsmonks-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-kubernetes-opsmonks-com.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "us-west-2a-kubernetes-opsmonks-com" {
  vpc_id            = "${aws_vpc.kubernetes-opsmonks-com.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "us-west-2a"

  tags = {
    KubernetesCluster                               = "kubernetes.opsmonks.com"
    Name                                            = "us-west-2a.kubernetes.opsmonks.com"
    "kubernetes.io/cluster/kubernetes.opsmonks.com" = "owned"
  }
}

resource "aws_vpc" "kubernetes-opsmonks-com" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                               = "kubernetes.opsmonks.com"
    Name                                            = "kubernetes.opsmonks.com"
    "kubernetes.io/cluster/kubernetes.opsmonks.com" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "kubernetes-opsmonks-com" {
  domain_name         = "us-west-2.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster = "kubernetes.opsmonks.com"
    Name              = "kubernetes.opsmonks.com"
  }
}

resource "aws_vpc_dhcp_options_association" "kubernetes-opsmonks-com" {
  vpc_id          = "${aws_vpc.kubernetes-opsmonks-com.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.kubernetes-opsmonks-com.id}"
}

terraform = {
  required_version = ">= 0.9.3"
}
