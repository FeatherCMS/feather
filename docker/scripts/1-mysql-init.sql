CREATE DATABASE feather; 
CREATE USER 'feather'@'%' IDENTIFIED BY 'feather'; 
GRANT ALL ON `feather`.* to 'feather'@'%';
