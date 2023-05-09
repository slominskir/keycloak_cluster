#!/bin/bash

echo "#!/bin/bash" > /healthcheck.sh
echo "ldapwhoami -H ldap://ldap:3389 -x | grep -q 'anonymous'" >> /healthcheck.sh
chmod +x /healthcheck.sh

echo "--------------------------------"
echo "| Step 0: Install client tools |"
echo "--------------------------------"

zypper install -y openldap2-client

echo "------------------------"
echo "| Step 1: Start dirsrv |"
echo "------------------------"

/usr/lib/dirsrv/dscontainer -r &

echo "------------------------------------"
echo "| Step 2: Wait for dirsrv to start |"
echo "------------------------------------"

until ldapwhoami -H ldap://ldap:3389 -x | grep -q "anonymous";
do
  echo $(date) " Still waiting for ${HOSTNAME} to start..."
  sleep 5
done

echo "---------------------"
echo "| Step 3: Configure |"
echo "---------------------"
/init/setup.sh

echo "----------"
echo "| READY! |"
echo "----------"

sleep infinity