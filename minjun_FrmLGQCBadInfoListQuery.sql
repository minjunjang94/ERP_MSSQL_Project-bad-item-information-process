IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_FrmLGQCBadInfoListQuery' AND xtype = 'P')    
    DROP PROC minjun_FrmLGQCBadInfoListQuery
GO
    
/*************************************************************************************************    
 ��  �� - SP-�ҷ�ǰ�񸮽�Ʈ��ȸ_minjun
 �ۼ��� - '2020-04-14
 �ۼ��� - �����
 ������ - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_FrmLGQCBadInfoListQuery
    @ServiceSeq    INT          = 0 ,   -- ���� �����ڵ�
    @WorkingTag    NVARCHAR(10) = '',   -- WorkingTag
    @CompanySeq    INT          = 1 ,   -- ���� �����ڵ�
    @LanguageSeq   INT          = 1 ,   -- ��� �����ڵ�
    @UserSeq       INT          = 0 ,   -- ����� �����ڵ�
    @PgmSeq        INT          = 0 ,   -- ���α׷� �����ڵ�
    @IsTransaction BIT          = 0     -- Ʈ������ ����
AS
    -- ��������
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


    -- ��ȸ���� �޾ƿ���
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



    -- ��ȸ��� ����ֱ�


    SELECT  
                                                                   
             C.BizUnitName                AS BizUnit
            ,D1.AssetName
            ,M6.MinorName                 AS BadType        --�ҷ����� 
            ,M1.MinorName                 AS QCTypeName
            ,D.ItemName
            ,D.ItemNo
            ,F1.DeptName                  AS BadOccDeptName
            ,F2.CustName                  AS CustName
            ,E.EmpName                                      --�Է´��
            ,F.DeptName                                     --�Էºμ�
            ,D.Spec
            ,Z.UnitName                   AS STDUnitName    --����
            ,B.BadQty
            ,B.Remark
            ,H1.ItemClassLName                           --ǰ���з�
            ,H1.ItemClassMName                           --ǰ���ߺз�
            ,H1.ItemClassSName                           --ǰ��Һз�
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
                                                                                   AND M1.MinorSeq       = B.QCType     --�˻籸��   
                                                                                   

      LEFT OUTER JOIN   (select * from _TDAUMinor where  MajorSeq=2000311)  
                                                         AS M6                      ON M6.CompanySeq     = B.CompanySeq
                                                                                   AND M6.MinorSeq       = B.BadType     --�ҷ�����   



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