
if ($IsWindows) {
  $TranscriptDir = "C:\transcripts\"
}
# transcript log sets up the file's name. It will tell you:
# - the computer the transcript came from
# - the user's PowerShell session that is recordedf
# - the day the transcript was made
$TranscriptLog = (hostname)+"_"+$env:USERNAME+"_"+(Get-Date -UFormat "%Y-%m-%d")

# Transcript Path is the full path and file name of the transcript log.
# (putting it into a single variable increases readability below)
$TrascriptPath = $TranscriptDir + $TranscriptLog
## end of transcript section variables ##


# Test to see if the transcript directory exists. If it doesn't create it.
if (!($TranscriptDir)) {
  New-Item $TranscriptDir -Type Directory -Force
}

# start the transcription based on the path we've created above
Start-Transcript -LiteralPath $TrascriptPath -Append
### end of transcript section ###