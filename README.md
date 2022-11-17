# keycloak_cluster
Keycloak Docker Compose cluster with an Oracle database and two instances of Keycloak load balanced with HAProxy.

## Quick Start with Compose

1. Grab Project
```
git clone https://github.com/slominskir/keycloak_cluster
cd keycloak_cluster
```

2. Launch Compose
```
docker compose up
```

3. Navigate to Keycloak admin console

http://localhost:8080/auth/

Login with username `admin` and password `admin`
