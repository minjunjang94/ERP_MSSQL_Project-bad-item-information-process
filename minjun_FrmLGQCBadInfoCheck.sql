IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_FrmLGQCBadInfoCheck' AND xtype = 'P')    
    DROP PROC minjun_FrmLGQCBadInfoCheck
GO
    
/*************************************************************************************************    
 설  명 - SP-불량정보체크_minjun
 작성일 - '2020-04-13
 작성자 - 장민준
 수정자 - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_FrmLGQCBadInfoCheck
    @ServiceSeq    INT          = 0 ,   -- 서비스 내부코드
    @WorkingTag    NVARCHAR(10) = '',   -- WorkingTag
    @CompanySeq    INT          = 1 ,   -- 법인 내부코드
    @LanguageSeq   INT          = 1 ,   -- 언어 내부코드
    @UserSeq       INT          = 0 ,   -- 사용자 내부코드
    @PgmSeq        INT          = 0 ,   -- 프로그램 내부코드
    @IsTransaction BIT          = 0     -- 트랜젝션 여부
AS
    DECLARE @MessageType    INT             -- 오류메시지 타입
           ,@Status         INT             -- 상태변수
           ,@Results        NVARCHAR(250)   -- 결과문구
           ,@Count          INT             -- 채번데이터 Row 수
           ,@Seq            INT             -- Seq
           ,@MaxNo          NVARCHAR(20)    -- 채번 데이터 최대 No
           ,@Date           NCHAR(8)        -- Date
           ,@TblName        NVARCHAR(MAX)   -- Table명
           ,@SeqName        NVARCHAR(MAX)   -- Table 키값 명
    
    -- 테이블, 키값 명칭
    SELECT  @TblName    = N'minjun_TLGQCBadInfo'
           ,@SeqName    = N'BadSeq'
    
  -- -- 체크구문
  -- EXEC dbo._SCOMMessage   @MessageType    OUTPUT
  --                        ,@Status         OUTPUT
  --                        ,@Results        OUTPUT
  --                        ,0                       -- SELECT * FROM _TCAMessageLanguage WITH(NOLOCK) WHERE LanguageSeq = 1 AND Message LIKE '%%'
  --                        ,@LanguageSeq
  --                        ,0, ''                   -- SELECT * FROM _TCADictionary WITH(NOLOCK) WHERE LanguageSeq = 1 AND Word LIKE '%%'
  --                        ,0, ''                   -- SELECT * FROM _TCADictionary WITH(NOLOCK) WHERE LanguageSeq = 1 AND Word LIKE '%%'
  -- UPDATE  #BIZ_OUT_DataBlock1
  --    SET  Result          = @Results
  --        ,MessageType     = @MessageType
  --        ,Status          = @Status
  --   FROM  #BIZ_OUT_DataBlock1     AS M
  --  WHERE  M.WorkingTag IN('')
  --    AND  M.Status = 0

    -- 채번해야 하는 데이터 수 확인
    SELECT @Count = COUNT(1) FROM #BIZ_OUT_DataBlock1 WHERE WorkingTag = 'A' AND Status = 0 
     
    -- 채번
    IF @Count > 0
    BEGIN
        -- 내부코드채번 : 테이블별로 시스템에서 Max값으로 자동 채번된 값을 리턴하여 채번
        EXEC @Seq = dbo._SCOMCreateSeq @CompanySeq, @TblName, @SeqName, @Count
        
        UPDATE  #BIZ_OUT_DataBlock1
           SET  BadSeq = @Seq + DataSeq
         WHERE  WorkingTag  = 'A'
           AND  Status      = 0



        
        -- 외부번호 채번에 쓰일 일자값
        SELECT @Date = CONVERT(NVARCHAR(8), GETDATE(), 112)        
        
        -- 외부번호채번 : 업무별 외부키생성정의등록 화면에서 정의된 채번규칙으로 채번
        EXEC dbo._SCOMCreateNo 'SL', @TblName, @CompanySeq, '', @Date, @MaxNo OUTPUT
        
        UPDATE  #BIZ_OUT_DataBlock1
           SET  BadNo  = @MaxNo
         WHERE  WorkingTag  = 'A'
           AND  Status      = 0
    END

RETURN