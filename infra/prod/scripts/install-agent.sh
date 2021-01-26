#!/bin/sh
#
# $> ssh server.war.logic-refinery.io sudo cat /var/lib/rancher/war/server/node-token > .secrets/server-token
# $> ssh agent1.war.logic-refinery.io "sudo K3S_URL=https://$(terraform output -json war | jq --raw-output .server.private_ip):6443 K3S_TOKEN=$(cat .secrets/server-token) bash -s" -- < ./scripts/install-agent.sh

curl -sfL https://get.k3s.io | sh -
