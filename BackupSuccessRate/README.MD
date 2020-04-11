# Automated Backup Job Success Rate report/email

## Steps: - 
```
a)	Copy all the files (sqlcmd.bat, sqlquery.sql, MainQuery.sql) to C:\ drive in the Commvault Master Server.
b)	Update the Commvault MasterServer Name & SQL DB password in sqlcmd.bat file
c)	Login to Commserve and connect to SQL management studio (as administrator) using sa and default password (1StrongPassword!)
d)	open the MainQuery.sql and update the email address and test it.
```
Alternatively work with your DB admin and create a new job in ‘SQL Server Agent’ and add this script as a step and schedule to run every 24 hours.

Email Report looks like below :)

![Image of Backup Report](https://raw.githubusercontent.com/satishankala/Commvault/master/BackupSuccessRate/example.PNG)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
