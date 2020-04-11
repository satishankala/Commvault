set nocount on

select idataagent, [Success], [Failed],  [PartialSuccess], 
				cast(sum((((cast([Success] as float) + cast([Failed] as float) + cast([PartialSuccess] as float)) 
								- (cast([Failed] as float)))/(cast([Success] as float) + cast([Failed] as float) + cast([PartialSuccess] as float))) * 100) as decimal (6,2)) as SuccessRate
from (
select *
from 
(
  select idataagent, [jobstatus]
  from [CommServ].[dbo].[CommCellBackupInfo] WHERE startdate > DATEADD(day, -1, GETDATE()) and subclient NOT LIKE '%ECS_TEMP%'
) src
pivot
(
  count([jobstatus])
  for [jobstatus] in ([Success], [Failed],[PartialSuccess])
) piv) a
group by idataagent, [Success], [Failed], [PartialSuccess]

union all

select Total, totsuc, totfail, totps, cast(srate as decimal(6,2)) as SuccessRate
from (
select  'Total' as Total, sum([Success]) as totsuc, sum([Failed]) as totfail, sum([PartialSuccess]) totps, 
					(((cast(sum([Success]) as float) + cast(sum([Failed]) as float) +  cast(sum([PartialSuccess]) as float)) - (cast(sum([Failed]) as float) )) 
						/ (cast(sum([Success]) as float) + cast(sum([Failed]) as float)  + cast(sum([PartialSuccess]) as float))) * 100 as srate
from
(select idataagent, [Success], [Failed], [PartialSuccess], 
				cast(sum((((cast([Success] as float) + cast([Failed] as float) + cast([PartialSuccess] as float)) 
								- (cast([Failed] as float)))/(cast([Success] as float) + cast([Failed] as float) + cast([PartialSuccess] as float))) * 100) as decimal (6,2)) as successrate
from (
select *
from 
(
  select idataagent, [jobstatus]
  from [CommServ].[dbo].[CommCellBackupInfo] WHERE startdate > DATEADD(day, -1, GETDATE())
) src
pivot
(
  count([jobstatus])
  for [jobstatus] in ([Success], [Failed], [PartialSuccess])
) piv) a
group by idataagent, [Success], [Failed],  [PartialSuccess]
) b
) c




Set nocount off 