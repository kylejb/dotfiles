#!/bin/sh

hostname=$(scutil --get LocalHostName)

# if hostname contains a hyphen and then a number, remove the hyphen and number
normal_hostname=$(echo "$hostname" | sed 's/-[0-9]*$//')

# if our hostname was changed by macOS, change it back
if [ "$normal_hostname" != "$hostname" ]; then
  echo "Changing hostname from $hostname to $normal_hostname"
  scutil --set LocalHostName "$normal_hostname"
  scutil --set ComputerName "$normal_hostname"
fi
