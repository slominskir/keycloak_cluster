#!/bin/bash

echo "--------------------------"
echo "| Step 0: Install Java 17 |"
echo "--------------------------"
microdnf install java-17-openjdk-headless
microdnf remove java-11-openjdk-headless

cd /tmp
wget https://repo1.maven.org/maven2/org/jboss/marshalling/jboss-marshalling-river/2.1.1.Final/jboss-marshalling-river-2.1.1.Final.jar
wget https://repo1.maven.org/maven2/org/jboss/marshalling/jboss-marshalling/2.1.1.Final/jboss-marshalling-2.1.1.Final.jar

echo "--------------------------"
echo "| Step 1: Start Keycloak |"
echo "--------------------------"

/opt/keycloak/bin/kc.sh start-dev &

echo "----------------------------------------------"
echo "| Step 2: Wait for Keycloak/HAProxy to start |"
echo "----------------------------------------------"

until curl http://haproxy:80/auth -sf -o /dev/null;
do
  echo $(date) " Still waiting for haproxy to accept requests to auth..."
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