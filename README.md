# DBFSFileEncDec

The DBFS encryption solution is developed for use in ECMSDK – an open-source DBFS product. As such, it is coded in Oracle PL/SQL for implementation within the (free) Oracle 11G XE database. However, the code structure can be used to implement the encryption solution within other DBFS products, such as IBM DB2 Content Manager. 

The source code of the Spatial Crypt Package first obtains details of single-user and multi-user GIS files specified for encryption by DBFS users, and then calls either the encryption or the decryption procedures. The procedures within this package are executed upon GIS-DBFS user session creation and termination in ECMSDK. 

The DBFS encryption solution consists of three parts, available as separate PL/SQL files <br/>
1. Catalogs.sql - the database tables storing the encryption keys for single-user and multi-user files. 
2. ECMSDK_SpatialCrypt.sql - the encryption-decryption solution  implemented in this PL/SQL package, and 
3. ECMSDK_SessionBasedTrigger.sql - the user-session based trigger that calls the encryption and decryption procedures in the above package. 

**Usage**
All the three SQL scripts are to be executed by the Database administrator (DBA). The DBA can use a command line facility, such as SQLPlus and issue these commands from his/her Oracle account. Additional details are provided in each of the scripts.

The Oracle wallet can be initialised by issuing the following command, which will: create a wallet, create a master key for the entire database, and open the wallet.

```ALTER SYSTEM SET encryption key identified by "hdgr57fnle39dncv";```

Subsequently, after each table creation with an encrypted column specification will cause the TDE to create a separate key for each table. 

These tables and the encrypted column definitions are only possible with the Oracle database version 10g Release 2 and onwards.

Also, included is an Appendix (_within the UserInteractionModel.pdf file_), 
that includes the following:
- Appendix A - Detailed	encryption-decryption times for spatial files within DBFS  
- Appendix B - Oracle ECMSDK session-based trigger
- Appendix C - DBFS encryption solution - (_showing catalog tables_)
- Appendix D - Security solution use with classical shared folders 
- Appendix E - Security solution implemented within database-driven GIS Web portals & Web maps 

