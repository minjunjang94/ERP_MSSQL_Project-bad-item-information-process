IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_FrmLGQCBadInfoListQuery' AND xtype = 'P')    
    DROP PROC minjun_FrmLGQCBadInfoListQuery
GO
    
/*************************************************************************************************    
 설  명 - SP-불량품목리스트조회_minjun
 작성일 - '2020-04-14
 작성자 - 장민준
 수정자 - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_FrmLGQCBadInfoListQuery
    @ServiceSeq    INT          = 0 ,   -- 서비스 내부코드
    @WorkingTag    NVARCHAR(10) = '',   -- WorkingTag
    @CompanySeq    INT          = 1 ,   -- 법인 내부코드
    @LanguageSeq   INT          = 1 ,   -- 언어 내부코드
    @UserSeq       INT          = 0 ,   -- 사용자 내부코드
    @PgmSeq        INT          = 0 ,   -- 프로그램 내부코드
    @IsTransaction BIT          = 0     -- 트랜젝션 여부
AS
    -- 변수선언
    DECLARE

             
             @BizUnitSeq             INT
            ,@BadDateFr              NCHAR(8)
            ,@BadDateTo              NCHAR(8)
            ,@AssetSeq               INT
            ,@BadType                INT
            ,@QCTypeSeq              INT
            ,@ItemSeq                INT
            ,@BadOccDeptSeq          INT
            ,@CustSeq                INT
            ,@EmpSeq                 INT
            ,@DeptSeq                INT
            ,@BadSeq                 INT


    -- 조회조건 받아오기
    SELECT   @BadDateFr       = RTRIM(LTRIM(ISNULL(M.BadDateFr          , '')))
            ,@BadDateTo       = RTRIM(LTRIM(ISNULL(M.BadDateTo          , '')))
            ,@BizUnitSeq      = RTRIM(LTRIM(ISNULL(M.BizUnitSeq         ,  0)))
            ,@AssetSeq        = RTRIM(LTRIM(ISNULL(M.AssetSeq           ,  0)))
            ,@BadType         = RTRIM(LTRIM(ISNULL(M.BadType            ,  0)))
            ,@QCTypeSeq       = RTRIM(LTRIM(ISNULL(M.QCTypeSeq          ,  0)))
            ,@ItemSeq         = RTRIM(LTRIM(ISNULL(M.ItemSeq            ,  0)))
            ,@BadOccDeptSeq   = RTRIM(LTRIM(ISNULL(M.BadOccDeptSeq      ,  0)))
            ,@CustSeq         = RTRIM(LTRIM(ISNULL(M.CustSeq            ,  0)))
            ,@EmpSeq          = RTRIM(LTRIM(ISNULL(M.EmpSeq             ,  0)))
            ,@DeptSeq         = RTRIM(LTRIM(ISNULL(M.DeptSeq            ,  0)))
            ,@BadSeq          = RTRIM(LTRIM(ISNULL(M.BadSeq             ,  0)))     




      FROM  #BIZ_IN_DataBlock1      AS M
      

          IF @BadDateFr = ''   SET @BadDateFr = '19000101'
          IF @BadDateTo = ''   SET @BadDateTo = '99991231'    



    -- 조회결과 담아주기


    SELECT  
                                                                   
             C.BizUnitName                AS BizUnit
            ,D1.AssetName
            ,M6.MinorName                 AS BadType        --불량유형 
            ,M1.MinorName                 AS QCTypeName
            ,D.ItemName
            ,D.ItemNo
            ,F1.DeptName                  AS BadOccDeptName
            ,F2.CustName                  AS CustName
            ,E.EmpName                                      --입력담당
            ,F.DeptName                                     --입력부서
            ,D.Spec
            ,Z.UnitName                   AS STDUnitName    --단위
            ,B.BadQty
            ,B.Remark
            ,H1.ItemClassLName                           --품목대분류
            ,H1.ItemClassMName                           --품목중분류
            ,H1.ItemClassSName                           --품목소분류
            ,A.BadNo
            ,A.BadSeq

      FROM  minjun_TLGQCBadInfo                          AS A  WITH(NOLOCK)
      LEFT OUTER JOIN   minjun_TLGQCBadInfoItem          AS B  WITH(NOLOCK)         ON B.CompanySeq      = A.CompanySeq
                                                                                   AND B.BadSeq          = A.BadSeq
      LEFT OUTER JOIN   _TDABizUnit                      AS C  WITH(NOLOCK)         ON C.CompanySeq      = A.CompanySeq
                                                                                   AND C.BizUnit         = A.BizUnit
      LEFT OUTER JOIN   _TDAItem                         AS D  WITH(NOLOCK)         ON D.CompanySeq      = B.CompanySeq
                                                                                   AND D.ItemSeq         = B.ItemSeq

	  LEFT OUTER JOIN   _TDAItemClass                    AS H                       ON H.CompanySeq      = B.CompanySeq
                                                                                   AND H.ItemSeq         = B.ItemSeq  
                                                                                   AND H.UMajorItemClass = 2001
	  LEFT OUTER JOIN   _VDAItemClass                    AS H1                      ON H1.CompanySeq      = H.CompanySeq
                                                                                   AND H1.ItemClassSSeq   = H.UMItemClass
                                                                                   

      LEFT OUTER JOIN   _TDAUnit                         AS Z                       ON Z.CompanySeq      = D.CompanySeq
                                                                                   AND Z.UnitSeq         = D.UnitSeq


      LEFT OUTER JOIN   _TDAItemAsset                    AS D1 WITH(NOLOCK)         ON D1.CompanySeq     = D.CompanySeq
                                                                                   AND D1.AssetSeq       = D.AssetSeq
      LEFT OUTER JOIN   _TDAEmp                          AS E  WITH(NOLOCK)         ON E.CompanySeq      = A.CompanySeq
                                                                                   AND E.EmpSeq          = A.EmpSeq                                                                                   
      LEFT OUTER JOIN   _TDADept                         AS F  WITH(NOLOCK)         ON F.CompanySeq      = A.CompanySeq
                                                                                   AND F.DeptSeq         = A.DeptSeq                                                                                
      LEFT OUTER JOIN   _TDADept                         AS F1  WITH(NOLOCK)        ON F1.CompanySeq     = B.CompanySeq
                                                                                   AND F1.DeptSeq        = B.BadOccDeptSeq
      LEFT OUTER JOIN   _TDACust                         AS F2  WITH(NOLOCK)        ON F2.CompanySeq     = B.CompanySeq
                                                                                   AND F2.CustSeq        = B.CustSeq
      LEFT OUTER JOIN   (select * from _TDAUMinor where  MajorSeq=2000310)                       
                                                         AS M1                      ON M1.CompanySeq     = B.CompanySeq
                                                                                   AND M1.MinorSeq       = B.QCType     --검사구분   
                                                                                   

      LEFT OUTER JOIN   (select * from _TDAUMinor where  MajorSeq=2000311)  
                                                         AS M6                      ON M6.CompanySeq     = B.CompanySeq
                                                                                   AND M6.MinorSeq       = B.BadType     --불량유형   



     WHERE  A.CompanySeq    = @CompanySeq
       AND (A.BadDate                 BETWEEN @BadDateFr        And @BadDateTo)
       AND (@BizUnitSeq               = 0                  OR  A.BizUnit            = @BizUnitSeq                )
       AND (@AssetSeq                 = 0                  OR  D1.AssetSeq          = @AssetSeq                  )
       AND (@BadType                  = 0                  OR  B.BadType            = @BadType                   )
       AND (@QCTypeSeq                = 0                  OR  B.QCType             = @QCTypeSeq                 )
       AND (@ItemSeq                  = 0                  OR  B.ItemSeq            = @ItemSeq                   )
       AND (@BadOccDeptSeq            = 0                  OR  B.BadOccDeptSeq      = @BadOccDeptSeq             )
       AND (@CustSeq                  = 0                  OR  B.CustSeq            = @CustSeq                   )
       AND (@EmpSeq                   = 0                  OR  A.EmpSeq             = @EmpSeq                    )
       AND (@DeptSeq                  = 0                  OR  A.DeptSeq            = @DeptSeq                   )
       AND (@BadSeq                   = 0                  OR  A.BadSeq             = @BadSeq                    )

RETURN