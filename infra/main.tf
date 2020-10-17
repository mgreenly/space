resource "aws_route53_zone" "war" {
  name = "war.logic-refinery.io"
}

resource "aws_route53_record" "war-ns" {
  zone_id = "ZGF50YPNDYLZK"
  name    = "war.logic-refinery.io"
  type    = "NS"
  ttl     = "60"
  records = aws_route53_zone.war.name_servers
}

resource "aws_security_group" "allow_kubectl" {
  name        = "allow_kubectl"
  description = "allow inbound kubectl to connect"

  ingress {
    description = "allow kubectl access"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["207.191.158.151/32", "208.118.151.85/32"]
  }

  tags = {
    Name = "allow_kubectl"
  }
}

resource "aws_instance" "server" {
  ami               = "ami-08f6e7446faea65e0"
  instance_type     = "t3a.small"
  availability_zone = "us-east-2a"

  tags = {
    Name = "server"
  }

  key_name = "old-logic-refinery"

  security_groups = ["default", "allow_ssh", "allow_kubectl"]
}

resource "aws_route53_record" "server" {
  zone_id = aws_route53_zone.war.zone_id
  name    = "server.war.logic-refinery.io"
  type    = "A"
  ttl     = "30"
  records = [aws_instance.server.public_ip]
}

resource "aws_route53_record" "server_int" {
  zone_id = aws_route53_zone.war.zone_id
  name    = "server-int.war.logic-refinery.io"
  type    = "A"
  ttl     = "30"
  records = [aws_instance.server.private_ip]
}

resource "aws_instance" "agent1" {
  ami               = "ami-08f6e7446faea65e0"
  instance_type     = "t3a.small"
  availability_zone = "us-east-2a"

  tags = {
    Name = "agent1"
  }

  key_name = "old-logic-refinery"

  security_groups = ["default", "allow_ssh"]
}

resource "aws_route53_record" "agent1" {
  zone_id = aws_route53_zone.war.zone_id
  name    = "agent1.war.logic-refinery.io"
  type    = "A"
  ttl     = "30"
  records = [aws_instance.agent1.public_ip]
}

resource "aws_route53_record" "agent1_int" {
  zone_id = aws_route53_zone.war.zone_id
  name    = "agent1-int.war.logic-refinery.io"
  type    = "A"
  ttl     = "30"
  records = [aws_instance.agent1.private_ip]
}
