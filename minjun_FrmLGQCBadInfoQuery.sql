IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_FrmLGQCBadInfoQuery' AND xtype = 'P')    
    DROP PROC minjun_FrmLGQCBadInfoQuery
GO
    
/*************************************************************************************************    
 설  명 - SP-불량정보조회_minjun
 작성일 - '2020-04-13
 작성자 - 장민준
 수정자 - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_FrmLGQCBadInfoQuery
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
         @BadSeq       INT



    -- 조회조건 받아오기
    SELECT   @BadSeq    = RTRIM(LTRIM(ISNULL(M.BadSeq        ,  0 )))

      FROM  #BIZ_IN_DataBlock1      AS M

    -- 조회결과 담아주기
    SELECT  A.BizUnit
           ,A.BadDate
           ,A.EmpSeq
           ,A.DeptSeq
           ,A.BadNo
           ,A.BadSeq

      FROM             minjun_TLGQCBadInfo        AS A        

     WHERE  A.CompanySeq    = @CompanySeq
     and A.BadSeq = @BadSeq
RETURN