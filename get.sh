#!/bin/sh

#
#
#
#

FILE = "./output.file"

catout()
{
        ls $1 >/dev/null 2>&1
        if [ $? -ne 0 ]; then
                echo "## " $1 " ##" >> $FILE
                echo  "No such file" >> $FILE
                echo "" >> $FILE
                return
        fi
        for catout in $( ls $1 ); do
                echo "## " ${catout} " ##" >> $FILE
                cat ${catout} >> $FILE
                echo "" >> $FILE
        done
}

cmdout()
{
        echo "## " $1 " ##" >> $FILE
        $1 1>>$FILE 2>&1
        echo "" >> $FILE
}

date > $FILE

## CPU ###
catout "/proc/cpuinfo"

## Memory ###
catout "/proc/meminfo"

## Disk ###
cmdout "fdisk -l"

## OS ###
cmdout "/etc/redhat-release"
cmdout "uname -a"
cmdout "hostname -a"
cmdout "hostname -i"
cmdout "/etc/sysconfig/i18n"
catout "/etc/sysconfig/keyboard"
catout "/etc/inittab"
catout "/etc/grub.conf"
catout "/etc/kdump.conf"

## Disk ###
cmdout "df -h"
cmdout "swapon -s"
cmdout "mount -l"
catout "/etc/fstab"

## NetWork ##
cmdout "ifconfig -a"
catout "/etc/sysconfig/network"
catout "/etc/sysconfig/network-scripts/ifcfg-*"
cmdout "netstat -nr"
catout "/etc/sysconfig/network-scripts/rout-*"

## Name Resolution ##
catout "/etc/hosts"
catout "/etc/resolv.conf"

## TIME ##
cmdout "date"
cmdout "/etc/sysconfig/clock"
cmdout "ntpq -p"

## Security ##
cmdout "getenforce"
catout "/etc/sysconfig/selinux"
cmdout "iptables --list"
catout "/etc/sysconfig/iptables"
catout "/etc/sudoers"
catout "/etc/ssh/sshd_config"

## Users ##
catout "/etc/group"
catout "/etc/passwd"
catout "/etc/profile"
catout "/etc/bashrc"

## cron ##
catout "/var/spool/cron/*"

## log ##
catout "/etc/syslog.conf"
catout "/etc/logrotate.conf"
catout "/etc/logrotate.d/*"

## Service ##
cmdout "chkconfig --list"
catout "/etc/services"

## RPM ##
cmdout "rpm -qa"