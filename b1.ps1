#丢av号文件夹下面运行 
#需要安装ffmpeg 并添加环境变量
#分p整理,合并分段

$type = Read-Host "Choose 0 or 1 //Android[0] UWP[1]"
$currentPath=Split-Path -Parent $MyInvocation.MyCommand.Definition #当前文件夹
$foo =($currentPath).Split('\\') 
$av=$foo[$foo.Count-1] #av号

if($type -eq "1")
{
    Get-ChildItem |?{$_.PsIsContainer -eq $true}| 
    ForEach-Object{       
       $list=$_.GetFiles()
       $file='av{0}-p{1}' -f $av,$_.Name
       $count=0     
       foreach($item in $list)
       {
            if($item.Extension -eq ".flv")
            {               
                $name =$item.Name.Split('_')[2]
                Rename-Item -Path $item.FullName -NewName $name  
                $count++
            }
            if($item.Extension -eq ".xml")
            {
                Rename-Item -Path $item.FullName -NewName "$file.xml"
            }
       }    
       cd $_.FullName 
       for($i=0 ; $i -lt $count;$i++)
       {
            Out-File -FilePath filelist.txt -Append -Encoding ASCII -InputObject "file $i.flv"            
       }           
       ffmpeg -f concat -i filelist.txt -c copy "$file.mkv"   
       cd $currentPath
    }
    Remove-Item ./* -Exclude *.mkv,*.xml,*ps1,*.jpg -Recurse #删掉其他文件
}
else
{
    Get-ChildItem -Filter *.blv -Recurse |
    ForEach-Object{       
        cd $_.DirectoryName
        Move-Item $_.Name -Destination ../           
    }
    cd $currentPath

    Get-ChildItem |?{$_.PsIsContainer -eq $true}| 
    ForEach-Object{       
       $list=$_.GetFiles()
       $file='av{0}-p{1}' -f $av,$_.Name
       $count=0     
       foreach($item in $list)
       {
            if($item.Extension -eq ".blv")
            {                 
                $count++
            }
            if($item.Extension -eq ".xml")
            {
                Rename-Item -Path $item.FullName -NewName "$file.xml"
            }
       }    
       cd $_.FullName 
       for($i=0 ; $i -lt $count;$i++)
       {
            Out-File -FilePath filelist.txt -Append -Encoding ASCII -InputObject "file $i.flv"            
       }           
       ffmpeg -f concat -i filelist.txt -c copy "$file.mkv"   
       cd $currentPath
    }
    Remove-Item ./* -Exclude *.mkv,*.xml,*ps1,*.jpg -Recurse #删掉其他文件
}
