IF EXISTS (SELECT * FROM Sysobjects where Name = 'minjun_TLGQCBadInfoItem' AND xtype = 'U' )
    Drop table minjun_TLGQCBadInfoItem

CREATE TABLE minjun_TLGQCBadInfoItem
(
    CompanySeq		INT 	 NOT NULL, 
    BadSeq		INT 	 NOT NULL, 
    BadSerl		INT 	 NOT NULL, 
    ItemSeq		INT 	 NULL, 
    QCType		INT 	 NULL, 
    BadType		INT 	 NULL, 
    STDUnitSeq		INT 	 NULL, 
    BadQty		DECIMAL(19,5) 	 NULL, 
    BadOccDeptSeq		INT 	 NULL, 
    CustSeq		INT 	 NULL, 
    Remark		NVARCHAR(200) 	 NULL, 
    LastUserSeq		INT 	 NULL, 
    LastDateTime		DATETIME 	 NULL, 
    PgmSeq		INT 	 NULL, 
CONSTRAINT PKminjun_TLGQCBadInfoItem PRIMARY KEY CLUSTERED (CompanySeq ASC, BadSeq ASC, BadSerl ASC)

)


IF EXISTS (SELECT * FROM Sysobjects where Name = 'minjun_TLGQCBadInfoItemLog' AND xtype = 'U' )
    Drop table minjun_TLGQCBadInfoItemLog

CREATE TABLE minjun_TLGQCBadInfoItemLog
(
    LogSeq		INT IDENTITY(1,1) NOT NULL, 
    LogUserSeq		INT NOT NULL, 
    LogDateTime		DATETIME NOT NULL, 
    LogType		NCHAR(1) NOT NULL, 
    LogPgmSeq		INT NULL, 
    CompanySeq		INT 	 NOT NULL, 
    BadSeq		INT 	 NOT NULL, 
    BadSerl		INT 	 NOT NULL, 
    ItemSeq		INT 	 NULL, 
    QCType		INT 	 NULL, 
    BadType		INT 	 NULL, 
    STDUnitSeq		INT 	 NULL, 
    BadQty		DECIMAL(19,5) 	 NULL, 
    BadOccDeptSeq		INT 	 NULL, 
    CustSeq		INT 	 NULL, 
    Remark		NVARCHAR(200) 	 NULL, 
    LastUserSeq		INT 	 NULL, 
    LastDateTime		DATETIME 	 NULL, 
    PgmSeq		INT 	 NULL
)

CREATE UNIQUE CLUSTERED INDEX IDXTempminjun_TLGQCBadInfoItemLog ON minjun_TLGQCBadInfoItemLog (LogSeq)
go