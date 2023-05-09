#!/bin/bash

echo "#!/bin/bash" > /healthcheck.sh
echo "curl http://localhost:8080/auth -sf -o /dev/null;" >> /healthcheck.sh
chmod +x /healthcheck.sh


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