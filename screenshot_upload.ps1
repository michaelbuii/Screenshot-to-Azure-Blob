[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

Param([Parameter(Mandatory=$true)][string[]]$imgName, $container)
Start-Sleep -Milliseconds 1000
Write-Host "container name: ${container}"
$clipboard = [System.Windows.Forms.Clipboard]::GetDataObject()
$containerEndpoint = "https://bui.blob.core.windows.net/${container}"

azcopy make $containerEndpoint

$url = [System.Text.StringBuilder]::new()
$url.Append("![](")

if ($clipboard.ContainsImage()) {
  $img = get-clipboard -format image 
  #Saves to temp folder
  $img.Save($imgName)
  
  #Convert image to webp
  $NewImgName = $imgName -replace ".png"
  $NewImgName = "${NewImgName}.webp"
  cwebp.exe -q 85 $imgName -o $NewImgName

  #copy to blob
  azcopy copy $NewImgName $containerEndpoint
  #clean up from temp folder (not necessary Windows will clean it automatically)
  remove-item $imgName

  $fileName = [System.IO.Path]::GetFileName($NewImgName)
  $url.Append($containerEndpoint + "/" + $fileName + ")")
  Set-Clipboard -Value  $url
}
else {
    Write-Host "no image"
}