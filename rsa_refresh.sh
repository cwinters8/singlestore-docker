#!/bin/bash

for host in master child leaf1 leaf2
do
  wait4x tcp ${host}:22 -t 10s && ssh -i ~/.ssh/singlestorekey.pem -o StrictHostKeyChecking=no ubuntu@${host} "sudo rm -f /etc/ssh/ssh_host_rsa_key* && sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''" || echo "failed to connect to ${host}"
done
