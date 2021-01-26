#!/bin/sh

ssh server.war.logic-refinery.io sudo cat /etc/rancher/k3s/k3s.yaml > .secrets/k3s.yaml
sed -i 's/127.0.0.1/server.war.logic-refinery.io/g' .secrets/k3s.yaml
