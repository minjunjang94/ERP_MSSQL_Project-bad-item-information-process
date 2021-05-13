IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_FrmLGQCBadInfoSave' AND xtype = 'P')    
    DROP PROC minjun_FrmLGQCBadInfoSave
GO
    
/*************************************************************************************************    
 ��  �� - SP-�ҷ���������_minjun
 �ۼ��� - '2020-04-13
 �ۼ��� - �����
 ������ - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_FrmLGQCBadInfoSave
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
    SELECT  @TblName        = N'minjun_TLGQCBadInfo'
           ,@ItemTblName    = N'minjun_TLGQCBadInfoItem'
           ,@SeqName        = N'BadSeq'
           --,@SerlName       = N'BadSerl'
           --,@SQL            = N''

    -- �α����̺� �����(������ �Ķ���ʹ� �ݵ�� ���ٷ� ������)  	
	SELECT @TblColumns = dbo._FGetColumnsForLog(@TblName)
    
    EXEC _SCOMLog @CompanySeq
                 ,@UserSeq   
                 ,@TblName                  -- ���̺��      
                 ,'#BIZ_OUT_DataBlock1'     -- �ӽ� ���̺��      
                 ,@SeqName                  -- CompanySeq�� ������ Ű(Ű�� �������� ���� , �� ���� )      
                 ,@TblColumns               -- ���̺� ��� �ʵ��
                 ,''
                 ,@PgmSeq
                    
    -- =============================================================================================================================================
    -- DELETE
    -- =============================================================================================================================================
    IF EXISTS (SELECT 1 FROM #BIZ_OUT_DataBlock1 WHERE WorkingTag = 'D' AND Status = 0 )    
    BEGIN
        -- Detail���̺� �����α� �����
        SELECT  @ItemTblName    = @TblName + N'Item'

        -- Detail���̺� �÷��� ��������
        SELECT  @TblColumns     = dbo._FGetColumnsForLog(@ItemTblName)

        -- Query �������� ���
        SELECT  @SQL    = N''
        SELECT  @SQL    = N'
        INSERT INTO '+@ItemTblName+N'Log('+
            @TblColumns + N'
           ,LogUserSeq
           ,LogDateTime
           ,LogType 
           ,LogPgmSeq
        )
        SELECT  '+@TblColumns+N'
               ,CONVERT(INT, '+CONVERT(NVARCHAR, @UserSeq)+N')
               ,GETDATE()
               ,''D''
               ,CONVERT(INT, '+CONVERT(NVARCHAR, @PgmSeq)+N')
          FROM  '+@ItemTblName+N'  WITH(NOLOCK)
         WHERE  CompanySeq = CONVERT(INT, '+CONVERT(NVARCHAR, @CompanySeq)+')
           AND  '+@SeqName+N' = CONVERT(INT, '+CONVERT(NVARCHAR, @Seq)+')'
        
        -- Query ����
        EXEC SP_EXECUTESQL @SQL

        IF @@ERROR <> 0 RETURN

       -- Detail���̺� ������ ����
       DELETE  A
         FROM  #BIZ_OUT_DataBlock1         AS M
               JOIN minjun_TLGQCBadInfoItem          AS A  WITH(NOLOCK)  ON  A.CompanySeq    = @CompanySeq
                                                                        AND  A.BadSeq        = M.BadSeq
        WHERE  M.WorkingTag    = 'D'
          AND  M.Status        = 0
      
       IF @@ERROR <> 0 RETURN
        
        -- Master���̺� ������ ����
        DELETE  A
          FROM  #BIZ_OUT_DataBlock1         AS M
                JOIN minjun_TLGQCBadInfo              AS A  WITH(NOLOCK)  ON  A.CompanySeq    = @CompanySeq
                                                                         AND  A.BadSeq        = M.BadSeq
         WHERE  M.WorkingTag    = 'D'
           AND  M.Status        = 0

        IF @@ERROR <> 0 RETURN
    END

    -- =============================================================================================================================================
    -- Update
    -- =============================================================================================================================================
    IF EXISTS (SELECT 1 FROM #BIZ_OUT_DataBlock1 WHERE WorkingTag = 'U' AND Status = 0 )    
    BEGIN
        UPDATE  A 
           SET  
                 BizUnit        = M.BizUnit
                ,BadDate        = M.BadDate   
                ,EmpSeq         = M.EmpSeq
                ,DeptSeq        = M.DeptSeq
                ,BadNo          = M.BadNo
                ,LastUserSeq    = @UserSeq
                ,LastDateTime   = GETDATE()
                ,PgmSeq         = @PgmSeq





          FROM  #BIZ_OUT_DataBlock1         AS M
                JOIN minjun_TLGQCBadInfo              AS A  WITH(NOLOCK)  ON  A.CompanySeq    = @CompanySeq
                                                                         AND  A.BadSeq        = M.BadSeq
         WHERE  M.WorkingTag    = 'U'
           AND  M.Status        = 0

        IF @@ERROR <> 0 RETURN
    END

    -- =============================================================================================================================================
    -- INSERT
    -- =============================================================================================================================================
    IF EXISTS (SELECT 1 FROM #BIZ_OUT_DataBlock1 WHERE WorkingTag = 'A' AND Status = 0 )    
    BEGIN
        INSERT INTO minjun_TLGQCBadInfo (
                 CompanySeq
                ,BadSeq
                ,BizUnit        
                ,BadDate         
                ,EmpSeq         
                ,DeptSeq        
                ,BadNo
                ,LastUserSeq 
                ,LastDateTime
                ,PgmSeq      
                
                          
        )
        SELECT  
             @CompanySeq
            ,M.BadSeq
            ,M.BizUnit
            ,M.BadDate 
            ,M.EmpSeq
            ,M.DeptSeq
            ,M.BadNo  
            ,@UserSeq
            ,GETDATE()
            ,@PgmSeq



          FROM  #BIZ_OUT_DataBlock1         AS M
         WHERE  M.WorkingTag    = 'A'
           AND  M.Status        = 0

        IF @@ERROR <> 0 RETURN
    END

RETURN