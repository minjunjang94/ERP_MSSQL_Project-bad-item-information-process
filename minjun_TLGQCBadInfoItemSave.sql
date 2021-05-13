IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_TLGQCBadInfoItemSave' AND xtype = 'P')    
    DROP PROC minjun_TLGQCBadInfoItemSave
GO
    
/*************************************************************************************************    
 ��  �� - SP-�ҷ�ǰ����������_minjun
 �ۼ��� - '2020-04-13
 �ۼ��� - �����
 ������ - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_TLGQCBadInfoItemSave
    @ServiceSeq    INT          = 0 ,   -- ���� �����ڵ�
    @WorkingTag    NVARCHAR(10) = '',   -- WorkingTag
    @CompanySeq    INT          = 1 ,   -- ���� �����ڵ�
    @LanguageSeq   INT          = 1 ,   -- ��� �����ڵ�
    @UserSeq       INT          = 0 ,   -- ����� �����ڵ�
    @PgmSeq        INT          = 0 ,   -- ���α׷� �����ڵ�
    @IsTransaction BIT          = 0     -- Ʈ������ ����
AS
    DECLARE @TblName        NVARCHAR(MAX)   -- Table��
           ,@ItemTblName    NVARCHAR(MAX)   -- ��Table��
           ,@SeqName        NVARCHAR(MAX)   -- Seq��
           ,@SerlName       NVARCHAR(MAX)   -- Serl��
           ,@SQL            NVARCHAR(MAX)
           ,@TblColumns     NVARCHAR(MAX)
           ,@Seq            INT
    
    -- ���̺�, Ű�� ��Ī
    SELECT  @TblName        = N'minjun_TLGQCBadInfoItem'
           ,@SeqName        = N'BadSeq'
           ,@SerlName       = N'BadSerl'
           --,@SQL            = N''

    -- �α����̺� �����(������ �Ķ���ʹ� �ݵ�� ���ٷ� ������)  	
	SELECT @TblColumns = dbo._FGetColumnsForLog(@TblName)
    
    EXEC _SCOMLog @CompanySeq
                 ,@UserSeq   
                 ,@TblName                  -- ���̺��      
                 ,'#BIZ_OUT_DataBlock2'     -- �ӽ� ���̺��      
                 ,@SeqName                  -- CompanySeq�� ������ Ű(Ű�� �������� ���� , �� ���� )      
                 ,@TblColumns               -- ���̺� ��� �ʵ��
                 ,''
                 ,@PgmSeq
        
    -- =============================================================================================================================================
    -- DELETE
    -- =============================================================================================================================================
    IF EXISTS (SELECT 1 FROM #BIZ_OUT_DataBlock2 WHERE WorkingTag = 'D' AND Status = 0 )    
    BEGIN
        -- Detail���̺� ������ ����
        DELETE  A
          FROM  #BIZ_OUT_DataBlock2         AS M
                JOIN minjun_TLGQCBadInfoItem          AS A  WITH(NOLOCK)  ON  A.CompanySeq    = @CompanySeq
                                                                         AND  A.BadSeq        = M.BadSeq
                                                                         AND  A.BadSerl       = M.BadSerl
         WHERE  M.WorkingTag    = 'D'
           AND  M.Status        = 0

        IF @@ERROR <> 0 RETURN
        
     --  -- Master���̺� ������ ����
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