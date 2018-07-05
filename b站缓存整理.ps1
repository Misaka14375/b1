#丢av号文件夹下面运行 
#by Misaka14375
$type = Read-Host "Choose 0 or 1 //Android[0] UWP[1]"
$currentPath=Split-Path -Parent $MyInvocation.MyCommand.Definition #当前文件夹
if($type -eq "0")
{
    $foo =($currentPath).Split('\\') 
    $av=$foo[$foo.Count-1] #av号
    Get-ChildItem -Filter *.blv -Recurse |
    ForEach-Object{
        $bar=($_.DirectoryName).Split('\\')
        $partNumber=$bar[$bar.Count-2] #分p号
        cd $_.DirectoryName
        $newName = 'av{0}-p{1}-{2}' -f $av,$partNumber,$_.Name.Replace(".blv",".flv")
        Rename-Item -Path $_.FullName -NewName $newName
        Move-Item $newName -Destination ../
    }
    cd $currentPath
    Get-ChildItem -Filter *.xml -Recurse |
    ForEach-Object{
        $bar=($_.DirectoryName).Split('\\')
        $partNumber=$bar[$bar.Count-1] #分p号
        cd $_.DirectoryName
        $newName = 'av{0}-p{1}.xml' -f $av,$partNumber
        Rename-Item -Path $_.FullName -NewName $newName
        Move-Item $newName -Destination ../
    }
    cd $currentPath
    Remove-Item ./* -Exclude *.flv,*.xml,*.ps1 -Recurse #删掉其他文件
}
else
{
    $foo =($currentPath).Split('\\') 
    Get-ChildItem -Filter *.flv -Recurse |
    ForEach-Object{
        cd $_.DirectoryName
        $newName = 'av{0}' -f $_.Name
        Rename-Item -Path $_.FullName -NewName $newName
        Move-Item $newName -Destination ../
    }
    cd $currentPath
    Get-ChildItem -Filter *.xml -Recurse |
    ForEach-Object{
       $newName = 'av{0}' -f $_.Name
       cd $_.DirectoryName
       Rename-Item -Path $_.FullName -NewName $newName
       Move-Item $newName -Destination ../
    }
    cd $currentPath
    Remove-Item ./* -Exclude *.flv,*.xml,*.ps1 -Recurse #删掉其他文件
}
