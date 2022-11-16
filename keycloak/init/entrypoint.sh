#!/bin/bash

echo "--------------------------"
echo "| Step 1: Start Keycloak |"
echo "--------------------------"

/opt/keycloak/bin/kc.sh start-dev &

echo "--------------------------------------"
echo "| Step 2: Wait for Keycloak to start |"
echo "--------------------------------------"

until curl ${HOSTNAME}:8080/auth -sf -o /dev/null;
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