IF EXISTS (SELECT * FROM Sysobjects where Name = 'minjun_TLGQCBadInfo' AND xtype = 'U' )
    Drop table minjun_TLGQCBadInfo

CREATE TABLE minjun_TLGQCBadInfo
(
    CompanySeq		INT 	 NOT NULL, 
    BadSeq		INT 	 NOT NULL, 
    BadNo		NVARCHAR(100) 	 NULL, 
    BizUnit		INT 	 NULL, 
    BadDate		NCHAR(8) 	 NULL, 
    EmpSeq		INT 	 NULL, 
    DeptSeq		INT 	 NULL, 
    LastUserSeq		INT 	 NULL, 
    LastDateTime		DATETIME 	 NULL, 
    PgmSeq		INT 	 NULL, 
CONSTRAINT PKminjun_TLGQCBadInfo PRIMARY KEY CLUSTERED (CompanySeq ASC, BadSeq ASC)

)


IF EXISTS (SELECT * FROM Sysobjects where Name = 'minjun_TLGQCBadInfoLog' AND xtype = 'U' )
    Drop table minjun_TLGQCBadInfoLog

CREATE TABLE minjun_TLGQCBadInfoLog
(
    LogSeq		INT IDENTITY(1,1) NOT NULL, 
    LogUserSeq		INT NOT NULL, 
    LogDateTime		DATETIME NOT NULL, 
    LogType		NCHAR(1) NOT NULL, 
    LogPgmSeq		INT NULL, 
    CompanySeq		INT 	 NOT NULL, 
    BadSeq		INT 	 NOT NULL, 
    BadNo		NVARCHAR(100) 	 NULL, 
    BizUnit		INT 	 NULL, 
    BadDate		NCHAR(8) 	 NULL, 
    EmpSeq		INT 	 NULL, 
    DeptSeq		INT 	 NULL, 
    LastUserSeq		INT 	 NULL, 
    LastDateTime		DATETIME 	 NULL, 
    PgmSeq		INT 	 NULL
)

CREATE UNIQUE CLUSTERED INDEX IDXTempminjun_TLGQCBadInfoLog ON minjun_TLGQCBadInfoLog (LogSeq)
go