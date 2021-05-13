IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_TLGQCBadInfoItemQuery' AND xtype = 'P')    
    DROP PROC minjun_TLGQCBadInfoItemQuery
GO
    
/*************************************************************************************************    
 ��  �� - SP-�ҷ�ǰ��������ȸ_minjun
 �ۼ��� - '2020-04-13
 �ۼ��� - �����
 ������ - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_TLGQCBadInfoItemQuery
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
             @BadSeq            INT


    -- ��ȸ���� �޾ƿ���
    SELECT  
      @BadSeq                             = RTRIM(LTRIM(ISNULL(M.BadSeq       ,   0)))



      FROM  #BIZ_IN_DataBlock2      AS M

    -- ��ȸ��� ����ֱ�

    SELECT   C.ItemName              AS  ItemName      
            ,C.ItemNo                AS  ItemNo        
            ,C.Spec                  AS  Spec          
            ,D.AssetName             AS  AssetName     
            ,A.QCType                AS  QCType        
            ,A.BadType               AS  BadType       
            ,S.UnitName              AS  STDUnitName 
            ,S.UnitSeq               AS  STDUnitSeq   
            ,A.BadQty                AS  BadQty    
            ,D1.DeptName             AS  BadOccDeptName
            ,Z.CustName              AS  CustName    
            ,A.Remark                AS  Remark    
            ,C.ItemSeq               AS  ItemSeq
            ,A.BadSeq                AS  BadSeq 
            ,A.BadSerl              
            
      FROM             minjun_TLGQCBadInfoItem    AS A        
      LEFT OUTER JOIN  minjun_TLGQCBadInfo        AS B         WITH(NOLOCK)  ON  B.CompanySeq    = A.CompanySeq
                                                                            AND  B.BadSeq        = A.BadSeq
      LEFT OUTER JOIN  _TDAItem                   AS C         WITH(NOLOCK)  ON  C.CompanySeq    = A.CompanySeq
                                                                            AND  C.ItemSeq       = A.ItemSeq
      LEFT OUTER JOIN  _TDAItemAsset              AS D         WITH(NOLOCK)  ON  D.CompanySeq    = C.CompanySeq
                                                                            AND  D.AssetSeq      = C.AssetSeq   
      LEFT OUTER JOIN  _TDAUnit                   AS S         WITH(NOLOCK)  ON  S.CompanySeq    = C.CompanySeq
                                                                            AND  S.UnitSeq       = C.UnitSeq      
      LEFT OUTER JOIN  _TDADept                   AS D1        WITH(NOLOCK)  ON  D1.CompanySeq   = A.CompanySeq
                                                                            AND  D1.DeptSeq      = A.BadOccDeptSeq                                                                                                                                                                    
      LEFT OUTER JOIN  _TDACust                   AS Z         WITH(NOLOCK)  ON  Z.CompanySeq    = A.CompanySeq
                                                                            AND  Z.CustSeq       = A.CustSeq     

    WHERE   A.CompanySeq    = @CompanySeq
      AND   A.BadSeq        = @BadSeq

RETURN


