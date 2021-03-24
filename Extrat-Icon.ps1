Function Extract-Icon {
  Param(
    [string]$FilePath,
    [string]$SavePath
  )
  
  [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') 
  [System.Drawing.Icon]::ExtractAssociatedIcon($FilePath).ToBitmap().Save($SavePath) 
}
