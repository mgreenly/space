#
# create the subdomain
#
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

#
# create acm cert
#
resource "aws_acm_certificate" "default" {
  domain_name               = "war.logic-refinery.io"
  subject_alternative_names = ["*.war.logic-refinery.io"]
  validation_method = "DNS"
}

resource "aws_route53_record" "validation" {
  zone_id  = aws_route53_zone.war.zone_id
  name     = aws_acm_certificate.default.domain_validation_options.*.resource_record_name[0]
  type     = aws_acm_certificate.default.domain_validation_options.*.resource_record_type[0]
  records  = [aws_acm_certificate.default.domain_validation_options.*.resource_record_value[0]]
  ttl      = "60"
}

resource "aws_acm_certificate_validation" "default" {
  certificate_arn = aws_acm_certificate.default.arn
  validation_record_fqdns = [
    aws_route53_record.validation.fqdn,
  ]
}


#
# create security groups
#

resource "aws_security_group" "war_instance" {
  name        = "war_instance"

  description = "applied to all instances in the war cluster"

  # ingress {
  #   description       = "DEBUG: allow all inbound traffic from known ip"
  #   from_port         = 0
  #   to_port           = 0
  #   protocol          = -1
  #   cidr_blocks       = ["207.191.158.151/32", "208.118.151.85/32"]
  # }

  ingress {
    description       = "allow inbound http from alb"
    from_port         = 80
    to_port           = 80
    protocol          = "TCP"
    security_groups   = [aws_security_group.war_alb.id]
  }

  egress {
    description       = "allow all outbound ipv4 traffic"
    from_port         = 0
    to_port           = 0
    protocol          = -1
    cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
    description       = "allow all outbound ipv6 traffic"
    from_port         = 0
    to_port           = 0
    protocol          = -1
    ipv6_cidr_blocks  = ["::/0"]
  }

  tags = {
    Name = "war_instance"
  }
}

resource "aws_security_group" "war_server" {
  name        = "war_server"
  description = "applied to all servers in the war cluster"

  ingress {
    description       = "allow inbound k3s api from known ip"
    from_port         = 6443
    to_port           = 6443
    protocol          = "tcp"
    cidr_blocks       = ["207.191.158.151/32", "208.118.151.85/32"]
  }

  ingress {
    description       = "allow inbound k3s api from cluster instances"
    from_port         = 6443
    to_port           = 6443
    protocol          = "tcp"
    security_groups   = [ aws_security_group.war_instance.id ]
  }

  ingress {
    description       = "allow inbound vxlan from cluster instances"
    from_port         = 8472
    to_port           = 8472
    protocol          = "udp"
    security_groups   = [ aws_security_group.war_instance.id ]
  }

  ingress {
    description       = "allow inbound kubelet from cluster instances"
    from_port         = 10250
    to_port           = 10250
    protocol          = "tcp"
    security_groups   = [ aws_security_group.war_instance.id ]
  }

  tags = {
    Name = "war_server"
  }
}

resource "aws_security_group" "war_agent" {
  name                = "war_agent"
  description         = "applied to all agents in the war cluster"

  ingress {
    description       = "allow inbound vxlan from cluster instances"
    from_port         = 8472
    to_port           = 8472
    protocol          = "udp"
    security_groups   = [ aws_security_group.war_instance.id ]
  }

  ingress {
    description       = "allow inbound kubelet from cluster instances"
    from_port         = 10250
    to_port           = 10250
    protocol          = "tcp"
    security_groups   = [ aws_security_group.war_instance.id ]
  }

  tags = {
    Name = "war_agent"
  }
}

resource "aws_security_group" "war_alb" {
  name                = "war_alb"
  description         = "applied to the war clusters alb"

  ingress {
    description       = "allow https"
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
    description       = "allow all outbound ipv4 traffic"
    from_port         = 0
    to_port           = 0
    protocol          = -1
    cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
    description       = "allow all outbound ipv6 traffic"
    from_port         = 0
    to_port           = 0
    protocol          = -1
    ipv6_cidr_blocks  = ["::/0"]
  }

  tags = {
    Name = "war_alb"
  }
}


#
# Create instances
#
resource "aws_instance" "server" {
  ami               = "ami-08f6e7446faea65e0"
  instance_type     = "t3a.small"
  availability_zone = "us-east-2a"

  tags = {
    Name = "server"
  }

  key_name = "old-logic-refinery"

  security_groups = [
    data.aws_security_group.default.name,
    aws_security_group.war_instance.name,
    aws_security_group.war_server.name
  ]
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

  security_groups = [
    data.aws_security_group.default.name,
    aws_security_group.war_instance.name,
    aws_security_group.war_agent.name
  ]
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

resource "aws_alb" "war" {
  name            = "war"
  subnets         = ["subnet-0b2ad93fcfb118e10", "subnet-0ecabd60630004997" ]
  security_groups = [aws_security_group.war_alb.id]
  internal        = false
}

resource "aws_alb_target_group" "war" {
  name     = "war"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path = "/"
    port = 80
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"
  }
}

resource "aws_alb_target_group_attachment" "server" {
  target_group_arn = aws_alb_target_group.war.arn 
  target_id        = aws_instance.server.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "agent1" {
  target_group_arn = aws_alb_target_group.war.arn 
  target_id        = aws_instance.agent1.id
  port             = 80
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.war.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.default.arn

  default_action {
    target_group_arn = aws_alb_target_group.war.arn
    type             = "forward"
  }
}

resource "aws_route53_record" "default" {
  zone_id = aws_route53_zone.war.zone_id
  name    = "war.logic-refinery.io"
  type    = "A"
  alias {
    name                      = "dualstack.${aws_alb.war.dns_name}"
    zone_id                   = aws_alb.war.zone_id
    evaluate_target_health    = true
  }
}

resource "aws_codecommit_repository" "test" {
  repository_name = "war"
  description     = "The war ci/cd repo"
}

resource "aws_ecr_repository" "war_builder" {
  name = "war-builder"
}

