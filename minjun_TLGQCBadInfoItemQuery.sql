IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_TLGQCBadInfoItemQuery' AND xtype = 'P')    
    DROP PROC minjun_TLGQCBadInfoItemQuery
GO
    
/*************************************************************************************************    
 설  명 - SP-불량품목정보조회_minjun
 작성일 - '2020-04-13
 작성자 - 장민준
 수정자 - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_TLGQCBadInfoItemQuery
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
             @BadSeq            INT


    -- 조회조건 받아오기
    SELECT  
      @BadSeq                             = RTRIM(LTRIM(ISNULL(M.BadSeq       ,   0)))



      FROM  #BIZ_IN_DataBlock2      AS M

    -- 조회결과 담아주기

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


