CREATE USER ouser IDENTIFIED BY asw 
DEFAULT TABLESPACE USERS 
TEMPORARY TABLESPACE TEMP;
grant create session to ouser;
grant create table to ouser;
grant all privileges to ouser;
