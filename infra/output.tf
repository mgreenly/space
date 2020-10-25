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
    git: {
      clone_url_ssh: aws_codecommit_repository.war.clone_url_ssh,
      clone_url_http: aws_codecommit_repository.war.clone_url_http,
    },
    ecr: {
      haskell: {
        repository_id: aws_ecr_repository.war_haskell.registry_id,
        repository_url: aws_ecr_repository.war_haskell.repository_url
      },
      api: {
        repository_id: aws_ecr_repository.war_api.registry_id,
        repository_url: aws_ecr_repository.war_api.repository_url
      }
    }
    # iam_user_name: data.aws_iam_user.mgreenly.user_name,
    # iam_user_id: data.aws_iam_user.mgreenly.user_id,
  }
}
