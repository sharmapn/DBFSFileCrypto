CREATE OR REPLACE TRIGGER dec_enc_spatial_files
 BEFORE INSERT OR DELETE ON ifssys.odmz_session
 FOR EACH ROW
 DECLARE
 v_sessions NUMBER;
 CURSOR active_CMSDK_user_sessions IS
 SELECT USERID FROM IFSSYS.ODMZ_SESSION
 WHERE USERID = (:NEW.USERID) OR USERID = (:OLD.USERID);
 BEGIN
 OPEN active_CMSDK_user_sessions;
 FETCH active_CMSDK_user_sessions INTO v_sessions;
 -- Only if no existing sessions of this user, then decrypt or encrypt
 IF active_CMSDK_user_sessions%NOTFOUND THEN
 IF INSERTING THEN
 CMSDK_spatial_crypt.get_10gcmsdk_user_files_dec (:NEW.USERID);
 ELSIF DELETING THEN
 CMSDK_spatial_crypt.get_10gcmsdk_user_files_enc (:OLD.USERID);
 END IF;
 END IF;
 CLOSE active_CMSDK_user_sessions;
END dec_enc_spatial_files;
/
