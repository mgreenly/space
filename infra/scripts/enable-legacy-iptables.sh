#!/bin/sh
#
# $> ssh server.war.logic-refinery.io 'sudo bash -s' -- < ./scripts/enable-legacy-iptables.sh
# $> ssh agent1.war.logic-refinery.io 'sudo bash -s' -- < ./scripts/enable-legacy-iptables.sh
#

iptables -F
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
reboot
