# this script will receive a directory as an argument,
# look at it's subdirectories and, for each one of them, 
# it will delete every file but the newest 7.  

# where to to do the cleaning 
$father_directory=$args[0]

#number of files to keep in each directory
$keep = 7

# the task we want to do:

# list all directories inside $father_directory and iterates over them
Get-ChildItem $father_directory -Directory | ForEach-Object {
    # get the name of the directory
    $folder=$_.FullName 
    # lists all files inside it
    $files = Get-ChildItem -Path $folder -File
    # delete every file but the newest 7
    if ($files.Count -gt $keep) {
        $files | Sort-Object LastWriteTime | Select-Object -First ($files.Count - $keep) | Remove-Item -Force
    }
}


