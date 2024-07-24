##################################################
# Created by: Drewskinator99
#
# The purpose of this script is to setup an 
# automated tasks the runs an application 
# once and then indefinetely every 15 minutes.
# The task is run under a group managed service
# account.
##################################################

# set time variables
$interval = New-TimeSpan -Minutes 15 
$startTime = (Get-Date "10:00 AM").AddDays(1)
# create action to call program
$action = New-ScheduledTaskAction -Execute "C:\path\Application.exe"
# create trigger for action
$trigger = New-ScheduledTaskTrigger -once -At $startTime  -RepetitionInterval $interval
# set settings based on the stakeholder's requirements. If program doesnt finish executing in 15 minutes, the next 
# instance will be queued.
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Hours 4) -MultipleInstances Queue -Disable 
# principal to assign to run the task...use a GMSA
$pri = New-ScheduledTaskPrincipal -UserId "RSIH\gmsa_test_redac$" -LogonType Password -RunLevel Highest
# setup registered task with task objects created above
$registeredTask = Register-ScheduledTask -TaskName "TEST RS.Task.Redaction Service" -Action $action -Trigger $trigger -Principal $pri -Settings $settings
# output new task to verify and troubleshoot
$registeredTask
