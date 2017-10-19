#!/usr/bin/env bash

cd cf-deployment

bosh -n -d cf deploy cf-deployment.yml -o operations/bosh-lite.yml \
   --vars-store deployment-vars.yml -v system_domain=${public_ip_address}.nip.io

sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to-destination 10.244.0.34
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination 10.244.0.34
