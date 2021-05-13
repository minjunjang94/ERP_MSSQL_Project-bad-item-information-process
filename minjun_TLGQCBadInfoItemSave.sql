IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_TLGQCBadInfoItemSave' AND xtype = 'P')    
    DROP PROC minjun_TLGQCBadInfoItemSave
GO
    
/*************************************************************************************************    
 설  명 - SP-불량품목정보저장_minjun
 작성일 - '2020-04-13
 작성자 - 장민준
 수정자 - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_TLGQCBadInfoItemSave
    @ServiceSeq    INT          = 0 ,   -- 서비스 내부코드
    @WorkingTag    NVARCHAR(10) = '',   -- WorkingTag
    @CompanySeq    INT          = 1 ,   -- 법인 내부코드
    @LanguageSeq   INT          = 1 ,   -- 언어 내부코드
    @UserSeq       INT          = 0 ,   -- 사용자 내부코드
    @PgmSeq        INT          = 0 ,   -- 프로그램 내부코드
    @IsTransaction BIT          = 0     -- 트랜젝션 여부
AS
    DECLARE @TblName        NVARCHAR(MAX)   -- Table명
           ,@ItemTblName    NVARCHAR(MAX)   -- 상세Table명
           ,@SeqName        NVARCHAR(MAX)   -- Seq명
           ,@SerlName       NVARCHAR(MAX)   -- Serl명
           ,@SQL            NVARCHAR(MAX)
           ,@TblColumns     NVARCHAR(MAX)
           ,@Seq            INT
    
    -- 테이블, 키값 명칭
    SELECT  @TblName        = N'minjun_TLGQCBadInfoItem'
           ,@SeqName        = N'BadSeq'
           ,@SerlName       = N'BadSerl'
           --,@SQL            = N''

    -- 로그테이블 남기기(마지막 파라메터는 반드시 한줄로 보내기)  	
	SELECT @TblColumns = dbo._FGetColumnsForLog(@TblName)
    
    EXEC _SCOMLog @CompanySeq
                 ,@UserSeq   
                 ,@TblName                  -- 테이블명      
                 ,'#BIZ_OUT_DataBlock2'     -- 임시 테이블명      
                 ,@SeqName                  -- CompanySeq를 제외한 키(키가 여러개일 경우는 , 로 연결 )      
                 ,@TblColumns               -- 테이블 모든 필드명
                 ,''
                 ,@PgmSeq
        
    -- =============================================================================================================================================
    -- DELETE
    -- =============================================================================================================================================
    IF EXISTS (SELECT 1 FROM #BIZ_OUT_DataBlock2 WHERE WorkingTag = 'D' AND Status = 0 )    
    BEGIN
        -- Detail테이블 데이터 삭제
        DELETE  A
          FROM  #BIZ_OUT_DataBlock2         AS M
                JOIN minjun_TLGQCBadInfoItem          AS A  WITH(NOLOCK)  ON  A.CompanySeq    = @CompanySeq
                                                                         AND  A.BadSeq        = M.BadSeq
                                                                         AND  A.BadSerl       = M.BadSerl
         WHERE  M.WorkingTag    = 'D'
           AND  M.Status        = 0

        IF @@ERROR <> 0 RETURN
        
     --  -- Master테이블 데이터 삭제
     --  DELETE  A
     --    FROM  #BIZ_OUT_DataBlock2         AS M
     --          JOIN minjun_TLGQCBadInfoItem              AS A  WITH(NOLOCK)  ON  A.CompanySeq    = @CompanySeq
     --                                                         AND  A.BadSeq      = M.BadSeq
     --   WHERE  M.WorkingTag    = 'D'
     --     AND  M.Status        = 0
     --
     --  IF @@ERROR <> 0 RETURN
    END

    -- =============================================================================================================================================
    -- Update
    -- =============================================================================================================================================
    IF EXISTS (SELECT 1 FROM #BIZ_OUT_DataBlock2 WHERE WorkingTag = 'U' AND Status = 0 )    
    BEGIN
        UPDATE  A 
           SET  
                   ItemSeq            = M.ItemSeq           
                  ,QCType             = M.QCType        
                  ,BadType            = M.BadType     
                  ,STDUnitSeq         = M.STDUnitSeq    
                  ,BadQty             = M.BadQty        
                  ,BadOccDeptSeq      = M.BadOccDeptSeq 
                  ,CustSeq            = M.CustSeq       
                  ,Remark             = M.Remark 
                  ,BadSerl            = M.BadSerl       
                  ,LastUserSeq        = @UserSeq
                  ,LastDateTime       = GETDATE()
                  ,PgmSeq             = @PgmSeq
           
         

          FROM  #BIZ_OUT_DataBlock2                                 AS M
               join minjun_TLGQCBadInfoItem                         AS A  WITH(NOLOCK)  ON  A.CompanySeq     = @CompanySeq
                                                                                        AND A.BadSeq        = M.BadSeq
                                                                                        and A.BadSerl        = M.BadSerl



         WHERE  M.WorkingTag    = 'U'
           AND  M.Status        = 0

        IF @@ERROR <> 0 RETURN
    END

    -- =============================================================================================================================================
    -- INSERT
    -- =============================================================================================================================================
    IF EXISTS (SELECT 1 FROM #BIZ_OUT_DataBlock2 WHERE WorkingTag = 'A' AND Status = 0 )    
    BEGIN
        INSERT INTO minjun_TLGQCBadInfoItem (

                 CompanySeq
                ,BadSeq
                ,ItemSeq
                ,QCType        
                ,BadType       
                ,STDUnitSeq    
                ,BadQty        
                ,BadOccDeptSeq 
                ,CustSeq       
                ,Remark        
                ,BadSerl       
                ,LastUserSeq  
                ,LastDateTime 
                ,PgmSeq            
                  
        )
        SELECT

        @CompanySeq
        ,M.BadSeq
        ,M.ItemSeq
        ,M.QCType
        ,M.BadType
        ,M.STDUnitSeq
        ,M.BadQty
        ,M.BadOccDeptSeq
        ,M.CustSeq
        ,M.Remark
        ,M.BadSerl
        ,@UserSeq
        ,GETDATE()
        ,@PgmSeq        
        
         
          FROM  #BIZ_OUT_DataBlock2         AS M
         WHERE  M.WorkingTag    = 'A'
           AND  M.Status        = 0

        IF @@ERROR <> 0 RETURN
    END

RETURN


--delete from minjun_TLGQCBadInfoItem 