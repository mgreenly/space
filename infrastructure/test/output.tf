output "war" {
  value = {
     git: {
       clone_url_ssh: aws_codecommit_repository.war.clone_url_ssh,
       clone_url_http: aws_codecommit_repository.war.clone_url_http,
     },
     ecr: {
       baseimage: {
         repository_id: aws_ecr_repository.baseimage.registry_id,
         repository_url: aws_ecr_repository.baseimage.repository_url
       },
       builder_ghc: {
         repository_id: aws_ecr_repository.builder_ghc.registry_id,
         repository_url: aws_ecr_repository.builder_ghc.repository_url
       },
       backend: {
         repository_id: aws_ecr_repository.backend.registry_id,
         repository_url: aws_ecr_repository.backend.repository_url
       }
     }
  }
}
