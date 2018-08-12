#丢av号文件夹下面运行 
#需要安装ffmpeg 并添加环境变量
#分p整理,合并分段

$type = Read-Host "Choose 0 or 1 //Android[0] UWP[1]"
$currentPath=Split-Path -Parent $MyInvocation.MyCommand.Definition #当前文件夹
$foo =($currentPath).Split('\\') 
$av=$foo[$foo.Count-1] #av号

if($type -eq "0")
{
#视频
    Get-ChildItem -Filter *.blv -Recurse |
    ForEach-Object{       
        cd $_.DirectoryName
        Move-Item $_.Name -Destination ../    
        Out-File -FilePath ../filelist.txt -Append -Encoding ASCII -InputObject "file $_" 
    }
    cd $currentPath
#弹幕
    Get-ChildItem -Filter *.xml -Recurse |
    ForEach-Object{
        $bar=($_.DirectoryName).Split('\\')
        $partNumber=$bar[$bar.Count-1] #分p号
        cd $_.DirectoryName
        $newName = 'av{0}-p{1}.xml' -f $av,$partNumber
        Rename-Item -Path $_.FullName -NewName $newName    
    }
    cd $currentPath

    Get-ChildItem -Filter *.txt -Recurse |
    ForEach-Object{
        $bar=($_.DirectoryName).Split('\\')
        $partNumber=$bar[$bar.Count-2] #分p号
        $file='av{0}-p{1}.mkv' -f $av,$partNumber
        cd $_.DirectoryName
        ffmpeg -f concat -i filelist.txt -c copy "$file"
    }
    cd $currentPath
    Remove-Item ./* -Exclude *.mkv,*.xml,*ps1 -Recurse #删掉其他文件
}

else
{
    $foo =($currentPath).Split('\\') 
    Get-ChildItem -Filter *.flv -Recurse |
    ForEach-Object{
        cd $_.DirectoryName
        Out-File -FilePath filelist.txt -Append -Encoding ASCII -InputObject "file $_" 
    }

    cd $currentPath

    Get-ChildItem -Filter *.txt -Recurse |
    ForEach-Object{
        $bar=($_.DirectoryName).Split('\\')
        $partNumber=$bar[$bar.Count-1] #分p号
        $file='av{0}-p{1}.mkv' -f $av,$partNumber
        cd $_.DirectoryName
        ffmpeg -f concat -i filelist.txt -c copy "$file"
    }
    cd $currentPath
    Remove-Item ./* -Exclude *.xml,*.ps1,*.jpg,*.mkv -Recurse #删掉其他文件
}
