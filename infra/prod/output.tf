output "war" {
  value = {
    agent1: {
      public_ip: aws_instance.agent1.public_ip,
      private_ip: aws_instance.agent1.private_ip
    },
    server: {
      public_ip: aws_instance.server.public_ip,
      private_ip: aws_instance.server.private_ip
    },
    git: {
      ghc_builder: {
        clone_url_ssh: aws_codecommit_repository.ghc_builder.clone_url_ssh,
        clone_url_http: aws_codecommit_repository.ghc_builder.clone_url_http,
      },
    },
    ecr: {
      ghc_builder: {
        repository_id: aws_ecr_repository.ghc_builder.registry_id,
        repository_url: aws_ecr_repository.ghc_builder.repository_url
      }
    }
  }
}
