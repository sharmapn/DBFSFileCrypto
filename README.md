# DBFSFileEncDec

The DBFS encryption solution is developed for use in ECMSDK – an open-source DBFS product. As such, it is coded in Oracle PL/SQL for implementation within the (free) Oracle 11G XE database. However, the code structure can be used to implement the encryption solution within other DBFS products, such as IBM DB2 Content Manager. 

The DBFS encryption solution consists of three parts, available as separate PL/SQL files <br/>
1. Catalogs.sql - the database tables storing the encryption keys for single-user and multi-user files. 
2. ECMSDK_SpatialCrypt.sql - the encryption-decryption solution  implemented in this PL/SQL package, and 
3. ECMSDK_SessionBasedTrigger.sql - the user-session based trigger that calls the encryption and decryption procedures within the ECMSDK_SpatialCrypt package. 

Also, included is an Appendix (_within the UserInteractionModel_DFSEncryptionSolution.pdf file_), 
that includes the following:
- Appendix A - Detailed	encryption-decryption times for spatial files within DBFS  
- Appendix B - Oracle ECMSDK session-based trigger
- Appendix C - DBFS encryption solution - (_showing catalog tables_)
- Appendix D - Security solution use with classical shared folders 
- Appendix E - Security solution implemented within database-driven GIS Web portals & Web maps 

