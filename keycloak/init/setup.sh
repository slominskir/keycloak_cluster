#!/bin/bash

KEYCLOAK_HOME=/opt/keycloak
KEYCLOAK_URL=http://haproxy:80/auth
KEYCLOAK_REALM=test-realm
KEYCLOAK_REALM_DISPLAY_NAME="TEST REALM"
KEYCLOAK_DEBUG='["true"]'
KEYCLOAK_LDAP_CONNECTION_URL='["ldap://ldap:3389"]'
KEYCLOAK_USERS_DN='["ou=people,dc=example,dc=com"]'
KEYCLOAK_BIND_DN='["cn=Directory Manager"]'
KEYCLOAK_BIND_CREDENTIAL='["password"]'
KEYCLOAK_USER_OBJECT_CLASSES='["nsPerson","nsAccount","nsOrgPerson","posixAccount"]'
KEYCLOAK_KERBEROS_AUTHN='["false"]'
KEYCLOAK_KERBEROS_FOR_PASS='["false"]'


echo "-----------------"
echo "| Step A: Login |"
echo "-----------------"
${KEYCLOAK_HOME}/bin/kcadm.sh config credentials --server "${KEYCLOAK_URL}" --realm master --user "${KEYCLOAK_ADMIN}" --password "${KEYCLOAK_ADMIN_PASSWORD}"

echo "------------------------"
echo "| Step B: Create Realm |"
echo "------------------------"
${KEYCLOAK_HOME}/bin/kcadm.sh create realms -s id=${KEYCLOAK_REALM} -s realm="${KEYCLOAK_REALM}" -s enabled=true -s displayName="${KEYCLOAK_REALM_DISPLAY_NAME}" -s loginWithEmailAllowed=false

echo "----------------------------------------"
echo "| Step C: Create LDAP Storage Provider |"
echo "----------------------------------------"
${KEYCLOAK_HOME}/bin/kcadm.sh create components -r ${KEYCLOAK_REALM} -s parentId=${KEYCLOAK_REALM} \
-s id=${KEYCLOAK_REALM}-ldap-provider -s name=${KEYCLOAK_REALM}-ldap-provider \
-s providerId=ldap -s providerType=org.keycloak.storage.UserStorageProvider \
-s config.debug=${KEYCLOAK_DEBUG} \
-s config.authType='["simple"]' \
-s config.vendor='["rhds"]' \
-s config.priority='["0"]' \
-s config.connectionUrl=${KEYCLOAK_LDAP_CONNECTION_URL} \
-s config.editMode='["READ_ONLY"]' \
-s config.usersDn=${KEYCLOAK_USERS_DN} \
-s config.serverPrincipal='[""]' \
-s config.bindDn="${KEYCLOAK_BIND_DN}" \
-s config.bindCredential=${KEYCLOAK_BIND_CREDENTIAL} \
-s 'config.fullSyncPeriod=["86400"]' \
-s 'config.changedSyncPeriod=["-1"]' \
-s 'config.cachePolicy=["NO_CACHE"]' \
-s config.evictionDay=[] \
-s config.evictionHour=[] \
-s config.evictionMinute=[] \
-s config.maxLifespan=[] \
-s config.importEnabled='["true"]' \
-s 'config.batchSizeForSync=["1000"]' \
-s 'config.syncRegistrations=["false"]' \
-s 'config.usernameLDAPAttribute=["uid"]' \
-s 'config.rdnLDAPAttribute=["uid"]' \
-s 'config.uuidLDAPAttribute=["uid"]' \
-s config.userObjectClasses="${KEYCLOAK_USER_OBJECT_CLASSES}" \
-s 'config.searchScope=["1"]' \
-s 'config.useTruststoreSpi=["ldapsOnly"]' \
-s 'config.connectionPooling=["true"]' \
-s 'config.pagination=["true"]' \
-s config.allowKerberosAuthentication=${KEYCLOAK_KERBEROS_AUTHN} \
-s config.keyTab='[""]' \
-s config.kerberosRealm='[""]' \
-s config.useKerberosForPasswordAuthentication=${KEYCLOAK_KERBEROS_FOR_PASS}

echo "----------------------"
echo "| Step D: Sync Users |"
echo "----------------------"
${KEYCLOAK_HOME}/bin/kcadm.sh create -r ${KEYCLOAK_REALM} user-storage/${KEYCLOAK_REALM}-ldap-provider/sync?action=triggerFullSync
