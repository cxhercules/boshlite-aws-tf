#!/usr/bin/env bash
set -e

## Create upstart configuration
cat > /etc/rc.local <<EOF
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

sleep 10
/var/vcap/bosh/bin/update_host.sh

exit 0
EOF

## Create file that updates hosts file
cat > /var/vcap/bosh/bin/update_host.sh <<EOF
#!/bin/bash
set -e

if grep -Fxq "127.0.0.1 bosh.sslip.io" /etc/hosts
then
    # code if found
    echo "Host entry found, not updating."
else
    # code if not found
    echo "Host entry not found, will add."

    ## Update hosts file
    echo "127.0.0.1 bosh.sslip.io" | sudo tee -a /etc/hosts
fi
EOF

## Set execute permissions and run
chmod +x /var/vcap/bosh/bin/update_host.sh
/var/vcap/bosh/bin/update_host.sh

## Create script to setup cloud foundry
cat > /home/ubuntu/kickoff_cf_setup.sh <<EOF
#!/usr/bin/env bash

cd cf-deployment

bosh -n -d cf deploy cf-deployment.yml -o operations/bosh-lite.yml \
   --vars-store deployment-vars.yml -v system_domain=\$(curl -s ifconfig.co).nip.io

sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to-destination 10.244.0.34
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination 10.244.0.34
EOF

chmod +x /home/ubuntu/kickoff_cf_setup.sh
