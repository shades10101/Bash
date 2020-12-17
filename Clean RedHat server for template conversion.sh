#!/bin/bash
# This will make a install of RedHat/CentOs ready to be converted to a template.

# remind user to run command first
echo "Run 'history -cw' to clear terminal history before running this script"
read -p "Press enter to continue"

# stop logging services
/usr/bin/systemctl stop rsyslog

# Optionally stop auditd
#/sbin/service auditd stop

# remove old kernels except last 2
/bin/package-cleanup -y --oldkernels --count=2

# clean yum cache
/usr/bin/yum clean all

# shrink logspace, remove and truncate logs
/usr/sbin/logrotate -f /etc/logrotate.conf
/usr/bin/rm -f /var/log/*-???????? /var/log/*.gz
/usr/bin/rm -f /var/log/dmesg.old
/usr/bin/rm -rf /var/log/anaconda
find /var/log/ -type f -exec sh -c '>"{}"' \;

# set hostname
/usr/bin/hostnamectl set-hostname localhost.localdomain

# remove tmp files
/usr/bin/rm -rf /tmp/*
/usr/bin/rm -rf /var/tmp/*

# remove udev hardware rules if necessary
#/bin/rm -f /etc/udev/rules.d/70*

# remove uuid from ifcfg scripts
/usr/bin/sed -i '/^(HWADDR|UUID)=/d' /etc/sysconfig/network-scripts/ifcfg-*

# remove SSH host keys
/usr/bin/rm -f /etc/ssh/ssh_host*

# remove root users shell history
/usr/bin/rm -f ~root/.bash_history
unset HISTFILE

# remove root users SSH history
/usr/bin/rm -rf ~root/.ssh/
/usr/bin/rm -f ~root/anaconda-ks.cfg

# clear machine-id
> /etc/machine-id

# sys-unconfig
/usr/sbin/sys-unconfig
