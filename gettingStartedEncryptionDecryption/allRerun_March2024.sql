-- Here is the script that contaisn all the deails of how to carry out the encryption decryption again
-- Was prepared in October 2023

-- Connect as sys and then just add ecmsdk prefix

-- 1. MAIN start ...filename can be retrieved from here
-- file is here view combines document with public object
select * from ecmsdk.odmv_document; 

-- 27458

call ecmsdk.encrypt(27530,'passwordpasswordpassword');
commit;

call ecmsdk.decrypt(27530,'passwordpasswordpassword');
commit;

-- For video demonstration
-- call procedure to encrypt 
-- -- a) user scott's file with .enc extension
-- -- b) user scotts and alans multi-user file

set echo on
set serveroutput on

-- main join query that gets us the id, which can be used in the next query
SELECT co.content, doc.name 
FROM ecmsdk.odmv_document doc, ecmsdk.odm_contentobject co 
WHERE doc.name LIKE '%historic%' AND doc.CONTENTOBJECT = co.id;  --'%.geojson'

-- $$$$$$$$$$ 
-- Here is the main blob content
-- blob columnname = defaultblobmedia -- was old media table
SELECT * from ecmsdk.odmm_contentvault; 
SELECT * from ecmsdk.odmm_contentvault WHERE ID = 27911; -- 11634; -- get id from above join query

-- MAIN ENDs here I guess


-- 2. START - initials (direct) SQLs to get information
select * from odm_publicobject WHERE name like '%shp%'; 
-- ID   CLASSID NAME
-- 7008	618	    france-natural.shp		5411	960	0	7008	1247072846000	5411	1247072846000	5411	0	0	0	0			0	3253	0	0
select * from odm_document WHERE ID = 7008 order by id desc;
-- ID   CONTENTOBJECT
-- 7008	7015	        0	0	0	0				
select * from odm_contentobject order by id desc;
-- where ID = 7009;
-- ID   FORMAT  MEDIA   CONTENT
-- 7009	4592	4529	7010	0		ENGLISH	0	1647438885242	0	0	0
select * from odmm_contentvault order by id desc; 
-- WHERE ID = 7010;
-- ID   MEDIAID
-- 7010	4529			(BLOB)		
select * from ECMSDK_User_TempLOBS;
select * from odm_publicobject WHERE ID = 22447; 
-- END initials (direct) SQL 




-- below scripts not needed
-- oracle document management
select * from odm_document; 
-- To get to the blob, first we do this 
-- query using the filename to get the contentobject
select name, contentobject from odmv_document; -- filename and contentobject
-- then we use the cotentobjct to get the blob
select * from odm_contentobject where id = 11633; -- content here

-- DROP  USER  ecmsdk  CASCADE;
