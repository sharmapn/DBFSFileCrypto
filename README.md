#DBFSFileCrypto

**Setup ECMSDK**

The following video shows how to start ECMSDK on Windows OS. 

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/gR6l1tUspwQ/0.jpg)](https://www.youtube.com/watch?v=gR6l1tUspwQ)

**DBFSFileCrypto Package**

The DBFS File Crypto package is developed for file encryption decryption solution for use within ECMSDK, an open-source DBFS product. As such, it is coded in Oracle PL/SQL for implementation within the (free) Oracle 11G XE database. However, the code structure can be used to implement the encryption solution within other DBFS products, such as IBM DB2 Content Manager. 

The following video demonstrates the use of the encryption-decryption solution. 

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/zMJV5zV0-zs/0.jpg)](https://www.youtube.com/watch?v=zMJV5zV0-zs)

**Initial Encryption-Decryption Scripts to get started**

The encryption and decryption scripts in the folder "gettingStartedEncryptionDecryption" will assist in getting started on encryption-decryption within ECMSDK.

**Main Encryption-Decryption Script**

The source code of the DBFS File Crypto Package first obtains details of single-user and multi-user GIS files specified for encryption by DBFS users and then calls either the encryption or the decryption procedures. The procedures within this package are executed upon GIS-DBFS user session creation and termination in ECMSDK. 

The encryption solution consists of three parts, available as separate PL/SQL files <br/>
1. Catalogs.sql - the database tables storing the encryption keys for single-user and multi-user files. 
2. ECMSDK_SpatialCrypt.sql - the encryption-decryption solution  implemented in this PL/SQL package, and 
3. ECMSDK_SessionBasedTrigger.sql - the user-session-based trigger that calls the encryption and decryption procedures in the above package. 

These tables and the encrypted column definitions are only possible with the Oracle database version 10g Release 2 and onwards.

**Script Usage:**
All three SQL scripts are to be executed by the Database administrator (DBA). The DBA can use a command-line facility, such as SQLPlus, and issue these commands from his or her Oracle account as follows, in this order. 

```
SQL > @Catalogs.sql
SQL > @ECMSDK_SpatialCrypt.sql
SQL > @ECMSDK_SessionBasedTrigger.sql
```

Additional details are provided in each of the scripts. 

**Oracle Wallet Setup:**

The Oracle wallet can be initialised by issuing the following command, which will: create a wallet, create a master key for the entire database, and open the wallet.

```SQL > ALTER SYSTEM SET encryption key identified by "hdgr57fnle39dncv";```

Subsequently, after each table creation with an encrypted column specification will cause the TDE to create a separate key for each table. 


**Additional Appendix material:**

Also included is an Appendix (_within the Appendix_DBFSSpatialCrypt.pdf file_), 
that includes the following:
- Appendix A - Detailed	encryption-decryption times for spatial files within DBFS  
- Appendix B - Oracle ECMSDK session-based trigger
- Appendix C - DBFS encryption solution - (_showing catalog tables_)
- Appendix D - Security solution use with classical shared folders 
- Appendix E - Security solution implemented within database-driven GIS Web portals & Web maps 

