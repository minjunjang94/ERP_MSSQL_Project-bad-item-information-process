IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_FrmLGQCBadInfoQuery' AND xtype = 'P')    
    DROP PROC minjun_FrmLGQCBadInfoQuery
GO
    
/*************************************************************************************************    
 ��  �� - SP-�ҷ�������ȸ_minjun
 �ۼ��� - '2020-04-13
 �ۼ��� - �����
 ������ - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_FrmLGQCBadInfoQuery
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
         @BadSeq       INT



    -- ��ȸ���� �޾ƿ���
    SELECT   @BadSeq    = RTRIM(LTRIM(ISNULL(M.BadSeq        ,  0 )))

      FROM  #BIZ_IN_DataBlock1      AS M

    -- ��ȸ��� ����ֱ�
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