-- CMSDK_spatial_crypt package specification
--CREATE OR REPLACE PACKAGE ECMSDK_ENCDEC AS
  -- Retrieve user specific and file specific cryptographic keys
--  PROCEDURE encrypt (file_id IN INTEGER, enc_key IN VARCHAR);
--  END ECMSDK_ENCDEC;
-- /
-- Program definitions in package CMSDK_spatial_crypt
-- CREATE OR REPLACE PACKAGE BODY ECMSDK_ENCDEC IS  
-- we have to change the name of the blob storage in ecmsdk
-- The encrypt procedure for both the user-specific and multi-user files. The CMSDK fileid  and location of    -- original LOB is passed as parameter
 CREATE OR REPLACE  PROCEDURE encrypt (file_id IN INTEGER, enc_key IN VARCHAR) AS
  v_data_buffer_cache_threshold INTEGER := 33554432; -- configurable data buffer cache size: currently 32Mb
  v_IO_readwrite_chunksize      BINARY_INTEGER := 32760; -- maximum data storage size allowed by PL/SQL
  cipher_block_size             INTEGER := 8;
  blob_original                 BLOB; --   := original_blob; -- the original blob in CMSDK tables
  blob_temporary                BLOB;                     -- temporary blobs
  v_file_id                     INTEGER := file_id; -- CMSDK file's id
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

  -- encryption_type  INTEGER := dbms_crypto.ENCRYPT_AES128 + dbms_crypto.CHAIN_CBC + dbms_crypto.PAD_PKCS5;

  BEGIN
   SELECT to_number(to_char(CURRENT_TIMESTAMP, 'SSSSSxFF')) INTO start_time FROM dual; -- set start time

    -- just finding a place to temporary hold te encrypted blob data 
    -- SELECT templob INTO blob_temporary FROM ECMSDK_user_temp_lobs WHERE ECMSDK_user_id = 1 AND ECMSDK_file_id = 1; -- dummy values

    -- determine in which CMSDK table, file is stored, indexble table or nonindexble table
    --SELECT defaultmediablob INTO v_media FROM ECMSDK.odmm_contentvault WHERE ECMSDK.odmm_contentvault.id = v_file_id;
    --IF (v_media = 2061) THEN -- If file is stored in the nonindexed table
    SELECT defaultblobmedia INTO blob_original FROM ECMSDK.odmm_contentvault
          WHERE ECMSDK.odmm_contentvault.id = (v_file_id);
      DBMS_LOB.OPEN(blob_original, DBMS_LOB.LOB_READONLY); -- Compute file length for encryption processing
      v_blob_length := DBMS_LOB.GETLENGTH(blob_original);
      DBMS_LOB.CLOSE(blob_original);

      DBMS_OUTPUT.PUT_LINE('v_blob_length = ' || v_blob_length);
      
       -- compute encryption processing information
      v_total_IO_readwrites := v_blob_length / v_IO_readwrite_chunksize;
      dbms_output.put_line('v_total_IO_readwrites = ' || v_total_IO_readwrites);
      v_reminder := MOD(v_blob_length, v_IO_readwrite_chunksize);
      dbms_output.put_line('v_reminder = ' || v_reminder);
      v_threshold_loops := v_blob_length / v_data_buffer_cache_threshold;
      dbms_output.put_line('v_threshold_loops = ' || v_threshold_loops);
      
       -- pad file if not multiple of cipher block size
      leftover_bytes := MOD(v_blob_length, cipher_block_size);
      IF (leftover_bytes <> 0) THEN
        dbms_output.put_line('leftover_bytes <> 0');
        pad_amount := cipher_block_size - leftover_bytes;
        pad(v_file_id, v_media, pad_amount);
        padded := TRUE;
      END IF;

        IF v_threshold_loops < 1 THEN -- If filesize smaller than data_buffer_cache size
            SELECT defaultblobmedia INTO blob_original FROM ECMSDK.odmm_contentvault
              WHERE ECMSDK.odmm_contentvault.id = (v_file_id) FOR UPDATE;
            -- Open, Split and Encrypt
            -- if filesize is less than 'v_IO_readwrite_chunksize', read all data in 1 read
                IF v_total_IO_readwrites < 1 THEN
                  dbms_output.put_line('v_total_IO_readwrites < 1 ' );
                  dbms_lob.read(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
                  --encrypted_raw  := f_crypto(v_enc_key_string , raw_input);     -- New encryption algorithm
                  dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
                  --encrypted_raw := dbms_crypto.encrypt( raw_input,encryption_type, raw_enc_key);
                  dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypted_raw);
                ELSE -- if filesize is more than 32 kb, encrypt/decrypt data in loops
                  dbms_output.put_line('ELSE OF v_total_IO_readwrites < 1 ' );  
                  FOR i IN lower .. v_total_IO_readwrites LOOP
                    -- even if size is less than I/O amount, it is read all at once because of ceiling function
                    dbms_lob.read(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
                    --encrypted_raw  := f_crypto(v_enc_key_string , raw_input);     -- Custom encryption algorithm
                    dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
     --               encrypted_raw := dbms_crypto.encrypt( raw_input, encryption_type, raw_enc_key);
                    dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypted_raw);
                    Pos := Pos + v_IO_readwrite_chunksize;
                  END LOOP;
                  COMMIT;
                END IF;
        
        ELSE -- If filesize equal to or larger than data_buffer_cache size
            -- dbms_lob.open(blob_original, dbms_lob.lob_readwrite);
            dbms_output.put_line('Filesize bigger than data_buffer_cache size'); 
            v_readwrites_per_threshold := (v_data_buffer_cache_threshold / v_IO_readwrite_chunksize);
            FOR j IN low .. v_threshold_loops LOOP
              dbms_output.put_line('for loop a');  
              SELECT defaultblobmedia INTO blob_original FROM ECMSDK.odmm_contentvault
                WHERE ECMSDK.odmm_contentvault.id = (v_file_id)  FOR UPDATE;
              dbms_output.put_line('for loop b');  
              loops_left_to_do := v_total_IO_readwrites - loops_done;
              IF(loops_left_to_do >= v_readwrites_per_threshold) THEN
                loops_to_do_now := v_readwrites_per_threshold;
              ELSE
                loops_to_do_now := loops_left_to_do;
              END IF;
              dbms_output.put_line('for loop c');  
              FOR i IN lower .. loops_to_do_now LOOP
                dbms_output.put_line('for loop d');  
                -- even if size is less than I/O amount, it is read in because of ceiling function
                dbms_lob.read(blob_original, v_IO_readwrite_chunksize, Pos, raw_input);
                -- dbms_output.put_line('raw_input ' || SUBSTR(raw_input,2));
                -- sys.dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
                -- encrypted_raw  := f_crypto(v_enc_key_string , raw_input);  -- new encryption algorithm
                dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
                -- dbms_crypto.encrypt(encrypblob, raw_input, encryption_type, -- key => raw_enc_key, iv => iv_raw); -- , 
                   -- hextoraw ('000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F'),
                   -- raw_enc_key,
                    -- hextoraw('00000000000000000000000000000000')); 
                -- dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypblob);
                DBMS_LOB.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypted_raw);
                Pos := Pos + v_IO_readwrite_chunksize;
              END LOOP;
              loops_done := loops_done + loops_to_do_now;
    
              -- DBMS_LOB.CLOSE (blob_temporary);
              -- dbms_output.put_line('Going to close'); 
              -- DBMS_LOB.CLOSE (blob_original);
              -- dbms_lob.close (blob_original);
              COMMIT;
            END LOOP;
            -- UPDATE ECMSDK.odmm_contentvault SET defaultblobmedia = blob_original WHERE ECMSDK.odmm_contentvault.id = (v_file_id);
            COMMIT;  
        END IF;      
      
       IF (padded) THEN  -- if file was padded the remove padding
         dbms_output.put_line('Padded'); 
         unpad(v_file_id, v_media, v_blob_length);
       END IF;
      -- point the LOB back to the original blob
      -- dbms_output.put_line('Going to update v_file_id = ' || v_file_id);  
      -- UPDATE ECMSDK.odmm_contentvault SET defaultblobmedia = blob_original WHERE ECMSDK.odmm_contentvault.id = (v_file_id);
      COMMIT; 
      
      time_taken := (to_number(to_char(CURRENT_TIMESTAMP, 'SSSSSxFF')) - start_time);
      dbms_output.put_line('TIME TAKEN > ' || time_taken);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('File not found in query ');
  END encrypt;
--END ECMSDK_ENCDEC;
--/ 

