#!/bin/bash

# local domain
DOMAIN=domain.lan

# Get current user shortname
USRSHORTNAME="$(ls -la /dev/console | awk '{print $3}')"
echo User shortname is $USRSHORTNAME

[ "$USRSHORTNAME" = "user" ] && echo "current user is default user, nothing to do" && exit 0
[ "$USRSHORTNAME" = "admin" ] && echo "current user is admin, nothing to do" && exit 0
[ "$USRSHORTNAME" = "root" ] && echo "current user is root, nothing to do" && exit 0

# Get current user real name
USRLONGNAME="$(dscl . read /Users/$USRSHORTNAME RealName | grep -v RealName | cut -c 2-)"
echo User longname is $USRLONGNAME

# user-friendly name for the system
COMNAME="$(/usr/sbin/scutil --get ComputerName)"
[ -z "$COMNAME" -a "${COMNAME+x}" = "x" ] && echo "current Computer Name is empty" || echo "current Computer Name is $COMNAME"

# local (Bonjour) name
LOCALNAME="$(/usr/sbin/scutil --get LocalHostName)"
[ -z "$LOCALNAME" -a "${LOCALNAME+x}" = "x" ] && echo "current Bonjour name is empty" || echo "current Bonjour name is $LOCALNAME"

# real hostname
SHORTNAME="$(/usr/sbin/scutil --get HostName)"
[ -z "$SHORTNAME" -a "${SHORTNAME+x}" = "x" ] && echo "current hostname is empty" || echo "current hostname is $SHORTNAME"

# Check names values and change them if they differ from current user name
[ "$COMNAME" != "$USRLONGNAME" ] && /usr/sbin/scutil --set ComputerName "$USRLONGNAME" && echo "New ComputerName is $USRLONGNAME"
#[ "$LOCANAME" != "$USRSHORTNAME" ] && /usr/sbin/scutil --set LocalHostName $USRSHORTNAME && echo "New LocalHostName is $USRSHORTNAME"
#[ "$SHORTNAME" != "$USRSHORTNAME.$DOMAIN" ] && /usr/sbin/scutil --set HostName $USRSHORTNAME.$DOMAIN && echo "New HostName is $USRSHORTNAME"
exit 0
