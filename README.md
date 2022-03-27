# DBFSFileEncDec

The DBFS encryption solution is developed for use in ECMSDK – an open-source DBFS product. As such, it is coded in Oracle PL/SQL for implementation within the (free) Oracle 11G XE database. However, the code structure can be used to implement the encryption solution within other DBFS products, such as IBM DB2 Content Manager. 

The DBFS encryption solution consists of three parts, all of which are available as separate PL/SQL files in the Github repository
- the database tables storing the encryption keys for single-user and multi-user files. 
- the CMSDK Spatial Crypt package, and 
- the CMSDK user-session based trigger is. 

This repository contains details about the CMSDK Spatial Crypt in a document and a package containing the code.
The CMSDK Spatial Crypt package is within the SQL file. The package contains the encryption-decryption procedures (CMSDK SpatialCrypt.sql)

A document containing the Appendix include the follwoing material:
- detailed encryption-decryption results 
- solution implementations  
- description of the CMSDK schema tables 
- description of key storage and  multi-user file catalog tables

