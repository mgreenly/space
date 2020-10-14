Assuming there's no infrastructure when you start

```
%> terraform apply
$> ssh server.war.logic-refinery.io 'sudo bash -s' -- < ./scripts/enable-legacy-iptables.sh
$> ssh agent1.war.logic-refinery.io 'sudo bash -s' -- < ./scripts/enable-legacy-iptables.sh
$> ssh server.war.logic-refinery.io 'sudo bash -s' -- < ./scripts/install-server.sh
$> mkdir -p .secrets
$> ssh server.war.logic-refinery.io sudo cat /var/lib/rancher/k3s/server/node-token > .secrets/server-token
$> ssh agent1.war.logic-refinery.io "sudo K3S_URL=https://$(terraform output -json war | jq --raw-output .server.private_ip):6443 K3S_TOKEN=$(cat .secrets/server-token) bash -s" -- < ./scripts/install-agent.sh
$> ./scripts/kubectl get nodes
```
