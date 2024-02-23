### Transcript Section ###
# used to setup automated transcript start when PowerShell starts
if ($IsWindows) {
  $TranscriptDir = "C:\transcripts\"
}
if ($IsLinux -Or $IsMac) {
  $TranscriptDir = "/home/philip/.transcripts/"
}
$TranscriptLog = (hostname)+"_"+$env:USERNAME+"_"+(Get-Date -UFormat "%Y-%m-%d")
$TrascriptPath = $TranscriptDir + $TranscriptLog
## end of transcript section variables ##


# Test to see if the transcript directory exists. If it doesn't create it.
if (!($TranscriptDir)) {
  New-Item $TranscriptDir -Type Directory -Force
}
Start-Transcript -LiteralPath $TrascriptPath -Append
### end of transcript section ###

