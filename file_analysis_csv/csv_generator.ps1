# this script receives a directory as an argument and generates a .csv file with all of the files inside of it

$directory = $args[0]

# this function will format file size to a human-readable format
function Format-FileSize {
    Param ([int64]$size)
    
    If     ($size -gt 1TB) {$new_string = [string]::Format("{0:0.00} TB", $size / 1TB)}
    ElseIf ($size -gt 1GB) {$new_string = [string]::Format("{0:0.00} GB", $size / 1GB)}
    ElseIf ($size -gt 1MB) {$new_string = [string]::Format("{0:0.00} MB", $size / 1MB)}
    ElseIf ($size -gt 1KB) {$new_string = [string]::Format("{0:0.00} kB", $size / 1KB)}
    ElseIf ($size -gt 0)   {$new_string = [string]::Format("{0:0.00} B", $size)}
    Else                   {$new_string = [string]::Format("{0:0.00}", $size)}


    Return $new_string.Replace(",", ".")
}

#creates the .csv file
$csv_file = ".\files_found.csv"
New-Item -Name $csv_file -ItemType File -Force

# creates the .csv column header, encoding the file as utf8 so it can be easily read by python's Pandas library
Write-Output "full_path,owner,size,bytes,extension" | Out-File $csv_file -Encoding utf8 -Append




# $i will keep track of files found
$i=0

Write-Output "looking into directories... "
# iterates over all files found within the given directory
foreach ($file in $(Get-ChildItem $directory -Recurse -File )){
    $size = $file.Length # gets the file size in bytes
    $full_path = $file.FullName # get the file full path 
    $owner = (Get-Acl $full_path).owner # gets the file owner
    $formated_size = Format-FileSize($size) # gets the file in human readable format 
    $extension = $file.Extension # gets the file extension
    $full_path = """$full_path""" # file full path might have comma in it's name, so we put it into double quotes so it won't affect our .csv structure. 

    # writes the $file to a .csv line 
    Write-Output "$full_path,$owner,$formated_size,$size,$extension" | Out-File $csv_file -Encoding utf8 -Append

    $i++
}


Write-Output "$i files found."