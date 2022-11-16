alter session set container = XEPDB1;

ALTER SYSTEM SET db_create_file_dest = '/opt/oracle/oradata';

create tablespace KEYCLOAK;

create user "KEYCLOAK_OWNER" profile "DEFAULT" identified by "password" default tablespace "KEYCLOAK" account unlock;

grant connect to KEYCLOAK_OWNER;
grant unlimited tablespace to KEYCLOAK_OWNER;

grant create view to KEYCLOAK_OWNER;
grant create sequence to KEYCLOAK_OWNER;
grant create table to KEYCLOAK_OWNER;
grant create procedure to KEYCLOAK_OWNER;
grant create type to KEYCLOAK_OWNER;