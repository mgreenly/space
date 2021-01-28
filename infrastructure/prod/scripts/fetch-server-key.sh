#!/bin/bash

mkdir -p .secrets
ssh server.war.logic-refinery.io sudo cat /var/lib/rancher/k3s/server/node-token > .secrets/server-token
