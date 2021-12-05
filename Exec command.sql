-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [GNR].[DeleteTable] null,null,null
Create PROCEDURE [GNR].[FillXmlDynamic] 
	-- Add the parameters for the stored procedure here
	 @UserId int=null
	,@SubSystemID int=null
	,@FormId int=null
	,@Schema nvarchar(50)='GNR'
	,@Table nvarchar(50)='Bank'
	,@Condition nvarchar(1000)  =N'Where kindid=2091'          
AS
BEGIN
	
	SET NOCOUNT ON;

	Declare @tempTable table(ID int,UserId int,SubSystemID int,FormID int,xmlData xml)
	Declare @DeleteCommand nvarchar(max)
	Declare @SelectIDCommand nvarchar(max)

	SET    @SelectIDCommand =N'SELECT ID FROM '+@Schema+'.'+@Table+' '+@Condition

	insert into @tempTable(ID)
	exec sp_executesql @selectidcommand

	update 
		@tempTable 
	set 
		UserId=@UserId,SubSystemID=@SubSystemID,FormID=@FormId

		--declare @result xml
		

		--exec sp_executesql N'select @result=(select *  from GNR.Bank Where KindID=2091 for xml path )',N'@result xml OUTPUT',@result out
		--select @result result
	


		declare @id int
		DECLARE db_cursor CURSOR FOR 
SELECT ID 
FROM @tempTable temptable

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @id  

WHILE @@FETCH_STATUS = 0  
     BEGIN  
           select @id
           declare @idCondition nvarchar(10)=N' ID='+Convert(nvarchar(10),@id)
           select @idCondition
           if @Condition Is Not Null
             Set @idCondition=N' AND '+@idCondition
		   declare @xmldata xml
		   declare @cmd nvarchar(2000)= N'select @result=(select *  from '+@Schema+N'.'+@Table+N' '+@condition+@idCondition+N' For XML PATH '+N')'
	  
		   exec sp_executesql @cmd,N'@result xml OUTPUT',@xmldata out
		   select @xmldata
		   update @tempTable  set xmlData=@xmldata where ID=@id
	  FETCH NEXT FROM db_cursor INTO @id
    END 

CLOSE db_cursor  
DEALLOCATE db_cursor 

		
	select * from @tempTable
	
END
GO
