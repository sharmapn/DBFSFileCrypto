-- This script contains the DBFS user-session based trigger implemented within Oracle ECMSDK. 
-- On each ECMSDK user session  creation and termination, the session-based trigger is used to 
-- call decryption and encryption procedure respectively. 

-- Those two procedures first obtain the single-user as well as the multi-user GIS files 
-- to which user has privilege, and thencalls either the decryption or the encryption procedure 
-- so that these files can be decrypted or encrypted. 

-- To prevent the execution of this trigger when multiple users are using the same account, 
-- which would corrupt the file resulting from double encryption and decryption, the trigger 
-- first queries the number of existing sessions of the user; only if no existing session of 
-- the user exists, then the files are decrypted or encrypted.

CREATE OR REPLACE TRIGGER dec_enc_spatial_files
 BEFORE INSERT OR DELETE ON ecmsdk.odmz_session
 FOR EACH ROW 
 DECLARE
 v_sessions NUMBER;
 
 CURSOR active_ECMSDK_user_sessions IS
 SELECT USERID FROM ECMSDK.ODMZ_SESSION
   WHERE USERID = (:NEW.USERID) OR USERID = (:OLD.USERID);
 
 BEGIN
 OPEN active_ECMSDK_user_sessions;
 FETCH active_ECMSDK_user_sessions INTO v_sessions;
 -- Only if no existing sessions of this user, then decrypt or encrypt
 IF active_ECMSDK_user_sessions%NOTFOUND THEN
   IF INSERTING THEN
      ECMSDK_spatial_crypt.get_11gecmsdk_user_files_dec (:NEW.USERID);
   ELSIF DELETING THEN
      ECMSDK_spatial_crypt.get_11gecmsdk_user_files_enc (:OLD.USERID);
   END IF;
 END IF;
 CLOSE active_ECMSDK_user_sessions;
END dec_enc_spatial_files;
/
