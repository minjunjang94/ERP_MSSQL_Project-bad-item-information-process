IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('minjun_FrmLGQCBadInfoListPrint') AND sysstat & 0xf = 4) /*★*/
    DROP PROCEDURE dbo.minjun_FrmLGQCBadInfoListPrint /*★*/
GO

CREATE PROCEDURE minjun_FrmLGQCBadInfoListPrint /*★*/    
    @ServiceSeq    INT          = 0 ,  
    @WorkingTag    NVARCHAR(10) = '',  
    @CompanySeq    INT          = 1 ,  
    @LanguageSeq   INT          = 1 ,  
    @UserSeq       INT          = 0 ,  
    @PgmSeq        INT          = 0 ,  
    @IsTransaction BIT          = 0 
AS  
  
    -- 하기 SELECT 구문에 대해 필요에 따라 로직을 수정하여 조회합니다.  

    DECLARE 

     @BadDateFr              NCHAR(8)          
    ,@BadDateTo              NCHAR(8)  



    SELECT  
             @BadDateFr                   = RTRIM(LTRIM(ISNULL(M.BadDateFr           , '')))
            ,@BadDateTo                   = RTRIM(LTRIM(ISNULL(M.BadDateTo           , '')))
 
      FROM  #BIZ_IN_DataBlock1      AS M

      

                                    
           --Master  
SELECT A.CompanySeq, A.MinorName,ISNULL(SUM(B.BadQty),0)  AS test1
INTO #TEMP1
FROM 
(
    SELECT *
    FROM _TDAUMinor
    WHERE MajorSeq=2000311
)
   AS A
LEFT OUTER JOIN minjun_TLGQCBadInfoItem  AS  B  ON B.CompanySeq = A.CompanySeq
                                               AND B.BadType    = A.MinorSeq
                                               AND QCType       = 2000310001
GROUP BY A.MinorName, A.CompanySeq


SELECT A.CompanySeq, A.MinorName,ISNULL(SUM(B.BadQty),0)  AS test2
INTO #TEMP2
FROM 
(
    SELECT *
    FROM _TDAUMinor
    WHERE MajorSeq=2000311
)
   AS A
LEFT OUTER JOIN minjun_TLGQCBadInfoItem  AS  B  ON B.CompanySeq = A.CompanySeq
                                               AND B.BadType    = A.MinorSeq
                                               AND QCType       = 2000310002
GROUP BY A.MinorName, A.CompanySeq


SELECT A.CompanySeq, A.MinorName,ISNULL(SUM(B.BadQty),0)  AS test3
INTO #TEMP3
FROM 
(
    SELECT *
    FROM _TDAUMinor
    WHERE MajorSeq=2000311
)
   AS A
LEFT OUTER JOIN minjun_TLGQCBadInfoItem  AS  B  ON B.CompanySeq = A.CompanySeq
                                               AND B.BadType    = A.MinorSeq
                                               AND QCType       = 2000310003
GROUP BY A.MinorName, A.CompanySeq



SELECT CompanySeq, BadDate
INTO #TEMP4
FROM minjun_TLGQCBadInfo




SELECT           A.MinorName AS BadType , A.test1, B.test2, C.test3, (A.test1 + B.test2 + C.test3)  AS total, @BadDateFr AS BadDateFr, @BadDateTo AS BadDateTo
FROM             #TEMP1                     AS A
LEFT OUTER JOIN  #TEMP2                     AS B        ON  B.MinorName  = A.MinorName
                                                       AND  B.CompanySeq = A.CompanySeq
LEFT OUTER JOIN  #TEMP3                     AS C        ON  C.MinorName  = A.MinorName
                                                       AND  C.CompanySeq = A.CompanySeq
LEFT OUTER JOIN  #TEMP4                     AS D        ON  D.CompanySeq = A.CompanySeq


WHERE D.BadDate                 BETWEEN @BadDateFr        And @BadDateTo
GROUP BY A.MinorName, A.test1, B.test2, C.test3



RETURN  

