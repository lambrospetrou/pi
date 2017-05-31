#!/bin/sh

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname "$SCRIPT"`

USER=$( echo "$SCRIPTPATH" | sed 's/\/home\/\([^\/]\+\).*/\1/' )
echo "User: $USER"

# Enable the following lines if you will run this through crontab to properly setup the PATH
if [ -f /home/$USER/.profile ]; then source /home/$USER/.profile ; fi
if [ -f /home/$USER/.bashrc ]; then source /home/$USER/.bashrc ; fi
if [ -f /home/$USER/.zshrc ]; then source /home/$USER/.zshrc ; fi

# The actual script that updates the AWS Route 53 Record set is below
set -ex

echo "PATH: $PATH"

if [ -z "$1" ]; then 
    echo "Subdomain not given...using xxx.lp.gs";
    SUBDOMAIN="xxx.lp.gs"  
else 
    SUBDOMAIN="$1" 
fi 
DOMAIN=$( echo "$SUBDOMAIN" | sed 's/.*\.\+\([a-zA-Z0-9]\+\.[a-zA-Z0-9]\+\)$/\1/' )
echo "Subdomain to update: $SUBDOMAIN"
echo "Domain to update: $DOMAIN"

if [ -z "$2" ]; then 
    echo "IP not given...trying to find the public IP...";
    IP=$( curl https://api.ipify.org )  
else 
    IP="$2" 
fi 
echo "IP to update: $IP"

HOSTED_ZONE_ID=$( aws route53 list-hosted-zones-by-name | grep -B 1 -e "$DOMAIN" | sed 's/.*hostedzone\/\([A-Za-z0-9]*\)\".*/\1/' | head -n 1 )
echo "Hosted zone being modified: $HOSTED_ZONE_ID"

INPUT_JSON=$( cat "$SCRIPTPATH/route53-upsert-A.json" | sed "s/PutTheSubdomainRecordSetHereLike-X.LP.GS/$SUBDOMAIN/" | sed "s/127\.0\.0\.1/$IP/" )

# http://docs.aws.amazon.com/cli/latest/reference/route53/change-resource-record-sets.html
# We want to use the string variable command so put the file contents (batch-changes file) in the following JSON
INPUT_JSON="{ \"ChangeBatch\": $INPUT_JSON }"

aws route53 change-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --cli-input-json "$INPUT_JSON"
