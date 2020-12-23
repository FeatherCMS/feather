CREATE DATABASE feather; 
CREATE USER 'feather'@'%' IDENTIFIED BY 'feather'; 
GRANT ALL ON `feather`.* to 'feather'@'%'; 
SELECT host, user FROM mysql.user;