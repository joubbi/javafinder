#!/usr/bin/env bash
#########################################################################################################
# Purpose:  Searches mounted filesystems for java binary
# files and displays the location and version of the file.
# With inspiration from:
# https://redhatlinux.guru/2016/06/13/shell-script-to-locate-and-check-the-version-of-all-java-binaries/
#########################################################################################################
 
echo "---------------------------------------------------------------"
echo "Java Binary Report"
echo "Hostname:  $(hostname)"
echo "Date:      $(date)"
echo "---------------------------------------------------------------"

if file=$(command -v java) ; then
  echo "File location: ${file}"
  echo "---------------------------------------------------------------"
  "${file}" -version | bash
  echo "---------------------------------------------------------------"
fi


# Ignores filesystem types that should not be scanned
for fs in $(mount -v | grep -E -v "nfs|oracle|tmpfs|lofs|ctfs|objfs|fd|devfs|mntfs|sharefs|odm|proc|devpts|sysfs" | awk '{print $3}'); do
  find "${fs}" -xdev -type f -regextype sed -regex ".*java" -print0 | while IFS= read -r -d '' file; do
    # If file is a binary file it executes it with the -version flag and produces an report
    if file "${file}" | grep "executable" &>/dev/null; then
      echo "File Location:  ${file}"
      echo "---------------------------------------------------------------"
      "${file}" -version | bash
      echo "---------------------------------------------------------------"
    fi
  done
done
