-- 20-July-2022 The main ECMSDL spatial crypt package, intended to be deployed on OracleXE 11g with ECMSDK.
-- This package contains the source code of the Spatial Crypt Package implemented within Oracle Content Management Standarad Developement Kit (CMSDK) 
-- that first obtains details of user-specific and multi-user GIS files specified for encryption by FSDB users, 
-- and then calls either the encryption or the decryption procedures. 

-- The procedures within this package are executed upon GIS-DFS user session creation and termination in ECMSDK. 
-- The ECMSDK Spatial Crypt Package obtains details of all files belonging to individual ECMSDK spatial users and
-- also for files which need sharing at project level for multiple users, which are specified for
-- encryption and calls the encryption or decryption procedures

-- ECMSDK_spatial_crypt package specification
CREATE OR REPLACE PACKAGE ECMSDK_11g_spatial_crypt AS
  -- Retrieve user specific and file specific cryptographic keys
  FUNCTION get_enc_key (user_id INTEGER) RETURN VARCHAR;  -- returns ECMSDK user's file's encryption key
  FUNCTION get_dec_key (user_id INTEGER) RETURN VARCHAR;  -- returns ECMSDK user's file's decryption key
  FUNCTION get_file_enc_key (filepath VARCHAR2) RETURN VARCHAR; -- returns encryption key FOR that ECMSDK file
  FUNCTION get_file_dec_key (filepath VARCHAR2) RETURN VARCHAR; -- returns decryption key FOR that ECMSDK file
  -- Split filepath to get file id and test file usage procedures
  FUNCTION split (p_filepath VARCHAR2) RETURN INTEGER;           -- splits ECMSDK filepath and return fileid
  FUNCTION check_in_use (v_filepath IN VARCHAR, v_user_id IN INTEGER) RETURN BOOLEAN; -- test file usage
  -- Compute list of files that need to be encrypted and decrypted for an FS user
  PROCEDURE get_ECMSDK_user_files_enc (v_userid IN INTEGER);       -- obtain ECMSDK user's files to be encrypted
  PROCEDURE get_ECMSDK_user_files_dec (v_userid IN INTEGER);       -- obtain ECMSDK user's files to be decrypted
  -- More detailed proceudres to obtain permanent LOB locators
  PROCEDURE encrypt_User_Specific_file (file_id IN INTEGER, enc_key IN VARCHAR,v_userid IN INTEGER, decrypted IN BOOLEAN);
  PROCEDURE decrypt_User_Specific_file (file_id IN INTEGER, dec_key IN VARCHAR,v_userid IN INTEGER);
  PROCEDURE encrypt_Multi_user_file_sub (v_filepath IN VARCHAR); -- subsequent encryption after user logoff
  PROCEDURE decrypt_Multi_user_file (v_filepath IN VARCHAR);     -- decryption of multiuser file upon logon
  -- BLOB transformation procedures: Encryption, decryption and copy. 
  -- spatial text and vector data encryption
  PROCEDURE encrypt (file_id IN INTEGER, enc_key IN VARCHAR, original_blob BLOB);
  -- copy modified blobs which do not need encryption   
  PROCEDURE blob_copy (file_id IN INTEGER, enc_key IN VARCHAR, v_userid IN INTEGER);  
  PROCEDURE decrypt (file_id IN INTEGER, dec_key IN VARCHAR);   -- spatial text and vector data decryption
  -- The blob pad and unpad procedures
  PROCEDURE pad (v_file_id IN INTEGER, v_media IN INTEGER, v_pad_amount IN INTEGER); -- pad file with bytes
  PROCEDURE unpad (v_file_id IN INTEGER, v_media IN INTEGER, v_original_length IN INTEGER); -- unpad file
  -- Administrator tasks - change keys, initial encryption, and final decryption of multiuser files
  PROCEDURE change_user_specific_keys (userid IN INTEGER, new_enc_key IN VARCHAR, new_dec_key IN VARCHAR);
  PROCEDURE change_Multi_user_file_keys (v_filepath IN VARCHAR, new_enc_key IN VARCHAR, new_dec_key IN VARCHAR);
  -- Initial encryption and final decryption for multi-user files by Administrator 
  PROCEDURE encrypt_Multi_user_file_init (v_filepath IN VARCHAR);  -- initial encryption of multiuser file
  PROCEDURE decrypt_Multi_user_file_final (v_filepath IN VARCHAR); -- final decryption of multiuser file 
  -- Specification of the Encryption algorithm used from Oracle. Can be AES, 3DES or DES	
  encryption_type INTEGER := dbms_crypto.ENCRYPT_AES128 + dbms_crypto.CHAIN_CBC + dbms_crypto.PAD_PKCS5;
  --encryption_type INTEGER := dbms_crypto.ENCRYPT_3des + dbms_crypto.CHAIN_CBC + dbms_crypto.PAD_PKCS5;
  END ECMSDK_11g_spatial_crypt;
/
-- Program definitions in package ECMSDK_spatial_crypt
CREATE OR REPLACE PACKAGE BODY ECMSDK_11g_spatial_crypt IS

  -- The key_storage table contains ECMSDK user and their encryption and decryption keys
  -- This function queries and returns the encryption key based on the ECMSDK user_id passed as parameter
  FUNCTION get_enc_key (user_id INTEGER) RETURN VARCHAR IS
  v_enc_key VARCHAR(50);
  BEGIN
    SELECT enc_key INTO v_enc_key FROM ECMSDK_USF_keys WHERE ECMSDK_user_id = user_id;
    RETURN v_enc_key;
  END;

  -- The key_storage table contains ECMSDK user and their encryption and decryption keys
  -- This function queries and returns the decryption key based on the ECMSDK user_id passed as parameter
  FUNCTION get_dec_key (user_id INTEGER) RETURN VARCHAR IS
  v_dec_key VARCHAR(50);
  BEGIN
    SELECT dec_key INTO v_dec_key FROM ECMSDK_USF_keys WHERE ECMSDK_user_id = user_id;
    RETURN v_dec_key;
  END;
 
  -- The ECMSDK_MUF_keys_state table contains ECMSDK file and their encryption and decryption keys
  -- This function computes the encryption key for the ECMSDK file with ECMSDK filepath passed as parameter
  FUNCTION get_file_enc_key (filepath VARCHAR2) RETURN VARCHAR IS
  v_enc_key VARCHAR(50);
  BEGIN
    SELECT enc_key INTO v_enc_key FROM sys.ECMSDK_MUF_keys_state WHERE ECMSDK_filepath = filepath;
    RETURN v_enc_key;
  END;

  -- The ECMSDK_MUF_keys_state table contains ECMSDK file and their encryption and decryption keys
  -- This function computes the decryption key for the ECMSDK file with ECMSDK filepath passed as parameter
  FUNCTION get_file_dec_key (filepath VARCHAR2) RETURN VARCHAR IS
  v_dec_key VARCHAR(50);
  BEGIN
    SELECT dec_key INTO v_dec_key FROM sys.ECMSDK_MUF_keys_state WHERE ECMSDK_filepath = filepath;
    RETURN v_dec_key;
  END;

  -- This function is passed with ECMSDK file filpath and it checks to see if the users who should have access
  -- to that file do not have active sessions to prevent decryption while they are working with it.
  -- First a list of all files that are in-use is generated, and then the cross checked against the
  -- particular file.
  FUNCTION check_in_use (v_filepath IN VARCHAR, v_user_id IN INTEGER) RETURN BOOLEAN IS
  CURSOR in_session_files IS
    SELECT ECMSDK_filepath FROM sys.ECMSDK_MUF_user_catalog
      WHERE ECMSDK_user_id IN (SELECT userid FROM ecmsdk.odmz_session WHERE userid != v_user_id);
  in_session_files_record in_session_files%ROWTYPE;
  BEGIN
    OPEN in_session_files;
    LOOP
      FETCH in_session_files INTO in_session_files_record;
      EXIT WHEN in_session_files%NOTFOUND;
      IF (in_session_files_record.ECMSDK_filepath = v_filepath) THEN -- if file to be encrypted is decrypted
        RETURN TRUE;                                              -- then return true
      END IF;
    END LOOP;
    CLOSE in_session_files; -- if users who should have access to that file have no active sessions
    RETURN FALSE;           -- then return false so that it can be encrypted
  END check_in_use;

  -- This procedure is passed with the ECMSDK userid and obtains all files to which the ECMSDK user
  -- should have access to and call encryption procedure
  PROCEDURE get_ECMSDK_user_files_enc (v_userid IN INTEGER) IS
  v_enc_key       VARCHAR(50);    -- ECMSDK user-specific encryption key
  v_file_enc_key  VARCHAR(50);    -- ECMSDK file-specific encryption key
  v_fileid        INTEGER;        -- ECMSDK file_id computed from ECMSDK filepath

  -- There are several types of files that need to be passed for encryption.
  -- This procedure concentrates on those which need encryption. This will involve:
  -- 1. Files which have been decrypted and need encryption back,
  -- 2. Files that have been newly created files which need for encryption
  -- 3. Files that have been decrypted abut do not need encryption back

  -- Set of user-specific sensitive files which were decrypted and need encryption back.
   CURSOR ECMSDK_US_Mod_Enc IS
     SELECT ECMSDK_file_id AS id FROM ECMSDK_user_temp_lobs WHERE ECMSDK_user_id = v_userid
        INTERSECT
          SELECT id FROM ecmsdk.odm_publicobject WHERE owner = v_userid AND (name LIKE '%.enc');
   -- Set of files whicc have been newly created files which need for encryption
   CURSOR ECMSDK_US_New_Enc IS
      SELECT id FROM ecmsdk.odm_publicobject WHERE owner = v_userid AND (name LIKE '%.enc')
        MINUS
          SELECT ECMSDK_file_id AS id FROM ECMSDK_user_temp_lobs WHERE ECMSDK_user_id = v_userid;
-- Set of user-specific xisting files which have been decrypted, maybe modified but do not need          -- encryption. They will just be copied into the original blob
   CURSOR ECMSDK_US_Copy IS
      SELECT ECMSDK_file_id AS id FROM ECMSDK_user_temp_lobs WHERE ECMSDK_user_id = v_userid
        INTERSECT
         SELECT id FROM ecmsdk.odm_publicobject WHERE owner = v_userid AND (name NOT LIKE '%.enc');

  -- generate list of Multi-User sensitive files to which this user has access
  CURSOR ECMSDK_MultiUser_filepaths IS
    SELECT i.ECMSDK_filepath FROM sys.ECMSDK_MUF_user_catalog i, sys.ECMSDK_MUF_keys_state  f
      WHERE i.ECMSDK_filepath = f.ECMSDK_filepath
       AND (f.file_encrypted LIKE 'FALSE') AND (i.ECMSDK_user_id = v_userid);

  ECMSDK_US_Mod_Enc_rec        ECMSDK_US_Mod_Enc%ROWTYPE;
  ECMSDK_US_New_Enc_rec        ECMSDK_US_New_Enc%ROWTYPE;
  ECMSDK_US_Copy_record        ECMSDK_US_Copy%ROWTYPE;
  ECMSDK_MUFP_record           ECMSDK_MultiUser_filepaths%ROWTYPE;
  in_use BOOLEAN                      := FALSE;

  BEGIN
    v_enc_key := get_enc_key (v_userid); -- get encryption key for single-user owned files
    -- Encrpt Files which were decrypted and need encryption back
    OPEN ECMSDK_US_Mod_Enc;
    LOOP
      FETCH ECMSDK_US_Mod_Enc INTO ECMSDK_US_Mod_Enc_rec;
      EXIT WHEN ECMSDK_US_Mod_Enc%NOTFOUND;
      -- call encryption procedure passing file_id and encryption key as parameter
      encrypt_User_Specific_file (ECMSDK_US_Mod_Enc_rec.id, v_enc_key,v_userid, true);
    END LOOP;
    CLOSE ECMSDK_US_Mod_Enc;
    -- Encrypt Files that were not initially decrypted but need to be encrypted
    OPEN ECMSDK_US_New_Enc;
    LOOP
      FETCH ECMSDK_US_New_Enc INTO ECMSDK_US_New_Enc_rec;
      EXIT WHEN ECMSDK_US_New_Enc%NOTFOUND;
      -- call encryption procedure passing file_id and encryption key as parameter
      -- pass to intermediate procedure stating that the file previously has not been decrypted
      encrypt_User_Specific_file (ECMSDK_US_New_Enc_rec.id, v_enc_key,v_userid, false);
    END LOOP;
    CLOSE ECMSDK_US_New_Enc;

-- Only Copy content back to original LOB location for files which were decrypted but do not need           -- encryption
    OPEN ECMSDK_US_Copy;
    LOOP
      FETCH ECMSDK_US_Copy INTO ECMSDK_US_Copy_record;
      EXIT WHEN ECMSDK_US_Copy%NOTFOUND;
     -- call encryption procedure passing file_id and encryption key as parameter-
      blob_copy (ECMSDK_US_Copy_record.id, v_enc_key,v_userid);
    END LOOP;
    CLOSE ECMSDK_US_Copy;

    -- Files to which user hass access in multi-user files are encrypted
    OPEN ECMSDK_MultiUser_filepaths; -- Obtain all files belonging to multi user and call encryption procedure
    LOOP
      FETCH ECMSDK_MultiUser_filepaths INTO ECMSDK_MUFP_record;
      EXIT WHEN ECMSDK_MultiUser_filepaths%NOTFOUND;
      -- check to see if file is not currently being used
      in_use := check_in_use (ECMSDK_MUFP_record.ECMSDK_filepath, v_userid);
      IF(in_use = TRUE) THEN
        dbms_output.put_line('File ' || ECMSDK_MUFP_record.ECMSDK_filepath ||' is in-use');
      ELSIF (in_use = FALSE) THEN   -- if not being used then encrypt back for protection
         encrypt_Multi_user_file_sub (ECMSDK_MUFP_record.ECMSDK_filepath);
      END IF;
    END LOOP;
    CLOSE ECMSDK_MultiUser_filepaths;
  END get_ECMSDK_user_files_enc;

  -- This procedure is passed with the ECMSDK userid and obtain all files to which the
  -- ECMSDK user should have access to and call decryption procedure
  PROCEDURE get_ECMSDK_user_files_dec (v_userid IN INTEGER) IS
  v_dec_key       VARCHAR(50);    -- ECMSDK user-specific decryption key
  v_file_dec_key  VARCHAR(50);    -- ECMSDK file-specific decryption key
  v_fileid        INTEGER;        -- store ECMSDK file_id computed from ECMSDK filepath

  CURSOR ECMSDK_US_Files IS
    SELECT name, id FROM ecmsdk.odm_publicobject WHERE owner = v_userid AND (name LIKE '%.enc');
  
  CURSOR ECMSDK_MultiUser_filepaths IS
    SELECT i.ECMSDK_filepath FROM sys.ECMSDK_MUF_user_catalog i, sys.ECMSDK_MUF_keys_state  f
      WHERE i.ECMSDK_filepath = f.ECMSDK_filepath
       AND (f.file_encrypted LIKE 'TRUE') AND (i.ECMSDK_user_id = v_userid);

  ECMSDK_USF_record ECMSDK_US_Files%ROWTYPE;
  ECMSDK_MUFP_record ECMSDK_MultiUser_filepaths%ROWTYPE;
  BEGIN
    v_dec_key := get_dec_key (v_userid);
    OPEN ECMSDK_US_Files;
    LOOP -- First, decrypt single user-owned files
      FETCH ECMSDK_US_Files INTO ECMSDK_USF_record;
      EXIT WHEN ECMSDK_US_Files%NOTFOUND;
      INSERT INTO ECMSDK_user_temp_lobs (ECMSDK_user_id , ECMSDK_file_id, ECMSDK_file_name) VALUES (v_userid,ECMSDK_USF_record.id, ECMSDK_USF_record.name);
      decrypt_User_Specific_file (ECMSDK_USF_record.id + 1, v_dec_key,v_userid);
      COMMIT; --commit changes
    END LOOP;
    CLOSE ECMSDK_US_Files;

    OPEN ECMSDK_MultiUser_filepaths; -- Obtain all files belonging to multi user and call encryption procedure
    LOOP -- then decrypt multiple user accessible files
      FETCH ECMSDK_MultiUser_filepaths INTO ECMSDK_MUFP_record;
      EXIT WHEN ECMSDK_MultiUser_filepaths%NOTFOUND;
        decrypt_Multi_user_file (ECMSDK_MUFP_record.ECMSDK_filepath);
    END LOOP;
    CLOSE ECMSDK_MultiUser_filepaths;
  END get_ECMSDK_user_files_dec;

  -- The function splits the full file path (separated by the forward slash in backslash (\) in WinNT
  -- platform and can be modified to backslash (/) for Unix platform(s), querying the folder id
  -- starting from the root folder until it reaches the file, against the metadata table in ECMSDK.
  -- It then queries the metadata table for the file id and returns it.
  FUNCTION split(p_filepath VARCHAR2) RETURN INTEGER IS
  v_delimeter       VARCHAR2(2) := '\';             -- forward slash for UNIX filepaths
  delimeter_pos     PLS_INTEGER;                    -- position of delimeter ('\')
  l_list            VARCHAR2(32767) := p_filepath;  --
  v_id              INTEGER;
  top_id            INTEGER;
  root_id           INTEGER;
  currentdirectory  VARCHAR2(32767);
  BEGIN
    SELECT id INTO root_id FROM ecmsdk.odm_publicobject WHERE name = 'Root Folder';
    top_id := root_id;
    LOOP
      delimeter_pos := instr(l_list, v_delimeter);  -- returns the position of back slash, if any
      IF delimeter_pos > 0 THEN                     -- if any filepaths
        currentdirectory := substr(l_list, 1, delimeter_pos - 1); -- compute each directory name
        -- compute directory id from directory name by extracting the string
        SELECT id INTO v_id FROM ecmsdk.ODM_PUBLICOBJECT  WHERE name = currentdirectory
          INTERSECT
            SELECT rightobject FROM ecmsdk.ODM_RELATIONSHIP WHERE leftobject = top_id;
        l_list := substr(l_list, delimeter_pos + length(v_delimeter)); -- original filepath is shortened
      ELSE -- if no directories are left meaning only the filename is left from the original filepath
        currentdirectory := l_list; -- compute file id from filename
        SELECT id INTO v_id FROM ecmsdk.ODM_PUBLICOBJECT  WHERE name = currentdirectory
          INTERSECT
            SELECT rightobject FROM ecmsdk.ODM_RELATIONSHIP WHERE leftobject = top_id;
        EXIT;
      END IF;
      top_id := v_id;
    END LOOP;
    RETURN v_id; -- return fileid
  END split;
-- This procedure uses the fileid parametsr to find the exact temporary LOB locator which is stored in         
-- place of the original permanent LOB in the IFS LOB tables. This locator is then passed to the encrypt    
-- procedure eventually so that the file data can be encrypted using the LOB segment which exists in the    
-- temporary tablespace
  PROCEDURE encrypt_User_Specific_file (file_id IN INTEGER, enc_key IN VARCHAR,v_userid IN INTEGER, decrypted IN BOOLEAN) IS
  blob_original                 BLOB;                     -- the original bobl in ECMSDK tables
  v_media                       INTEGER := 0;
  BEGIN
  	-- find the location of the temporary LOB. The original LOB locator has been replaced with these                     	-- temporary Lobs
     IF (decrypted = FALSE) THEN   -- file is new then take the file locator from the original ECMSDK table
      SELECT media INTO v_media FROM ecmsdk.odm_contentobject WHERE ecmsdk.odm_contentobject.id = (file_id + 1);
      IF (v_media = 4529) THEN -- if its not a document, but a spatial file that is stored in the contentvault table
        SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault WHERE ecmsdk.odmm_contentvault.id = (file_id + 2);        
      -- ELSE
      --  SELECT nonindexedblob2 INTO blob_original FROM ecmsdk.odmm_nonindexedstore WHERE ecmsdk.odmm_nonindexedstore.id = (file_id + 2);
      END IF;
     ELSE -- file has been decrypted then LOB locator needs to be retrieved from table for encryption back
      SELECT templob INTO blob_original FROM sys.ecmsdk_user_temp_lobs WHERE ECMSDK_user_id = v_userid AND ECMSDK_file_id = file_id;
    END IF;
    -- pass fileid for encryption
    encrypt(file_id+1, enc_key,blob_original);
    IF (decrypted = TRUE) THEN   -- If file was decrypted then, delete its entry from table
      DELETE FROM ECMSDK_user_temp_lobs WHERE ECMSDK_user_id = v_userid AND ECMSDK_file_id = file_id;
      COMMIT;
    END IF;
  END encrypt_User_Specific_file;
  
-- This procedure usess the fileid parametsr to find the exact temporary LOB locator which is stored in       
-- place of the permanent LOB in the ECMSDK LOB tables. This locator is then passed to the encrypt procedure        
-- eventually so that the file data can be encrypted using the LOB segment which exists in the temporary  tablespace
  PROCEDURE decrypt_User_Specific_file (file_id IN INTEGER, dec_key IN VARCHAR,v_userid IN INTEGER) IS
  v_media                      INTEGER := 0;
  blob_original                BLOB;                     --temporary blob
  BEGIN
    SELECT media INTO v_media FROM ecmsdk.odm_contentobject WHERE ecmsdk.odm_contentobject.id = file_id;
    IF (v_media = 4529) THEN
        SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault WHERE ecmsdk.odmm_contentvault.id = (file_id + 1);        
    -- ELSE
    --    SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_nonindexedstore WHERE ecmsdk.odmm_nonindexedstore.id = (file_id + 1);
    END IF; 
    decrypt (file_id, dec_key);
    -- store the original blob location in database table for use during encryption
    UPDATE ECMSDK_user_temp_lobs SET templob = blob_original WHERE ECMSDK_user_id = v_userid AND ECMSDK_file_id = (file_id -1);
    COMMIT;
  END decrypt_User_Specific_file;
  
-- The encrypt procedure for both the user-specific and multi-user files. The ECMSDK fileid  and location of    
-- original LOB is passed as parameter
  PROCEDURE encrypt (file_id IN INTEGER, enc_key IN VARCHAR, original_blob IN BLOB) IS
  v_data_buffer_cache_threshold INTEGER := 33554432; -- configurable data buffer cache size: currently 32Mb
  v_IO_readwrite_chunksize      BINARY_INTEGER := 32760; -- maximum data storage size allowed by PL/SQL
  cipher_block_size             INTEGER := 8;
  blob_original                 BLOB    := original_blob; -- the original blob in ECMSDK tables
  blob_temporary                BLOB;                     -- temporary blobs
  v_file_id                     INTEGER := file_id; -- ECMSDK file's id
  Pos                           INTEGER := 1;
  i                             INTEGER := 1;
  lower                         INTEGER := 1;
  j                             INTEGER := 1;
  low                           INTEGER := 1;
  loops_done                    INTEGER := 0;
  loops_left_to_do              INTEGER := 0;
  loops_to_do_now               INTEGER := 0;
  v_media                       INTEGER := 0;
  v_blob_length                 INTEGER;    -- for computing encryption information such as number of loops
  v_total_IO_readwrites         INTEGER;    -- total number of I/O readwrites
  v_threshold_loops             INTEGER;    -- number of loops per buffer cache threshold
  v_readwrites_per_threshold    INTEGER;    -- number of read-writes per buffer cache threshold
  v_reminder                    INTEGER;
  v_reminder_io_readwrites      INTEGER;
  v_counter_readwrites          INTEGER;
  leftover_bytes                INTEGER;
  pad_amount                    INTEGER := 0;  -- number of bytes to pad in order to encrypt entire file
  v_enc_key_string              VARCHAR2(50) := enc_key;
  raw_enc_key                   RAW(128) := UTL_RAW.CAST_TO_RAW(v_enc_key_string);
  raw_input                     RAW(32760); 
  encrypted_raw                 RAW(32760);
  start_time                    NUMBER(20, 10); -- needed to compute time taken for encryption of a file
  time_taken                    NUMBER(20, 10); -- time taken for encryption of a file
  padded                        BOOLEAN := FALSE; -- keep track if file has been padded for unpadding later
  temp_id                       INTEGER;

  BEGIN
   SELECT to_number(to_char(CURRENT_TIMESTAMP, 'SSSSSxFF')) INTO start_time FROM dual; -- set start time

    -- determine in which ECMSDK table, file is stored, indexble table or nonindexble table
    SELECT media INTO v_media FROM ecmsdk.odm_contentobject WHERE ecmsdk.odm_contentobject.id = v_file_id;
    IF (v_media = 2061) THEN -- If file is stored in the nonindexed table
        SELECT defaultblobmedia INTO blob_temporary FROM ecmsdk.odmm_contentvault
          WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1);
      DBMS_LOB.OPEN(blob_temporary, DBMS_LOB.LOB_READONLY); -- Compute file length for encryption processing
      v_blob_length := DBMS_LOB.GETLENGTH(blob_temporary);
      DBMS_LOB.CLOSE(blob_temporary);

      -- pad file if not multiple of cipher block size
      leftover_bytes := MOD(v_blob_length, cipher_block_size);
      IF (leftover_bytes <> 0) THEN
        pad_amount := cipher_block_size - leftover_bytes;
        pad(v_file_id, v_media, pad_amount);
        padded := TRUE;
      END IF;

      -- compute encryption processing information
      v_total_IO_readwrites := v_blob_length / v_IO_readwrite_chunksize;
      v_reminder := MOD(v_blob_length, v_IO_readwrite_chunksize);
      v_threshold_loops := v_blob_length / v_data_buffer_cache_threshold;

      IF v_threshold_loops < 1 THEN -- If filesize smaller than data_buffer_cache size
        SELECT defaultblobmedia INTO blob_temporary FROM ecmsdk.odmm_contentvault
          WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
        -- Open, Split and Encrypt
        -- if filesize is less than 'v_IO_readwrite_chunksize', read all data in 1 read
        IF v_total_IO_readwrites < 1 THEN
          dbms_lob.read(blob_temporary, v_IO_readwrite_chunksize, Pos, raw_input);
          --encrypted_raw  := f_crypto(v_enc_key_string , raw_input);     -- New encryption algorithm
          dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
          --encrypted_raw := dbms_crypto.encrypt( raw_input,encryption_type, raw_enc_key);
          dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypted_raw);
        ELSE -- if filesize is more than 32 kb, encrypt/decrypt data in loops
          FOR i IN lower .. v_total_IO_readwrites LOOP
            -- even if size is less than I/O amount, it is read all at once because of ceiling function
            dbms_lob.read(blob_temporary, v_IO_readwrite_chunksize, Pos, raw_input);
            --encrypted_raw  := f_crypto(v_enc_key_string , raw_input);     -- Custom encryption algorithm
            dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
            --encrypted_raw := dbms_crypto.encrypt( raw_input,encryption_type, raw_enc_key);
            dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypted_raw);
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          COMMIT;
        END IF;
      ELSE -- If filesize equal to or larger than data_buffer_cache size
        v_readwrites_per_threshold := (v_data_buffer_cache_threshold / v_IO_readwrite_chunksize);
        FOR j IN low .. v_threshold_loops LOOP
          SELECT defaultblobmedia INTO blob_temporary FROM ecmsdk.odmm_contentvault
            WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
          loops_left_to_do := v_total_IO_readwrites - loops_done;
          IF(loops_left_to_do >= v_readwrites_per_threshold) THEN
            loops_to_do_now := v_readwrites_per_threshold;
          ELSE
            loops_to_do_now := loops_left_to_do;
          END IF;
          FOR i IN lower .. loops_to_do_now LOOP
            -- even if size is less than I/O amount, it is read in because of ceiling function
            dbms_lob.read(blob_temporary, v_IO_readwrite_chunksize, Pos, raw_input);
            dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
            --encrypted_raw  := f_crypto(v_enc_key_string , raw_input);  -- new encryption algorithm
            --encrypted_raw := dbms_crypto.encrypt( raw_input,encryption_type, raw_enc_key);
            dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypted_raw);
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          loops_done := loops_done + loops_to_do_now;

          DBMS_LOB.CLOSE (blob_temporary);
          DBMS_LOB.CLOSE (blob_original);
          COMMIT;
        END LOOP;
      END IF;
      IF (padded) THEN  -- if file was padded the remove padding
        unpad(v_file_id, v_media, v_blob_length);
      END IF;
      -- point the LOB back to the original blob
      UPDATE ecmsdk.odmm_contentvault SET defaultblobmedia = blob_original WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1);
    ELSE
      -- Encryption for files which can be indexed; stored in the contentstore table
      SELECT defaultblobmedia INTO blob_temporary FROM ecmsdk.odmm_contentvault
        WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1);
      DBMS_LOB.OPEN(blob_temporary, DBMS_LOB.LOB_READONLY); --Compute information for encryption processing
      v_blob_length := DBMS_LOB.GETLENGTH(blob_temporary);
      DBMS_LOB.CLOSE(blob_temporary);

      -- pad file if not multiple of cipher block size
      leftover_bytes := MOD(v_blob_length, cipher_block_size);
      IF (leftover_bytes <> 0) THEN
        pad_amount := cipher_block_size - leftover_bytes;
        pad(v_file_id, v_media, pad_amount);
        padded := TRUE;
      END IF;

      v_total_IO_readwrites := v_blob_length / v_IO_readwrite_chunksize;
      v_reminder := MOD(v_blob_length, v_IO_readwrite_chunksize);
      v_threshold_loops := v_blob_length / v_data_buffer_cache_threshold;
      IF v_threshold_loops < 1 THEN --If filesize smaller than data_buffer_cache size
        SELECT defaultblobmedia INTO blob_temporary FROM ecmsdk.odmm_contentvault
          WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
        -- if filesize is less than 'v_IO_readwrite_chunksize', read all data in one read
        IF v_total_IO_readwrites < 1 THEN
          dbms_lob.read(blob_temporary, v_IO_readwrite_chunksize, Pos, raw_input);
          --encrypted_raw  := f_crypto(v_enc_key_string , raw_input);  -- new encryption algorithm
          dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
          --encrypted_raw := dbms_crypto.encrypt( raw_input,encryption_type, raw_enc_key);
          dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypted_raw);
        ELSE -- if filesize is more than 32 kb, encrypt/decrypt data in loops
          FOR i IN lower .. v_total_IO_readwrites LOOP
            -- even if size is less than I/O amount, it is read in because of ceiling function
            dbms_lob.read(blob_temporary, v_IO_readwrite_chunksize, Pos, raw_input);
            --encrypted_raw  := f_crypto(v_enc_key_string , raw_input);  -- new encryption algorithm
            dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
            --encrypted_raw := dbms_crypto.encrypt( raw_input,encryption_type, raw_enc_key);
            dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypted_raw);
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          COMMIT;
        END IF;
      ELSE -- If filesize equal to or larger than db_cache size; open, encrypt, close BLOB in loops
        FOR j IN low .. v_threshold_loops LOOP
          SELECT defaultblobmedia INTO blob_temporary FROM ecmsdk.odmm_contentvault
            WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
          loops_left_to_do := v_total_IO_readwrites - loops_done;
          IF(loops_left_to_do >= v_readwrites_per_threshold) THEN
            loops_to_do_now := v_readwrites_per_threshold;
          ELSE
            loops_to_do_now := loops_left_to_do;
          END IF;
          FOR i IN lower .. loops_to_do_now LOOP
            -- even if size is less than I/O amount, it is read in because of ceiling function
            dbms_lob.read(blob_temporary, v_IO_readwrite_chunksize, Pos, raw_input);
            --encrypted_raw  := f_crypto(v_enc_key_string , raw_input);  -- new encryption algorithm
            dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
            --encrypted_raw := dbms_crypto.encrypt( raw_input,encryption_type, raw_enc_key);
            dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypted_raw);
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          loops_done := loops_done + loops_to_do_now;
          DBMS_LOB.CLOSE (blob_temporary);
          DBMS_LOB.CLOSE (blob_original);
         COMMIT; -- write modified data to disk so that new data from large file can be read into buffer
        END LOOP;
      END IF;
      IF (padded) THEN  -- if file was padded the remove padding
        unpad(v_file_id, v_media, v_blob_length);
      END IF;
    -- point back to the original blob
    UPDATE ecmsdk.odmm_contentvault SET defaultblobmedia = blob_original WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1);
    END IF;
    time_taken := (to_number(to_char(CURRENT_TIMESTAMP, 'SSSSSxFF')) - start_time);
    dbms_output.put_line('TIME TAKEN > ' || time_taken);
    DBMS_LOB.FREETEMPORARY (blob_temporary); -- free the temporary lobs created during the session
    COMMIT;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('File not found in query ');
  END encrypt;

-- This procedure is used to copy blob content for user-speciifc decrypted files which were marked for       
-- decryption but were not marked for encryption by the use before logoff. The IFS fileid and location of    
-- original LOB is passed as parameters
  PROCEDURE blob_copy (file_id IN INTEGER, enc_key IN VARCHAR, v_userid IN INTEGER) IS
  v_data_buffer_cache_threshold INTEGER := 33554432; -- configurable data buffer cache size: currently 32Mb
  v_IO_readwrite_chunksize      BINARY_INTEGER := 32760; -- maximum data storage size allowed by PL/SQL
  blob_original                 BLOB;                    -- the original bobl in ECMSDK tables
  blob_temporary                BLOB;                    -- temporary blobs
  v_file_id                     INTEGER := file_id; 	   -- ECMSDK file's id
  Pos                           INTEGER := 1;
  i                             INTEGER := 1;
  lower                         INTEGER := 1;
  j                             INTEGER := 1;
  low                           INTEGER := 1;
  loops_done                    INTEGER := 0;
  loops_left_to_do              INTEGER := 0;
  loops_to_do_now               INTEGER := 0;
  v_media                       INTEGER := 0;
  v_blob_length                 INTEGER;    -- For computing encryption information such as number of loops
  v_total_IO_readwrites         INTEGER;    -- total number of I/O readwrites
  v_threshold_loops             INTEGER;    -- number of loops per buffer cache threshold
  v_readwrites_per_threshold    INTEGER;    -- number of read-writes per buffer cache threshold
  v_reminder                    INTEGER;
  v_reminder_io_readwrites      INTEGER;
  v_counter_readwrites          INTEGER;
  leftover_bytes                INTEGER;
  raw_input                     RAW(32760);
  start_time                    NUMBER(20, 10); -- needed to compute time taken for encryption of a file
  time_taken                    NUMBER(20, 10); -- time taken for encryption of a file
  temp_id                       INTEGER;

  BEGIN
    -- determine in which ECMSDK table, file is stored, indexble table or nonindexble table
   SELECT templob INTO blob_original FROM sys.ecmsdk_user_temp_lobs WHERE ECMSDK_user_id = v_userid AND ECMSDK_file_id = file_id FOR UPDATE;
   SELECT media INTO v_media FROM ecmsdk.odm_contentobject WHERE ecmsdk.odm_contentobject.id = v_file_id +1;
   SELECT to_number(to_char(CURRENT_TIMESTAMP, 'SSSSSxFF')) INTO start_time FROM dual; -- set start time
   IF (v_media = 2061) THEN -- If file is stored in the nonindexed table
      SELECT defaultblobmedia INTO blob_temporary FROM ecmsdk.odmm_contentvault WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 2);
      DBMS_LOB.OPEN(blob_temporary, DBMS_LOB.LOB_READONLY); -- Compute file length for encryption            -- processing
      v_blob_length := DBMS_LOB.GETLENGTH(blob_temporary);
      DBMS_LOB.CLOSE(blob_temporary);
      -- compute processing information
      v_total_IO_readwrites := v_blob_length / v_IO_readwrite_chunksize;
      v_reminder := MOD(v_blob_length, v_IO_readwrite_chunksize);
      v_threshold_loops := v_blob_length / v_data_buffer_cache_threshold;

      IF v_threshold_loops < 1 THEN --If filesize smaller than data_buffer_cache size
        SELECT defaultblobmedia INTO blob_temporary FROM ecmsdk.odmm_contentvault
          WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 2) FOR UPDATE;
        -- Open, Split and Encrypt
        -- if filesize is less than 'v_IO_readwrite_chunksize', read all data in 1 read
        IF v_total_IO_readwrites < 1 THEN
          dbms_lob.read(blob_temporary, v_IO_readwrite_chunksize, Pos, raw_input);
          dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
        ELSE -- if filesize is more than 32 kb, encrypt/decrypt data in loops
          FOR i IN lower .. v_total_IO_readwrites LOOP
            -- even if size is less than I/O amount, it is read all at once because of ceiling function
            dbms_lob.read(blob_temporary, v_IO_readwrite_chunksize, Pos, raw_input);
            dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          COMMIT;

        END IF;
      ELSE -- If filesize equal to or larger than data_buffer_cache size
        v_readwrites_per_threshold := (v_data_buffer_cache_threshold / v_IO_readwrite_chunksize);
        FOR j IN low .. v_threshold_loops LOOP
          SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault
            WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
          loops_left_to_do := v_total_IO_readwrites - loops_done;
          IF(loops_left_to_do >= v_readwrites_per_threshold) THEN
            loops_to_do_now := v_readwrites_per_threshold;
          ELSE
            loops_to_do_now := loops_left_to_do;
          END IF;
          FOR i IN lower .. loops_to_do_now LOOP
            -- even if size is less than I/O amount, it is read in because of ceiling function
            dbms_lob.read(blob_temporary, v_IO_readwrite_chunksize, Pos, raw_input);
            dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          loops_done := loops_done + loops_to_do_now;
          DBMS_LOB.CLOSE (blob_temporary);
          DBMS_LOB.CLOSE (blob_original);
          COMMIT;
        END LOOP;
      END IF;
      -- point back to the original blob after blob copy
      UPDATE ecmsdk.odmm_contentvault SET defaultblobmedia = blob_original WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1);

    ELSE -- Encryption for files which can be indexed; stored in the contentstore table
      SELECT defaultblobmedia INTO blob_temporary FROM ecmsdk.odmm_contentvault
        WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1);
      DBMS_LOB.OPEN(blob_temporary, DBMS_LOB.LOB_READONLY); --Compute information for encryption processing
      v_blob_length := DBMS_LOB.GETLENGTH(blob_temporary);
      DBMS_LOB.CLOSE(blob_temporary);

      v_total_IO_readwrites := v_blob_length / v_IO_readwrite_chunksize;
      v_reminder := MOD(v_blob_length, v_IO_readwrite_chunksize);
      v_threshold_loops := v_blob_length / v_data_buffer_cache_threshold;
      IF v_threshold_loops < 1 THEN --If filesize smaller than data_buffer_cache size
        SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault
          WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
        -- if filesize is less than 'v_IO_readwrite_chunksize', read all data in one read
        IF v_total_IO_readwrites < 1 THEN
          dbms_lob.read(blob_temporary, v_IO_readwrite_chunksize, Pos, raw_input);
          dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
        ELSE -- if filesize is more than 32 kb, encrypt/decrypt data in loops
          FOR i IN lower .. v_total_IO_readwrites LOOP
            -- even if size is less than I/O amount, it is read in because of ceiling function
            dbms_lob.read(blob_temporary, v_IO_readwrite_chunksize, Pos, raw_input);
            dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          COMMIT;
        END IF;
      ELSE -- If filesize equal to or larger than db_cache size; open, encrypt, close BLOB in loops
        FOR j IN low .. v_threshold_loops LOOP
          SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault
            WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
          loops_left_to_do := v_total_IO_readwrites - loops_done;
          IF(loops_left_to_do >= v_readwrites_per_threshold) THEN
            loops_to_do_now := v_readwrites_per_threshold;
          ELSE
            loops_to_do_now := loops_left_to_do;
          END IF;
          FOR i IN lower .. loops_to_do_now LOOP
            -- even if size is less than I/O amount, it is read in because of ceiling function
            dbms_lob.read(blob_temporary, v_IO_readwrite_chunksize, Pos, raw_input);
            dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          loops_done := loops_done + loops_to_do_now;
         DBMS_LOB.CLOSE (blob_temporary);
         DBMS_LOB.CLOSE (blob_original);
         COMMIT; -- write modified data to disk so that new data from large file can be read into buffer
        END LOOP;
      END IF;
      -- point back to the original blob
      UPDATE ecmsdk.odmm_contentvault SET defaultblobmedia = blob_original WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1);
    END IF;
    time_taken := (to_number(to_char(CURRENT_TIMESTAMP, 'SSSSSxFF')) - start_time);
    dbms_output.put_line('TIME TAKEN > ' || time_taken);

  DBMS_LOB.FREETEMPORARY (blob_temporary); -- free the temporary lobs created during the session
  DELETE FROM ECMSDK_user_temp_lobs WHERE ECMSDK_user_id = v_userid AND ECMSDK_file_id = v_file_id;
  COMMIT;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('File not found in query ');
  END blob_copy;

-- This procedure is used to decrypt blob content for user-speciifc as well as multi-user files which were 
-- marked for decryption. The ECMSDK fileid and location of original LOB is passed as parameters
  PROCEDURE decrypt (file_id IN INTEGER, dec_key IN VARCHAR) IS
  v_data_buffer_cache_threshold INTEGER := 33554432; -- configurable data buffer cache size currently 32 Mb
  v_IO_readwrite_chunksize      BINARY_INTEGER := 1000; -- maximum data storage size allowed by PL/SQL
  cipher_block_size             INTEGER := 8;
  blob_original                 BLOB;
  blob_temporary                BLOB;
  v_file_id                     INTEGER := file_id; -- file id
  Pos                           INTEGER := 1;
  i                             INTEGER := 1;
  lower                         INTEGER := 1;
  j                             INTEGER := 1;
  low                           INTEGER := 1;
  loops_done                    INTEGER := 0;
  loops_left_to_do              INTEGER := 0;
  loops_to_do_now               INTEGER := 0;
  v_media                       INTEGER := 0;
  pad_amount                    INTEGER := 0;
  v_blob_length                 INTEGER;
  v_total_IO_readwrites         INTEGER;
  v_threshold_loops             INTEGER;
  v_readwrites_per_threshold    INTEGER;
  v_reminder                    INTEGER;
  v_reminder_io_readwrites      INTEGER;
  v_counter_readwrites          INTEGER;
  leftover_bytes                INTEGER;
  v_dec_key_string              VARCHAR2(50) := dec_key;
  raw_dec_key                   RAW(128) := UTL_RAW.CAST_TO_RAW(v_dec_key_string);
  raw_input                     RAW(1000);
  decrypted_raw                 RAW(32760);
  start_time                    NUMBER(20, 10);
  time_taken                    NUMBER(20, 10);
  padded                        BOOLEAN := FALSE; -- keep track if file has been padded for unpadding later

  BEGIN
    SELECT media INTO v_media FROM ecmsdk.odm_contentobject WHERE ecmsdk.odm_contentobject.id = v_file_id;
    SELECT to_number (to_char(CURRENT_TIMESTAMP, 'SSSSSxFF')) INTO start_time FROM dual;

    -- Create a temporary blob
    dbms_lob.createtemporary(blob_temporary, TRUE);

    IF (v_media = 4529) THEN -- If file is stored in the nonindexed table
      SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault
        WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1);
      DBMS_LOB.OPEN(blob_original, DBMS_LOB.LOB_READONLY); --Compute information for encryption processing
      v_blob_length := DBMS_LOB.GETLENGTH(blob_original);
      DBMS_LOB.CLOSE(blob_original);

      leftover_bytes := MOD(v_blob_length, cipher_block_size); -- pad if not multiple of cipher block size
      IF (leftover_bytes <> 0) THEN
        pad_amount := cipher_block_size - leftover_bytes;
        pad(v_file_id, v_media, pad_amount);
        padded := TRUE;
      END IF;

      v_total_IO_readwrites := v_blob_length / v_IO_readwrite_chunksize;
      v_reminder := MOD(v_blob_length, v_IO_readwrite_chunksize);
      v_threshold_loops := v_blob_length / v_data_buffer_cache_threshold;

      IF v_threshold_loops < 1 THEN --If filesize smaller than data_buffer_cache size
        SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault
          WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
        -- Open, Split and Encrypt
        -- if filesize is less than 'v_IO_readwrite_chunksize', read all data in 1 read
        IF v_total_IO_readwrites < 1 THEN
          dbms_lob.read(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
          --decrypted_raw := f_crypto_dec(v_dec_key_string , raw_input);  -- new algorithm decryption
          dbms_obfuscation_toolkit.DES3Decrypt(input => raw_input, key => raw_dec_key, decrypted_data => decrypted_raw );
          --decrypted_raw := dbms_crypto.decrypt ( raw_input,encryption_type, raw_dec_key);
          dbms_lob.WRITE(blob_temporary, v_IO_readwrite_chunksize, Pos, decrypted_raw);
        ELSE -- if filesize is more than 32 kb, encrypt/decrypt data in loops
          FOR i IN lower .. v_total_IO_readwrites LOOP
            dbms_lob.read(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
            --decrypted_raw := f_crypto_dec(v_dec_key_string , raw_input);  -- new algorithm decryption
            dbms_obfuscation_toolkit.DES3Decrypt(input => raw_input, key => raw_dec_key, decrypted_data => decrypted_raw );
            --decrypted_raw := dbms_crypto.decrypt ( raw_input,encryption_type, raw_dec_key);
            dbms_lob.WRITE(blob_temporary, v_IO_readwrite_chunksize, Pos, decrypted_raw);
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          COMMIT;
        END IF;
      ELSE -- If filesize equal to or larger than data_buffer_cache size
        v_readwrites_per_threshold := (v_data_buffer_cache_threshold / v_IO_readwrite_chunksize);
        FOR j IN low .. v_threshold_loops LOOP
          SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault
            WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
          loops_left_to_do := v_total_IO_readwrites - loops_done;
          IF(loops_left_to_do >= v_readwrites_per_threshold) THEN
            loops_to_do_now := v_readwrites_per_threshold;
          ELSE
            loops_to_do_now := loops_left_to_do;
          END IF;
          FOR i IN lower .. loops_to_do_now LOOP
            dbms_lob.read(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
            --decrypted_raw := f_crypto_dec(v_dec_key_string , raw_input);  -- new algorithm decryption
            dbms_obfuscation_toolkit.DES3Decrypt(input => raw_input, key => raw_dec_key, decrypted_data => decrypted_raw );
            --decrypted_raw := dbms_crypto.decrypt ( raw_input,encryption_type, raw_dec_key);
            dbms_lob.WRITE(blob_temporary, v_IO_readwrite_chunksize, Pos, decrypted_raw);
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          loops_done := loops_done + loops_to_do_now;
          DBMS_LOB.CLOSE (blob_original);
          COMMIT;
        END LOOP;
      END IF;
      IF (padded) THEN -- if file was padded the remove padding
        unpad(v_file_id, v_media, v_blob_length);
      END IF;
      -- point to the temporary blob so that end-users can access and work with the decrypted blob
      UPDATE ecmsdk.odmm_contentvault SET defaultblobmedia = blob_temporary WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1);

    ELSE -- If file is stored in the contentstore table
      SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault
        WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1);
      DBMS_LOB.OPEN(blob_original, DBMS_LOB.LOB_READONLY); --Compute information for encryption processing
      v_blob_length := DBMS_LOB.GETLENGTH(blob_original);
      DBMS_LOB.CLOSE(blob_original);
      -- pad file if not multiple of cipher block size
      leftover_bytes := MOD(v_blob_length, cipher_block_size);
      IF (leftover_bytes <> 0) THEN
        pad_amount := cipher_block_size - leftover_bytes;
        pad(v_file_id, v_media, pad_amount);
        padded := TRUE;
      END IF;

      v_total_IO_readwrites := v_blob_length / v_IO_readwrite_chunksize;
      v_reminder := MOD(v_blob_length, v_IO_readwrite_chunksize);
      v_threshold_loops := v_blob_length / v_data_buffer_cache_threshold;
      IF v_threshold_loops < 1 THEN --If filesize smaller than data_buffer_cache size
        SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault
          WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
        -- Open, Split and Encrypt
        -- if filesize is less than 'v_IO_readwrite_chunksize', read all data in 1 read
        IF v_total_IO_readwrites < 1 THEN
          dbms_lob.read(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
          --decrypted_raw := f_crypto_dec(v_dec_key_string , raw_input);  -- new algorithm decryption
          dbms_obfuscation_toolkit.DES3Decrypt(input => raw_input, key => raw_dec_key, decrypted_data => decrypted_raw );
          --decrypted_raw := dbms_crypto.decrypt ( raw_input,encryption_type, raw_dec_key);
          dbms_lob.WRITE(blob_temporary, v_IO_readwrite_chunksize, Pos, decrypted_raw);
        ELSE -- if filesize is more than 32 kb, encrypt/decrypt data in loops
          FOR i IN lower .. v_total_IO_readwrites LOOP
            dbms_lob.read(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
            --decrypted_raw := f_crypto_dec(v_dec_key_string , raw_input);  -- new algorithm decryption
            dbms_obfuscation_toolkit.DES3Decrypt(input => raw_input, key => raw_dec_key, decrypted_data => decrypted_raw );
            --decrypted_raw := dbms_crypto.decrypt ( raw_input,encryption_type, raw_dec_key);
            dbms_lob.WRITE(blob_temporary, v_IO_readwrite_chunksize, Pos, decrypted_raw);
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          COMMIT;
        END IF;
      ELSE -- If filesize equal to or larger than data_buffer_cache size
        FOR j IN low .. v_threshold_loops LOOP
          SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault
            WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1);
          loops_left_to_do := v_total_IO_readwrites - loops_done;
          IF(loops_left_to_do >= v_readwrites_per_threshold) THEN
            loops_to_do_now := v_readwrites_per_threshold;
          ELSE
            loops_to_do_now := loops_left_to_do;
          END IF;
          FOR i IN lower .. loops_to_do_now LOOP
            dbms_lob.read(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
            --decrypted_raw := f_crypto_dec(v_dec_key_string , raw_input);  -- new algorithm decryption
            dbms_obfuscation_toolkit.DES3Decrypt(input => raw_input, key => raw_dec_key, decrypted_data => decrypted_raw );
            --decrypted_raw := dbms_crypto.decrypt ( raw_input,encryption_type, raw_dec_key);
            dbms_lob.WRITE(blob_temporary, v_IO_readwrite_chunksize, Pos, decrypted_raw);
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          loops_done := loops_done + loops_to_do_now;
          DBMS_LOB.CLOSE (blob_original);
          COMMIT;
        END LOOP;
      END IF;
      IF (padded) THEN  -- if file was padded then remove padding
        unpad(v_file_id, v_media, v_blob_length);
      END IF;
      -- point to the temporary blob so that end-users can acess and work with the decrypted blob
      UPDATE ecmsdk.odmm_contentvault SET defaultblobmedia = blob_temporary WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1);
    END IF;
    time_taken := (to_number(to_char(CURRENT_TIMESTAMP, 'SSSSSxFF')) - start_time);
    dbms_output.put_line('TIME TAKEN > ' || time_taken);
  COMMIT;
  DBMS_LOB.CLOSE (blob_temporary);
  DBMS_LOB.CLOSE (blob_original);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('File not found in query ');
  END decrypt;

  -- This procedure pads the files which are not multiple of cipher block size
  PROCEDURE pad (v_file_id IN INTEGER, v_media IN INTEGER, v_pad_amount IN INTEGER) IS
  pad_data        RAW(8) := '12345678901234'; -- pad data
  blob_locator    BLOB;
  v_blob_length   INTEGER;
  BEGIN  -- currently for both we refer to the same table
    IF (v_media = 4529) THEN  -- if file is nonindexble and therefore stored in odmm_nonindexedstore table
      SELECT defaultblobmedia INTO blob_locator FROM ecmsdk.odmm_contentvault
        WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
      pad_data := SUBSTR(pad_data, 0, 2 * v_pad_amount);
      DBMS_LOB.WRITEAPPEND(blob_locator, v_pad_amount, pad_data); -- append bytes at the end of blob
      COMMIT;
    ELSE                      -- if file is indexble and therefore stored in odmm_contentstore table
      SELECT defaultblobmedia INTO blob_locator FROM ecmsdk.odmm_contentvault
        WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
      pad_data := SUBSTR(pad_data, 0, 2 * v_pad_amount);
      DBMS_LOB.WRITEAPPEND(blob_locator, v_pad_amount, pad_data); -- append bytes at the end of blob
      COMMIT;
    END IF;
  END pad;

  -- This procedure unpads the padded bytes in files which are not multiple of cipher block size
  PROCEDURE unpad(v_file_id IN INTEGER, v_media IN INTEGER, v_original_length IN INTEGER) IS
  blob_locator BLOB;
  v_blob_length INTEGER;
  BEGIN
    IF (v_media = 1625) THEN  -- if file is nonindexble and therefore stored in odmm_nonindexedstore table
      SELECT defaultblobmedia INTO blob_locator FROM ecmsdk.odmm_contentvault
        WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
      v_blob_length := DBMS_LOB.GETLENGTH(blob_locator);
      DBMS_LOB.TRIM(blob_locator, v_original_length);           -- trim padded bytes from the end of blob
      COMMIT;
    ELSE                      -- if file is indexble and therefore stored in odmm_contentstore table
      SELECT defaultblobmedia INTO blob_locator FROM ecmsdk.odmm_contentvault
        WHERE ecmsdk.odmm_contentvault.id = (v_file_id + 1) FOR UPDATE;
      v_blob_length := DBMS_LOB.GETLENGTH(blob_locator);
      DBMS_LOB.TRIM(blob_locator, v_original_length);           -- trim padded bytes from the end of blob
      COMMIT;
    END IF;
  END unpad;

  -- This procedure decrypts, change keys and encrypt single user-owned files back with new keys
  PROCEDURE change_user_specific_keys (userid IN INTEGER, new_enc_key IN VARCHAR, new_dec_key IN VARCHAR) IS
  v_userid        INTEGER := userid;
  v_sessions      NUMBER;
  v_dec_key       VARCHAR(100);    --  user-specific decryption key
  v_file_dec_key  VARCHAR(50);     --  file-specific decryption key
  v_fileid        INTEGER;         -- store ECMSDK file_id computed from ECMSDK filepath
  CURSOR active_ECMSDK_user_sessions IS
    SELECT USERID FROM ecmsdk.ODMZ_SESSION WHERE USERID = v_userid;
  CURSOR ECMSDK_US_Files IS
    SELECT name, id FROM ecmsdk.odm_publicobject WHERE owner = v_userid AND (name LIKE '%.enc');
  ECMSDK_USF_record ECMSDK_US_Files%ROWTYPE;
  BEGIN
    OPEN active_ECMSDK_user_sessions;
    FETCH active_ECMSDK_user_sessions INTO v_sessions; -- Only if no existing sessions of this user then        -- decrypt or encrypt
    IF active_ECMSDK_user_sessions%NOTFOUND THEN
      v_dec_key := get_dec_key (v_userid);
      OPEN ECMSDK_US_Files;
      LOOP                 -- decrypt, change keys and encrypt single user-owned files back with new keys
        FETCH ECMSDK_US_Files INTO ECMSDK_USF_record;
        EXIT WHEN ECMSDK_US_Files%NOTFOUND;
          decrypt (ECMSDK_USF_record.id + 1, v_dec_key);    -- decrypt with old decryption keys
          DELETE FROM ECMSDK_USF_keys WHERE ECMSDK_user_id = v_userid;
          INSERT INTO ECMSDK_USF_keys (ECMSDK_user_id, enc_key, dec_key) VALUES (v_userid, new_enc_key, new_dec_key);
          encrypt_User_Specific_file (ECMSDK_USF_record.id + 1, new_enc_key, v_userid, false);
      END LOOP;
      CLOSE ECMSDK_US_Files;
    ELSE
      dbms_output.put_line('User ' || userid ||' has active session');
    END IF;
    CLOSE active_ECMSDK_user_sessions;
  END change_user_specific_keys;

  -- This procedure is for spatial/DBA administrator for initial encryption of multi-user spatial file
  PROCEDURE encrypt_Multi_user_file_init (v_filepath IN VARCHAR) IS
  v_file_enc_key  VARCHAR(100);
  v_fileid        INTEGER;
  blob_original   BLOB;                     -- the original blob in ECMSDK tables
  v_media         INTEGER := 0;
  BEGIN
        -- get encryption key for project-level multi-user access files
        v_file_enc_key := get_file_enc_key (v_filepath);
        dbms_output.put_line('File ' || v_filepath ||' is here sucessfully');
        v_fileid := split (v_filepath);
        dbms_output.put_line('File ' || v_filepath ||' is here sucessfully');
        -- find the location of the original blob
        SELECT media INTO v_media FROM ecmsdk.odm_contentobject WHERE ecmsdk.odm_contentobject.id = v_fileid + 1;
        IF (v_media = 4529) THEN
          SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault WHERE ecmsdk.odmm_contentvault.id = (v_fileid + 2);          
        -- ELSE
        --  SELECT nonindexedblob2 INTO blob_original FROM ecmsdk.odmm_nonindexedstore WHERE ecmsdk.odmm_nonindexedstore.id = (v_fileid + 2);
        END IF;
	  -- encrypt file, passing fileid and encryption key
        encrypt (v_fileid + 1, v_file_enc_key, blob_original);  
        -- update encrypted status of file
        UPDATE ECMSDK_MUF_keys_state  SET file_encrypted = 'TRUE'
          WHERE ECMSDK_filepath LIKE v_filepath;
        dbms_output.put_line('File ' || v_filepath ||' encrypted sucessfully');
  END encrypt_Multi_user_file_init;

  -- This procedure is called for encryption of multi-user files. The filepath is passed as parameter which
  -- is used to retrieve the temporary LOB segment from the ECMSDK tables
  PROCEDURE encrypt_Multi_user_file_sub (v_filepath IN VARCHAR) IS
  v_file_enc_key  VARCHAR(100);
  v_fileid        INTEGER;
  blob_original   BLOB;                     -- the original blob in ECMSDK tables
  v_media         INTEGER := 0;
  BEGIN
        -- get encryption key for project-level multi-user access files
        v_file_enc_key := get_file_enc_key (v_filepath);
        v_fileid := split (v_filepath);
        -- find the location of the original blob
        SELECT templob INTO blob_original FROM sys.ECMSDK_MUF_keys_state WHERE ECMSDK_filepath LIKE v_filepath;
        encrypt (v_fileid + 1, v_file_enc_key, blob_original);  -- encrypt file, passing fileid and encryption key
        -- update encrypted status of file
       UPDATE ECMSDK_MUF_keys_state SET file_encrypted = 'TRUE', templob =NULL WHERE ECMSDK_filepath LIKE v_filepath;
  END encrypt_Multi_user_file_sub;

-- This procedure is called upon user logon to the FSDB to decrypt multi-user files. The filepath is  
-- passed as parameter which is used to retrieve the temporary LOB segment from the ECMSDK tables
  PROCEDURE decrypt_Multi_user_file (v_filepath IN VARCHAR) IS
  v_file_dec_key  VARCHAR(100);
  v_fileid        INTEGER;
  blob_original   BLOB;                     -- the original blob in ECMSDK tables
  v_media         INTEGER := 0;
  BEGIN
        -- get encryption key for project-level multi-user access files
        v_file_dec_key := get_file_dec_key (v_filepath);
        v_fileid := split (v_filepath);
        -- find the location of the original blob
        SELECT media INTO v_media FROM ecmsdk.odm_contentobject WHERE ecmsdk.odm_contentobject.id = v_fileid + 1;
        IF (v_media = 4529) THEN
          SELECT defaultblobmedia INTO blob_original FROM ecmsdk.odmm_contentvault WHERE ecmsdk.odmm_contentvault.id = (v_fileid + 2);          
        -- ELSE
        --  SELECT nonindexedblob2 INTO blob_original FROM ecmsdk.odmm_nonindexedstore WHERE ecmsdk.odmm_nonindexedstore.id = (v_fileid + 2);
        END IF;
        decrypt (v_fileid + 1, v_file_dec_key);  -- decrypt file, passing fileid and decryption key
        -- update encrypted status of file
        UPDATE ECMSDK_MUF_keys_state  SET file_encrypted = 'FALSE', templob = blob_original
          WHERE ECMSDK_filepath LIKE v_filepath;
  END decrypt_Multi_user_file;

-- This procedure is for spatial/ DBA administrator for final decryption of multi-user spatial file
  PROCEDURE decrypt_Multi_user_file_final (v_filepath IN VARCHAR) IS
  v_file_dec_key  VARCHAR(100);
  v_fileid        INTEGER;
  BEGIN
        -- get encryption key for project-level multi-user access files
        v_file_dec_key := get_file_dec_key (v_filepath);
        v_fileid := split (v_filepath);
        decrypt (v_fileid + 1, v_file_dec_key);  -- decrypt file, passing fileid and decryption key
        -- update encrypted status of file
        UPDATE ECMSDK_MUF_keys_state  SET file_encrypted = 'FALSE' WHERE ECMSDK_filepath LIKE v_filepath;
        dbms_output.put_line('File ' || v_filepath ||' decrypted sucessfully');
  END decrypt_Multi_user_file_final;

-- This procedure is intended for spatial/ DBA administrator for changing encryption and decryption keys of 
-- multi-user spatial files
  PROCEDURE change_Multi_user_file_keys (v_filepath IN VARCHAR, new_enc_key IN VARCHAR, new_dec_key IN VARCHAR) IS
  v_file_enc_key  VARCHAR(100);
  v_file_dec_key  VARCHAR(100);
  v_fileid        INTEGER;
  in_use          BOOLEAN  := FALSE;

-- Check if multi-user file is in-use. If any user, who has priviledge on the multi-user file, has active   
-- sessions we assume that the file would be decrypted already. In that case, a message is displayed to the    
-- administrator.
  CURSOR in_session_files IS
    SELECT ECMSDK_filepath FROM sys.ECMSDK_MUF_user_catalog
      WHERE ECMSDK_user_id IN (SELECT userid FROM ecmsdk.odmz_session);
  in_session_files_record in_session_files%ROWTYPE;

  BEGIN
    OPEN in_session_files;
    LOOP
      FETCH in_session_files INTO in_session_files_record;
      EXIT WHEN in_session_files%NOTFOUND;
      IF (in_session_files_record.ECMSDK_filepath = v_filepath) THEN -- if file to be encrypted is decrypted
        in_use := TRUE;   -- set file is in-use
        dbms_output.put_line('Multi-user File ' || v_filepath ||' is in-use');
      END IF;
    END LOOP;
    CLOSE in_session_files; -- if users who should have access to that file have no active sessions

    IF (in_use = FALSE) THEN -- if file not in-use then encrypt back for protection
        decrypt_Multi_user_file (v_filepath);    -- decrypt project-level multi-user access file
        -- change encryption and decryption keys
        DELETE FROM ECMSDK_MUF_keys_state WHERE ECMSDK_filepath = v_filepath;
        INSERT INTO ECMSDK_MUF_keys_state (ECMSDK_filepath,enc_key,dec_key) VALUES (v_filepath,new_enc_key,new_dec_key);
-- encrypt project-level multi-user access file with new encryption key
        encrypt_Multi_user_file_sub (v_filepath);    
    END IF;
  END change_Multi_user_file_keys;
END ECMSDK_11g_spatial_crypt;
/ 
