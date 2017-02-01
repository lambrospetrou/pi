#!/bin/sh

if [ -z $(which realpath) ]; then
    sudo apt-get install realpath
fi

IP="$2"     # the IP to set for the A record of the given subdomain
SUBDOMAIN="$1"    # the subdomain to update its A record

USER=$( whoami )

# update crontab
(crontab -l ; echo "0 * * * * /home/$USER/dev/github/pi/aws/auto-subdomain-update/update-recordset.sh $SUBDOMAIN $IP > /tmp/cron.route53.txt 2>&1") | crontab -

