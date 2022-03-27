-- Key storage for single-user and multi-user files 

-- This file describes the database tables used to perform the encryption-decryption of spatial files 
-- within the DBFS Spatial Crypt package. These tables include catalogs for storing: (a) encryption 
-- and decryption keys for single-user files, (b) multi-user files, (c) and cryptographic keys together 
-- with the users who should have access to these multi-user files in decrypted form. 

-- These tables and the encrypted column definitions are only possible with the Oracle database 10g 
-- Release 2 onwards to take advantage of Transparent Data encryption technology (TDE).

-- The Oracle wallet can be initialised by issuing the following command, which will: create a wallet, 
-- create a master key for the entire database, and open the wallet.

ALTER SYSTEM SET encryption key identified by "hdgr57fnle39dncv";

-- Subsequently, after each table creation with an encrypted column specification will cause 
-- the TDE to create a separate key for each table. 

-- A. Key storage for single-user spatial files 
-- Table to store each user’s keys for encrypting and decrypting all of their spatial files.

CREATE TABLE CMSDK_UserSpecificFile_keys(
  cmsdk_user_id   NUMBER,             -- CMSDK user id
  enc_key         VARCHAR2(100)  ENCRYPT USING 'AES128',  -- encryption key
  dec_key         VARCHAR2(100)  ENCRYPT USING 'AES128'   -- decryption key
);

-- The administrator can simply create or remove single-user keys for the DBFS users by issuing 
-- the following SQL commands. For instance, to add and delete cryptographic keys for all files 
-- owned by GIS user Scott, identified by CMSDK user id 55514, the SQL commands are:

INSERT INTO CMSDK_UserSpecificFile_keys (cmsdk_user_id, enc_key, dec_key) 
VALUES (55514,'G#^*!JS^MN!468h6', 'G#^*!JS^MN!468h6'); 

DELETE FROM CMSDK_UserSpecificFile_keys WHERE CMSDK_user_id = 55514;

-- The similarity of the keys stored in this table for specific users depend on whether 
-- symmetric or asymmetric algorithms are used. To retrieve the encryption keys of a specific CMSDK 
-- user from this table, the get_enc_key() and get_dec_key() functions.

-- B. Temporary LOB location storage for single-user spatial files

-- The following script describes the table used to store the user temporary LOB locators 
-- internally by the package.

CREATE TABLE CMSDK_user_temp_lobs(
  CMSDK_user_id   NUMBER,                    -- CMSDK user id
  CMSDK_file_id   NUMBER,                      -- User File id
  CMSDK_file_name VARCHAR(100),       -- CMSDK file name
  templob         BLOB                                      -- temporary LOB
);

-- The table is populated with the CMSDK user’s file temporary LOB locator within the 
-- temporary tablespace as soon as the file is decrypted. Upon user logout, the LOB locator 
-- is used to copy the LOB back into its original location.

-- C.  Multi-user, project-specific file key storage

-- The following script describes the database table that stores spatial file’s filepath, 
-- the encryption and decryption keys for that file, and the state of file that is checked 
-- before trying to re-encrypt or re-decrypt files in order to prevent corruption.

CREATE TABLE CMSDK_MultiUserFile_keys_state (
  CMSDK_filepath   VARCHAR2(500),        -- Full CMSDK filepath
  enc_key          VARCHAR2(100) ENCRYPT USING 'AES128',  -- encryption key
  dec_key          VARCHAR2(100) ENCRYPT USING 'AES128',  -- decryption key
  file_encrypted   VARCHAR2(5) DEFAULT 'FALSE' -- file state
  templob          BLOB               -- temporary LOB
);

-- The administrator can issue the following commands to add or remove filepaths, the encrypted state, 
-- and the encryption and decryption keys of the file. For instance, to add and delete spatial file 
-- spottext.MAP with full CMSDK filepath “projects\classified\spottext.MAP”, the SQL commands are:

INSERT INTO CMSDK_MultiUserFile_keys_state (CMSDK_filepath,file_state, enc_key,dec_key) 
VALUES (projects\classified\spottext.MAP’,'hfghfdg657hvg^*T' ,'hfghfdg657hvg^*T');

DELETE FROM CMSDK_MultiUserFile_keys_state 
WHERE CMSDK_filepath LIKE “projects\classified\spottext.MAP’;

-- Once again, the similarity of the keys stored in this table for specific users depend 
-- on whether symmetric or asymmetric encryption algorithms are used. To retrieve the 
-- encryption keys of a specific CMSDK user from this table, the get_file_enc_key()  
-- and get_file_dec_key()functions are used.

-- D.  Multi-user file catalog

-- Table that stores the filepath and the different CMSDK users who require access to them in decrypted form. 

CREATE TABLE CMSDK_MultiUserFile_user_catalog(
    CMSDK_filepath  VARCHAR2(500),    -- CMSDK MultiUserFile Full filepath
    CMSDK_user_id   NUMBER                  -- CMSDK user id
);

-- Using the following SQL commands, the administrator can insert or delete files, CMSDK users, 
-- and the files that should be decrypted for use by a particular user and encrypted back for storage. 
-- For instance, to add and delete cryptographic keys for all files owned by GIS user Scott, 
-- identified by CMSDK user id 55514, the SQL commands are:

INSERT INTO CMSDK_MultiUserFile_user_catalog (CMSDK_user_id, CMSDK _filepath) 
VALUES (55514, ‘projects\classified\spottext.MAP’); 

DELETE FROM CMSDK_MultiUserFile_user_catalog 
WHERE CMSDK_user_id = 55514 
AND CMSDK_filepath LIKE ‘projects\classified\spottext.MAP’; 
