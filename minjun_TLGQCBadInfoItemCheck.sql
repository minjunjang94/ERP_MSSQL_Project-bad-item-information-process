IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_TLGQCBadInfoItemCheck' AND xtype = 'P')    
    DROP PROC minjun_TLGQCBadInfoItemCheck
GO
    
/*************************************************************************************************    
 ��  �� - SP-�ҷ�ǰ������üũ_minjun
 �ۼ��� - '2020-04-13
 �ۼ��� - �����
 ������ - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_TLGQCBadInfoItemCheck
    @ServiceSeq    INT          = 0 ,   -- ���� �����ڵ�
    @WorkingTag    NVARCHAR(10) = '',   -- WorkingTag
    @CompanySeq    INT          = 1 ,   -- ���� �����ڵ�
    @LanguageSeq   INT          = 1 ,   -- ��� �����ڵ�
    @UserSeq       INT          = 0 ,   -- ����� �����ڵ�
    @PgmSeq        INT          = 0 ,   -- ���α׷� �����ڵ�
    @IsTransaction BIT          = 0     -- Ʈ������ ����
AS
    DECLARE @MessageType    INT             -- �����޽��� Ÿ��
           ,@Status         INT             -- ���º���
           ,@Results        NVARCHAR(250)   -- �������
           ,@Count          INT             -- ä�������� Row ��
           ,@Seq            INT             -- Seq
           ,@MaxNo          NVARCHAR(20)    -- ä�� ������ �ִ� No
           ,@Date           NCHAR(8)        -- Date
           ,@MaxSerl        INT             -- Serl�� �ִ밪
           ,@TblName        NVARCHAR(MAX)   -- Table��
           ,@SeqName        NVARCHAR(MAX)   -- Table Ű�� ��
           ,@SerlName       NVARCHAR(MAX)   -- Serl��
    
    -- ���̺�, Ű�� ��Ī
    SELECT  @TblName    = N'minjun_TLGQCBadInfoItem'
           ,@SeqName    = N'BadSeq'
       --    ,@MaxSerl    = (SELECT MAX(BadSerl) FROM minjun_TLGQCBadInfoItem WHERE BadSeq =)
           ,@SerlName   = N'BadSerl'


    SELECT @MaxSerl = MAX(A.BadSerl)
      FROM minjun_TLGQCBadInfoItem AS A
            JOIN #BIZ_OUT_DataBlock2 AS B ON A.BadSeq = B.BadSeq
        WHERE A.CompanySeq = @CompanySeq 
          AND B.WorkingTag = 'A' AND B.Status = 0

    -- ä���ؾ� �ϴ� ������ �� Ȯ��
  --  SELECT @Count = COUNT(1) FROM #BIZ_OUT_DataBlock2 WHERE WorkingTag = 'A' AND Status = 0 
     
    -- ä��

        -- �����ڵ�ä�� : ���̺��� �ý��ۿ��� Max������ �ڵ� ä���� ���� �����Ͽ� ä��
    IF @MaxSerl IS NULL
        SELECT @MaxSerl = 0

        UPDATE  #BIZ_OUT_DataBlock2
           SET  BadSerl = @MaxSerl + DataSeq
         WHERE  WorkingTag  = 'A'
           AND  Status      = 0



 --     -- ä��
 --   IF @Count > 0
 --   BEGIN
 --       -- Serl Max�� ��������
 --       SELECT  @MaxSerl    = MAX(ISNULL(A.TableSerl, 0))
 --         FROM  #Temp                 AS M
 --               LEFT OUTER JOIN TableName  AS A  WITH(NOLOCK)  ON  A.CompanySeq    = @CompanySeq
 --                                                             AND  A.TableSeq      = M.TableSeq
 --        WHERE  M.WorkingTag IN('A')
 --          AND  M.Status = 0                    
 --       
 --       UPDATE  #Temp
 --          SET  TableSerl = @MaxSerl + DataSeq
 --        WHERE  WorkingTag  = 'A'
 --          AND  Status      = 0
 --   END


           
                 
    --    -- �ܺι�ȣ ä���� ���� ���ڰ�
    --    SELECT @Date = CONVERT(NVARCHAR(8), GETDATE(), 112)        
    --    
    --    -- �ܺι�ȣä�� : ������ �ܺ�Ű�������ǵ�� ȭ�鿡�� ���ǵ� ä����Ģ���� ä��
    --    EXEC dbo._SCOMCreateNo 'SL', @TblName, @CompanySeq, '', @Date, @MaxNo OUTPUT
    --    
    --    UPDATE  #BIZ_OUT_DataBlock2
    --       SET  BadNo  = @MaxNo
    --     WHERE  WorkingTag  = 'A'
    --       AND  Status      = 0
  --  END

RETURN