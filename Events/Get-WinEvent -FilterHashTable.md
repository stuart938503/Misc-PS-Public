https://devblogs.microsoft.com/scripting/use-filterhashtable-to-filter-event-log-with-powershell/

Get-WinEvent -FilterHashTable [hashtable]

**Hash Table**
|Key Name|Value Data Type|Accepts Wildcards|
|---|---|---|
|LogName|String[]|Yes|
|ProviderName|String[]|Yes|
|Path|String[]|No|
|Keywords|Long[]|No|
|ID|Int32[]|No|
|Level|Int32[]|No|
|StartTime|DateTime|No|
|EndTime|DateTime|No|
|UserID|SID|No|
|Data|String[]|No|
|\*|String[]|No|

**Keyword Values**
https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.eventing.reader.standardeventkeywords?redirectedfrom=MSDN&view=net-5.0
|Name|Value|
|---|---|
|AuditFailure|4503599627370496|
|AuditSuccess|9007199254740992|
|CorrelationHint2|18014398509481984|
|EventLogClassic|36028797018963968|
|Sqn|2251799813685248|
|WdiDiagnostic|1125899906842624|
|WdiContext|562949953421312|
|ResponseTime|281474976710656|
|None|0|

**Level Values**
https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.eventing.reader.standardeventlevel?redirectedfrom=MSDN&view=net-5.0
|Name|Value|
|---|---|
|Verbose|5|
|Informational|4|
|Warning|3|
|Error|2|
|Critical|1|
|LogAlways|0|

**Other Event Log Enums**

https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.eventing.reader?view=net-5.0#enums
