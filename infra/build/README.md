# Infrastructure

This will spin up a simple kubernetes cluster. This will be sufficient for the
early stages of development allowing me to develop processes here which
should mostly still apply when we migrate to a more sophisticated cluster
down the road.

This assumes there's no existing infrastructure.

```
# build the infrastructure

   $> terraform apply


# k3s needs legacy iptables so revert them on the server and then the agent
   $> ssh server.war.logic-refinery.io 'sudo bash -s' -- < ./scripts/enable-legacy-iptables.sh
   $> ssh agent1.war.logic-refinery.io 'sudo bash -s' -- < ./scripts/enable-legacy-iptables.sh


# wait for the instances to restart
# install the server
   $> ssh server.war.logic-refinery.io 'sudo bash -s' -- < ./scripts/install-server.sh


# download it's token and config
   $> mkdir -p .secrets
   $> ssh server.war.logic-refinery.io sudo cat /var/lib/rancher/k3s/server/node-token > .secrets/server-token
   $> ./scripts/fetch-config.sh


# configure the agent
   $> ssh agent1.war.logic-refinery.io "sudo K3S_URL=https://$(terraform output -json war | jq --raw-output .server.private_ip):6443 K3S_TOKEN=$(cat .secrets/server-token) bash -s" -- < ./scripts/install-agent.sh


# make kubectl use this config
   $> export KUBECONFIG=$(pwd)/.secrets/k3s.yaml


# view not status
   $> kubectl get nodes


# login docker
  $> echo $(aws --profile logic-refinery ecr get-login-password --region us-east-2) | docker login -u AWS --password-stdin $(terraform output -json | jq --raw-output .war.value.war_builder.repository_url)
```

