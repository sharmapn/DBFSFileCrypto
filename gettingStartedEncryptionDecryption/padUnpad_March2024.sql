-- This procedure pads the files which are not multiple of cipher block size
CREATE OR REPLACE PROCEDURE pad (v_file_id IN INTEGER, v_media IN INTEGER, v_pad_amount IN INTEGER) AS
    pad_data RAW(8) := '12345678901234'; -- pad data
    blob_locator BLOB;
    v_blob_length INTEGER; 
    
    BEGIN
    IF (v_media = 1625) THEN -- if file is nonindexble and therefore stored in odmm_nonindexedstore table
            -- SELECT nonindexedblob2 INTO blob_locator FROM ifssys.odmm_nonindexedstore
            --    WHERE ifssys.odmm_nonindexedstore.id = (v_file_id + 1) FOR UPDATE;
            SELECT defaultblobmedia INTO blob_locator FROM ECMSDK.odmm_contentvault
                WHERE ECMSDK.odmm_contentvault.id = (v_file_id) FOR UPDATE;
            pad_data := SUBSTR(pad_data, 0, 2 * v_pad_amount);
            DBMS_LOB.WRITEAPPEND(blob_locator, v_pad_amount, pad_data); -- append bytes at the end of blob
        COMMIT; 
        ELSE -- if file is indexble and therefore stored in odmm_contentstore table
           SELECT defaultblobmedia INTO blob_locator FROM ECMSDK.odmm_contentvault
                WHERE ECMSDK.odmm_contentvault.id = (v_file_id) FOR UPDATE;
            pad_data := SUBSTR(pad_data, 0, 2 * v_pad_amount);
            DBMS_LOB.WRITEAPPEND(blob_locator, v_pad_amount, pad_data); -- append bytes at the end of blob
        COMMIT; 
    END IF; 
END pad;

-- This procedure unpads the padded bytes in files which are not multiple of cipher block size
CREATE OR REPLACE PROCEDURE unpad(v_file_id IN INTEGER, v_media IN INTEGER, v_original_length IN INTEGER) AS
    blob_locator BLOB;
    v_blob_length INTEGER; 

    BEGIN
    IF (v_media = 1625) THEN -- if file is nonindexble and therefore stored in odmm_nonindexedstore table
        SELECT defaultblobmedia INTO blob_locator FROM ECMSDK.odmm_contentvault
                WHERE ECMSDK.odmm_contentvault.id = (v_file_id) FOR UPDATE;
        v_blob_length := DBMS_LOB.GETLENGTH(blob_locator);
        DBMS_LOB.TRIM(blob_locator, v_original_length); -- trim padded bytes from the end of blob
        COMMIT; 
    ELSE -- if file is indexble and therefore stored in odmm_contentstore table
        SELECT defaultblobmedia INTO blob_locator FROM ECMSDK.odmm_contentvault
                WHERE ECMSDK.odmm_contentvault.id = (v_file_id) FOR UPDATE;
        v_blob_length := DBMS_LOB.GETLENGTH(blob_locator);
        DBMS_LOB.TRIM(blob_locator, v_original_length); -- trim padded bytes from the end of blob
    COMMIT; 
    END IF; 
END unpad;


  