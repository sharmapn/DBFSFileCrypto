
-- 23-July-2022 This is the main script I use for single file encryption, without having to provide the blob object as third argument
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

-- IF YOU ENCOUNTER RAW VARIABLE LENGTH TOOL LONG ERROR, then change the 'v_IO_readwrite_chunksize' size to say 2048 - and later increase the size

 CREATE OR REPLACE  PROCEDURE encrypt (file_id IN INTEGER, enc_key IN VARCHAR) AS
  v_data_buffer_cache_threshold INTEGER := 33554432; -- configurable data buffer cache size: currently 32Mb
  v_IO_readwrite_chunksize      BINARY_INTEGER := 32760; -- (32760 - 16); -- 44; --  originally 32760, but somehow encryption adds 8 extra chars so we need to reduce this   32Kb -- 2048; -- 2048; -- 32760; -- maximum data storage size allowed by PL/SQL
  cipher_block_size             INTEGER := 8;
  blob_original                 BLOB; --   := original_blob; -- the original blob in CMSDK tables
  src_blob                      BLOB;                     -- temporary blobs  
  encrypblob                    BLOB;
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
  v_DBBuffer_threshold_loops    INTEGER;    -- number of loops per buffer cache threshold
  v_readwrites_per_threshold    INTEGER;    -- number of read-writes per buffer cache threshold
  v_reminder                    INTEGER;
  v_reminder_io_readwrites      INTEGER;
  v_counter_readwrites          INTEGER;
  leftover_bytes                INTEGER;
  pad_amount                    INTEGER := 0;  -- number of bytes to pad in order to encrypt entire file
  v_enc_key_string              VARCHAR2(50) := enc_key;
  raw_enc_key                   RAW(128) := UTL_RAW.CAST_TO_RAW(enc_key); -- v_enc_key_string); -- stores 256-bit encryption key
  raw_input                     RAW(32760); 
  encrypted_raw                 RAW(32760);
  start_time                    NUMBER(20, 10); -- needed to compute time taken for encryption of a file
  time_taken                    NUMBER(20, 10); -- time taken for encryption of a file
  padded                        BOOLEAN := FALSE; -- keep track if file has been padded for unpadding later
  temp_id                       INTEGER;

  -- encryption_type               INTEGER := dbms_crypto.ENCRYPT_AES128 + dbms_crypto.CHAIN_CBC + dbms_crypto.PAD_PKCS5;  -- total encryption type
  
  -- Specification of the Encryption algorithm used from Oracle. Can be AES, 3DES or DES
  -- encryption_type INTEGER := dbms_crypto.ENCRYPT_AES128 + dbms_crypto.CHAIN_CBC + dbms_crypto.PAD_PKCS5;
  -- encryption_type INTEGER := dbms_crypto.ENCRYPT_3des + dbms_crypto.CHAIN_CBC + dbms_crypto.PAD_PKCS5; 
  -- main encryption_type INTEGER := dbms_crypto.ENCRYPT_AES256 + dbms_crypto.CHAIN_CBC + dbms_crypto.PAD_PKCS5;
  inverse_key_raw RAW(32) := UTL_RAW.cast_to_raw( '1220248819');       
  iv_raw                        RAW (16);

  BEGIN
   SELECT to_number(to_char(CURRENT_TIMESTAMP, 'SSSSSxFF')) INTO start_time FROM dual; -- set start time
   
   dbms_lob.createtemporary(blob_original, TRUE);
   dbms_lob.createtemporary(encrypblob, TRUE);

   iv_raw        := '8D55D821A010458BDBFCC916DB10BDE5'; -- DBMS_CRYPTO.RANDOMBYTES (16);
   dbms_output.put_line('v_file_id ' || v_file_id);
   dbms_output.put_line('raw_enc_key ' || raw_enc_key);
   
   dbms_output.put_line('iv_raw ' || iv_raw); 
   dbms_output.put_line('inverse_key_raw ' || inverse_key_raw);
   v_blob_length := read_blob(v_file_id, cipher_block_size); 
   dbms_output.put_line('v_blob_length ' || v_blob_length);

   -- compute encryption processing information
   v_total_IO_readwrites := v_blob_length / v_IO_readwrite_chunksize;
   dbms_output.put_line('v_total_IO_readwrites ' || v_total_IO_readwrites); 
   v_reminder := MOD(v_blob_length, v_IO_readwrite_chunksize);
   dbms_output.put_line('v_reminder ' || v_reminder); 
   v_DBBuffer_threshold_loops := v_blob_length / v_data_buffer_cache_threshold;
   dbms_output.put_line('v_threshold_loops ' || v_DBBuffer_threshold_loops);
      
   IF v_total_IO_readwrites < 1 THEN
     v_IO_readwrite_chunksize := 8;
   END IF;   

   IF v_DBBuffer_threshold_loops < 1 THEN -- If filesize smaller than data_buffer_cache size
      dbms_output.put_line('If filesize smaller than data_buffer_cache size');       
      SELECT defaultblobmedia INTO src_blob FROM ECMSDK.odmm_contentvault
        WHERE ECMSDK.odmm_contentvault.id = (v_file_id) FOR UPDATE;
      dbms_lob.open(blob_original, dbms_lob.lob_readwrite);
        dbms_output.put_line('here aa ');
        -- Open, Split and Encrypt
        -- if filesize is less than 'v_IO_readwrite_chunksize', read all data in 1 read
        IF v_total_IO_readwrites < 1 THEN
          dbms_output.put_line('here b ');
          dbms_lob.read(src_blob, v_IO_readwrite_chunksize, Pos, raw_input);          
          dbms_output.put_line('here b2 ');
          -- dbms_output.put_line('raw_input ' || SUBSTR(raw_input,2));
          -- encrypted_raw  := f_crypto(v_enc_key_string , raw_input);     -- New encryption algorithm
          -- sys.dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
          -- encrypted_raw := 
                           -- destination  source   
 --         dbms_crypto.encrypt(encrypblob, raw_input,  encryption_type, -- key => raw_enc_key, iv => iv_raw); -- , 
           -- hextoraw ('000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F'),
 --             raw_enc_key,
 --             inverse_key_raw); -- hextoraw('00000000000000000000000000000000')); 
            
          --  DBMS_CRYPTO.Encrypt(encrypblob, raw_input, DBMS_CRYPTO.AES_CBC_PKCS5,
          --      hextoraw ('000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F'),
          --      hextoraw('00000000000000000000000000000000'));    
            dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw );  
            dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypted_raw);
          -- dbms_lob.WRITE(blob_original, LENGTH(encrypblob) , Pos, encrypblob); -- v_IO_readwrite_chunksize
          -- DBMS_LOB.WRITEAPPEND (blob_original, v_IO_readwrite_chunksize, encrypblob);
        ELSE -- if filesize is more than 32 kb, encrypt/decrypt data in loops
          dbms_output.put_line('ELSE'); 
          FOR i IN lower .. v_total_IO_readwrites LOOP
            -- dbms_output.put_line('here d ');
            -- even if size is less than I/O amount, it is read all at once because of ceiling function
            dbms_lob.read(src_blob, v_IO_readwrite_chunksize, Pos, raw_input);
            -- dbms_output.put_line('raw_input ' || SUBSTR(raw_input,2));
            -- dbms_output.put_line('here e ');
            -- encrypted_raw  := f_crypto(v_enc_key_string , raw_input);     -- Custom encryption algorithm
            -- sys.dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
 --           dbms_crypto.encrypt(encrypblob, raw_input, encryption_type, -- key => raw_enc_key, iv => iv_raw); -- , )
             -- hextoraw ('000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F'),
 --               raw_enc_key,
 --               inverse_key_raw); -- hextoraw('00000000000000000000000000000000')); 
            
          --  DBMS_CRYPTO.Encrypt(encrypblob, raw_input, DBMS_CRYPTO.AES_CBC_PKCS5,
          --      hextoraw ('000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F'),
          --      hextoraw('00000000000000000000000000000000'));    
            dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); 
            
            -- dbms_output.put_line('here f ');
            -- dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypblob);
            dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypted_raw);
            -- DBMS_LOB.WRITEAPPEND (blob_original, LENGTH(encrypblob), encrypblob); 
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;          
        END IF;
        dbms_lob.close (blob_original);
        UPDATE ECMSDK.odmm_contentvault SET defaultblobmedia = blob_original WHERE ECMSDK.odmm_contentvault.id = (v_file_id);        
        COMMIT;
   ELSE -- If filesize equal to or larger than data_buffer_cache size
        dbms_lob.open(blob_original, dbms_lob.lob_readwrite);
        dbms_output.put_line('If filesize bigger than data_buffer_cache size'); 
        -- dbms_output.put_line('v_IO_readwrite_chunksize ' || v_IO_readwrite_chunksize); 
        v_readwrites_per_threshold := (v_data_buffer_cache_threshold / v_IO_readwrite_chunksize);
        FOR j IN low .. v_DBBuffer_threshold_loops LOOP
          -- dbms_output.put_line('for loop a');  
          SELECT defaultblobmedia INTO src_blob FROM ECMSDK.odmm_contentvault
          WHERE ECMSDK.odmm_contentvault.id = (v_file_id)  FOR UPDATE;
          -- dbms_output.put_line('For loop B v_total_IO_readwrites ' || v_total_IO_readwrites || ' loops_done ' || loops_done);  
          loops_left_to_do := v_total_IO_readwrites - loops_done;
          -- dbms_output.put_line('for loop ca'); 
          IF(loops_left_to_do >= v_readwrites_per_threshold) THEN
            loops_to_do_now := v_readwrites_per_threshold;
          ELSE
            loops_to_do_now := loops_left_to_do;
          END IF;
          -- dbms_output.put_line('for loop c');  
          FOR i IN lower .. loops_to_do_now LOOP
            -- dbms_output.put_line('for loop d');  
            -- even if size is less than I/O amount, it is read in because of ceiling function
            dbms_lob.read(src_blob, v_IO_readwrite_chunksize, Pos, raw_input);
            -- dbms_output.put_line('for loop e'); 
            -- dbms_output.put_line('raw_input ' || SUBSTR(raw_input,2));
            -- sys.dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw ); -- Oracle dbms_obfuscation_toolkit, 3DES algorithm
            -- encrypted_raw  := f_crypto(v_enc_key_string , raw_input);  -- new encryption algorithm
            -- dbms_output.put_line('for loop e');  
 --           dbms_crypto.encrypt(encrypblob, raw_input, encryption_type, -- key => raw_enc_key, iv => iv_raw); -- , 
               -- hextoraw ('000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F'),
 --               raw_enc_key,
 --               inverse_key_raw); -- hextoraw('00000000000000000000000000000000'));
 
          --  DBMS_CRYPTO.Encrypt(encrypblob, raw_input, DBMS_CRYPTO.AES_CBC_PKCS5,
          --      hextoraw ('000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F'),
          --      hextoraw('00000000000000000000000000000000'));    
            dbms_obfuscation_toolkit.DES3Encrypt(input => raw_input, key => raw_enc_key, encrypted_data => encrypted_raw );
 
            -- dbms_output.put_line('for loop f');  
            -- dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypblob);  
            dbms_output.put_line('v_IO_readwrite_chunksize ' || v_IO_readwrite_chunksize); 
            dbms_output.put_line('LENGTH(encrypblob) ' || LENGTH(encrypblob)); 
            -- DBMS_LOB.WRITEAPPEND (blob_original, LENGTH(encrypblob), encrypblob); -- v_IO_readwrite_chunksize
            dbms_lob.WRITE(blob_original, v_IO_readwrite_chunksize, Pos, encrypted_raw);
            -- dbms_output.put_line('for loop g');  
            Pos := Pos + v_IO_readwrite_chunksize;
          END LOOP;
          loops_done := loops_done + loops_to_do_now;
          
          -- dbms_output.put_line('for loop g');  
 --         DBMS_LOB.CLOSE (src_blob);
          dbms_output.put_line('Going to close'); 
          -- DBMS_LOB.CLOSE (blob_original);
          -- dbms_output.put_line('for loop h');  
 --         dbms_lob.close (blob_original);
          COMMIT;
        END LOOP;
        dbms_lob.close (blob_original);
        -- dbms_output.put_line('for loop i');  
        UPDATE ECMSDK.odmm_contentvault SET defaultblobmedia = blob_original WHERE ECMSDK.odmm_contentvault.id = (v_file_id);
        COMMIT;
   END IF;
    
   IF (padded) THEN  -- if file was padded the remove padding
      dbms_output.put_line('Padded'); 
      -- unpad(v_file_id, v_media, v_blob_length);
   END IF;
    -- point the LOB back to the original blob
   dbms_output.put_line('Going to update v_file_id = ' || v_file_id);  
   UPDATE ECMSDK.odmm_contentvault SET defaultblobmedia = blob_original WHERE ECMSDK.odmm_contentvault.id = (v_file_id);
   COMMIT; 

  -- END IF;
   time_taken := (to_number(to_char(CURRENT_TIMESTAMP, 'SSSSSxFF')) - start_time);
   DBMS_OUTPUT.put_line('TIME TAKEN > ' || time_taken);
    -- DBMS_LOB.FREETEMPORARY (src_blob); -- free the temporary lobs created during the session
   COMMIT;      

   EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('File not found in query ');
   END encrypt;
-- END ECMSDK_ENCDEC;
/  

 -- DROP procedure read_blob;

 CREATE OR REPLACE  FUNCTION read_blob (v_file_id IN INTEGER, cipher_block_size IN INTEGER) RETURN INTEGER AS
  blob_justread                     BLOB;
  v_blob_length                 INTEGER;    -- for computing encryption information such as number of loops
  leftover_bytes                INTEGER;
  pad_amount                    INTEGER := 0;  -- number of bytes to pad in order to encrypt entire file
  padded                        BOOLEAN := FALSE; -- keep track if file has been padded for unpadding later
 
  BEGIN
-- determine in which CMSDK table, file is stored, indexble table or nonindexble table
    -- SELECT defaultmediablob INTO v_media FROM ECMSDK.odmm_contentvault WHERE ECMSDK.odmm_contentvault.id = v_file_id;
    -- IF (v_media = 2061) THEN -- If file is stored in the nonindexed table
    SELECT defaultblobmedia INTO blob_justread FROM ECMSDK.odmm_contentvault
          WHERE ECMSDK.odmm_contentvault.id = (v_file_id);
      -- DBMS_LOB.OPEN(blob_justread, DBMS_LOB.LOB_READONLY); -- Compute file length for encryption processing
      v_blob_length := DBMS_LOB.GETLENGTH(blob_justread);
      RETURN v_blob_length;
      DBMS_LOB.CLOSE(blob_justread);
      dbms_output.put_line('v_blob_length ' || v_blob_length);
      -- pad file if not multiple of cipher block size
      leftover_bytes := MOD(v_blob_length, cipher_block_size);
      IF (leftover_bytes <> 0) THEN
        dbms_output.put_line('leftover_bytes <> 0');
        pad_amount := cipher_block_size - leftover_bytes;
        -- pad(v_file_id, v_media, pad_amount);
        padded := TRUE;
      END IF;

     EXCEPTION
       WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('File not found in query ');
   RETURN v_blob_length;
   END read_blob;
   /

  