Function Tail-WinEventLog {
    Param(
        [hashtable]$FilterHashTable
    )

    $LatestEvent = Get-WinEvent -FilterHashtable $FilterHashTable -MaxEvents 1
    $LastTimeCreated = $LatestEvent.TimeCreated
    $LastRecordId = $LatestEvent.RecordId
    $FilterHashTable.Add("StartTime",$LastTimeCreated)

    while($True) {
        $Events = Get-WinEvent -FilterHashtable $FilterHashTable | ? RecordId -gt $LastRecordId | Sort TimeCreated -Descending

        if($Events) {
            $LastTimeCreated = $Events[0].TimeCreated
            $LastRecordId = $Events[0].RecordId

            $Events
        }

        Start-Sleep -Seconds 1
    }
}
