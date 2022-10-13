## this script will read a 'todo.txt' file containing machine names or IP addresses, and for each
## machine it will try to schedule a reboot for 5:10 PM on the present day if it is not 5 PM yet, 
## or else try to schedule a reboot to 5:10 PM the day after.  


# removes file with all the machines that failed to have it's reboot scheduled , if it exists
if ($(Test-Path .\fail.txt)){
     Remove-Item .\fail.txt
}

# gets a list with the names (or IP addresses) of machines to be reeboted
$names=Get-Content .\todo.txt

# $count will count the number of successfull reboot requests made
$count = 0
$total=($names | Measure-Object -Line).Lines

# keeps track of the reboot requests being made
$i=1


# iterates over all machine names
foreach ($computer in $names) {    
    # calculates aproximately(1 minute error, enough for my use case) the number of seconds 
    # to pass as parameter to the reboot request
    $now=Get-Date
    if ($now.hour -lt 17){
        $fromNow = ((17*3600+10*60) - (($now.hour)*3600 + ($now.minute)*60))
    } else {
        $fromNow = ((24*3600) - (($now.hour)*3600 + ($now.minute)*60) + (17*3600 + 10*60)) 
    } 
    
    # requests the reboot of $computer with a message and redirects text output to a file so it can be analyzed
    $message = "Este computador esta programado para ser reiniciado as 17:10. Por favor, salve o que for necessario."
    shutdown /r /m \\$computer /t $fromNow /c  $message *> .\error_output.txt
    $error_output = Get-Content .\error_output.txt
    
    
    # reboot scheduled - saves machine name at scheduled.txt
    if ($error_output.Length -eq 0){                                                               
        Write-Output $computer >> .\scheduled.txt
        msg /server:$computer * "Este computador esta programado para ser reiniciado as 17:10. Por favor, salve o que for necessario." # message all users about reboot
        Write-Output $computer "($i of $total): ############ OKAY, restart in $fromNow"
        Write-Output ""
        $count++     # counting successfull reboot requests made
    } elseif($error_output -like "*Acesso negado*") {   # records computers that couldn't be accessed, possibly due to permission issues
        Write-Output $computer >> .\accessDenied.txt
        Write-Output $computer "($i of $total):  access denied"
        Write-Output ""
    } elseif ($error_output -like '*error_output*'){    # pings machine to see if it is reachable or if it's name can be solved
        ping -n 1 $computer *> .\tryToPing.txt
        $tryToPing = Get-Content .\tryToPing.txt
        if ($tryToPing -like "*Verifique o nome*"){     # records machines which names couldn't be solved
            Write-Output $computer >> .\notSolved.txt
            Write-Output $computer "($i of $total):  FAILED to ping"
            Write-Output ""
        } else{
            Write-Output $computer >> .\fail.txt        # records names of machines that failed for other reasons
            Write-Output $computer "($i of $total):  FAILED to restart in $fromNow"
            Write-Output ""
        }
    } 
    $i++
}




# updates the list of machines that need to be rebooted
Remove-Item .\todo.txt
Rename-Item .\fail.txt .\todo.txt

Write-Output "Number of successfull request made this time: $count"
Write-Output ""
Write-Output "Total of successfull requests: $((Get-Content .\accessDenied.txt | Measure-Object -Line).Lines)"
Write-Output "Access Denied: $((Get-Content .\accessDenied.txt | Measure-Object -Line).Lines)"
Write-Output "To Do:  $((Get-Content .\todo.txt | Measure-Object -Line).Lines)" 
Write-Output "Name not solved: $((Get-Content .\notSolved.txt | Measure-Object -Line).Lines)"