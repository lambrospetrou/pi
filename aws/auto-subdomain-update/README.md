# Route 53 auto-updater

This script will update a given record set's A record in Route 53 to point to the public IP of this machine (or a fixed given one).

## Install

```
./setup.sh yoursubdomain.domain.com
```

The above will try to auto update every hour (using cron jobs) the record set for the subdomain **yoursubdomain.domain.com**.

You have to make sure the system has the AWS sdk installed in your PATH, and that you have some keys deployed that allow the system to modify the route 53 records.

A second argument, is an IP, which will always be used instead of the public one.
