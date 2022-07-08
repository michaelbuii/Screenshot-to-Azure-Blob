Param([Parameter(Mandatory=$true)][string[]] $imgName, $containerName, $storageName)
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$currentDir = Get-Location
Write-Host $currentDir
Start-Sleep -Milliseconds 1000
$clipboard = [System.Windows.Forms.Clipboard]::GetDataObject() 

$container = "https://${storageName}.blob.core.windows.net/${containerName}/"
$sb = [System.Text.StringBuilder]::new()


if ($clipboard.ContainsImage()) {
  $img = get-clipboard -format image 
  
  $img.Save("${currentDir}/${imgName}")
 
  azcopy copy $imgName $container
  #remove-item $imgName
  $sb.Append($container + $imgName)

  Set-Clipboard -Value  $sb
}
else {
    Write-Host "no image"
}