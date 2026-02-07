Splunk Query to Detect NTDS.dit Dumping

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