## Splunk Query to Detect NTDS.dit Dumping


To detect NTDS.dit dumping in Splunk, you should focus on monitoring activities like shadow copy creation, access to the NTDS.dit file, and usage of tools like vssadmin, diskshadow, or ntdsutil. Below is a Splunk query to detect suspicious activities associated with dumping NTDS.dit.


### Query 1
```s
index=windows (EventCode=4688 OR EventCode=4663 OR EventCode=5145)
| eval EventDescription = case(
    EventCode == 4688, "Process Creation",
    EventCode == 4663, "Object Access",
    EventCode == 5145, "File Share Access",
    true(), "Unknown"
)
| eval CommandLine = coalesce(Process_Command_Line, ""),
        AccessedObject = coalesce(Object_Name, ""),
        FileSharePath = coalesce(Share_Name, "")
| where (EventCode == 4688 AND (CommandLine like "%vssadmin%" OR CommandLine like "%diskshadow%" OR CommandLine like "%ntdsutil%"))
    OR (EventCode == 4663 AND AccessedObject like "%NTDS.dit%")
    OR (EventCode == 5145 AND FileSharePath like "%\\NTDS\\%")
| stats count AS EventCount, 
        values(CommandLine) AS SuspiciousCommands, 
        values(AccessedObject) AS AccessedObjects, 
        values(Account_Name) AS Accounts, 
        values(Source_Network_Address) AS SourceIPs, 
        min(_time) AS FirstSeen, 
        max(_time) AS LastSeen 
    BY ComputerName, EventCode, EventDescription
| eval SuspiciousScore = case(
    EventCode == 4688 AND SuspiciousCommands LIKE "%vssadmin%", "High",
    EventCode == 4663 AND AccessedObjects LIKE "%NTDS.dit%", "High",
    EventCode == 5145 AND FileSharePath LIKE "%\\NTDS\\%", "Medium",
    true(), "Low"
)
| where SuspiciousScore IN ("High", "Medium")
| table ComputerName, EventDescription, SuspiciousCommands, AccessedObjects, Accounts, SourceIPs, EventCount, FirstSeen, LastSeen, SuspiciousScore
| sort - SuspiciousScore, -EventCount
```

### Query 2 To focus on shadow copy creation, use the following query
```s
index=windows EventCode=4688
| eval CommandLine = coalesce(Process_Command_Line, "")
| where CommandLine like "%vssadmin create shadow%" OR CommandLine like "%diskshadow%"
| stats count AS ShadowCopyCount, 
        values(CommandLine) AS Commands, 
        values(Account_Name) AS Accounts, 
        min(_time) AS FirstSeen, 
        max(_time) AS LastSeen 
    BY ComputerName
| where ShadowCopyCount > 0
| table ComputerName, Commands, Accounts, ShadowCopyCount, FirstSeen, LastSeen
| sort - ShadowCopyCount
```

### Query 3 to detect potential dumping of the ntds.dit file:
```s
index=your_index sourcetype=your_sourcetype
| eval ObjectName = mvindex(TargetObject, 1)
| where EventCode=4662 // An operation was performed on an object
| search ObjectName="*ntds.dit*" AND AccessMask="0x100" // Access to NTDS.dit
| stats count AS AccessCount, values(IpAddress) AS ClientIPs, dc(IpAddress) AS UniqueIPs BY AccountName
| where AccessCount > 5 // Adjust threshold based on your environment
| table _time, AccountName, AccessCount, UniqueIPs, ClientIPs
| sort - AccessCount
```