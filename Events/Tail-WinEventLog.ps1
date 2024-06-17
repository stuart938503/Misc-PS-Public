Function Tail-WinEventLog {
    Param(
        [hashtable]$FilterHashTable,
        [string[]]$Properties,
        [switch]$FormatAsList
    )

    #Add a StartTime if not passed in
    if (-not $FilterHashTable.ContainsKey("StartTime")) {
        $LatestEvent = Get-WinEvent -FilterHashtable $FilterHashTable -MaxEvents 1
        $LastTimeCreated = $LatestEvent.TimeCreated
        $LastRecordId = $LatestEvent.RecordId
        $FilterHashTable.Add("StartTime",$LastTimeCreated)
    }

    if (-not $PSBoundParameters.ContainsKey("Properties")) {
        $Properties = "TimeCreated","Id","LevelDisplayName","Message"
    }

    while($True) {
        $Events = Get-WinEvent -FilterHashtable $FilterHashTable | ? RecordId -gt $LastRecordId | Sort TimeCreated -Descending

        if($Events) {
            $LastTimeCreated = $Events[0].TimeCreated
            $LastRecordId = $Events[0].RecordId

            if($FormatAsList) {
                $Events | Select-Object -Property $Properties | Format-List
            } else {
                $Events | Select-Object -Property $Properties | Format-Table -AutoSize
            }
        }

        Start-Sleep -Seconds 1
    }
}
