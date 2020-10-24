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
    war_builder: {
      repository_id: aws_ecr_repository.war_builder.registry_id,
      repository_url: aws_ecr_repository.war_builder.repository_url
    },
    repo_ssh_url: aws_codecommit_repository.test.clone_url_ssh,
    repo_http_url: aws_codecommit_repository.test.clone_url_http
    iam_user_name: data.aws_iam_user.mgreenly.user_name
    iam_user_id: data.aws_iam_user.mgreenly.user_id
  }
}
