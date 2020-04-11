Use master
Go
--To delete the output.txt file from C:\
sp_configure 'xp_cmdshell',1
go
reconfigure with override
exec xp_cmdshell "Del C:output.txt"
--Drops the Temporary Table.
drop table ##backup_alert
go
--To generate output.txt
exec xp_cmdshell "C:\sqlcmd.bat"
go
--Creates Temporary Table to store output
create table ##backup_alert
(
idataagent nvarchar(1000),
Success varchar(1000),
Failed nvarchar(1000),
PartialSuccess varchar(1000),
SuccessRate varchar(1000),
)
--Inserts records to Temporary Table from C:\output.txt file.
BULK INSERT ##backup_alert
FROM 'c:\output.txt'
WITH 
 (
 FIELDTERMINATOR =',',
 ROWTERMINATOR ='\n'
 )
GO 
------HTML Report
DECLARE @xml NVARCHAR(MAX)
DECLARE @body NVARCHAR(MAX)
declare @count varchar(100)
select @count= COUNT(idataagent) from ##backup_alert 
SET @xml = CAST(( SELECT idataagent AS 'td','',Success AS 'td','',Failed AS 'td','',PartialSuccess AS 'td','',SuccessRate AS 'td',''
       FROM ##backup_alert
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))
SET @body ='<html><body><H3>Last 24 hour Backup Success Rate per Application</H3>
<table border = 1> 
<tr>
<th> Application Name </th> <th> Success </th> <th> Failed </th><th> Partial Success </th></th> <th> Success Rate </th> </tr>'    
SET @body = @body + @xml +'</table></body></html>'
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'Main DB Mail profile', -- replace with your SQL Database Mail Profile 
@body = @body,
@body_format ='HTML',
@recipients = 'satish.ankala@gmail.com;satish.ankala@gmail.com', -- replace with your email address
@subject = 'Last 24 hour Backup Success Rate per Application.Please take action'
go 
--Drops the Temporary Table.
drop table ##backup_alert
go
sp_configure 'xp_cmdshell',0
go
reconfigure with override