output "war" {
  value = {
    agent1: {
      public_ip: aws_instance.agent1.public_ip,
      private_ip: aws_instance.agent1.private_ip
    },
    server: {
      public_ip: aws_instance.server.public_ip,
      private_ip: aws_instance.server.private_ip
    }
  }
}
