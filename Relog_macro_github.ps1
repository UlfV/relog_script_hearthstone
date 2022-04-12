
# Relog Macro for Hearthstone Battlegrounds - Firewall Rule was created prior to the script's execution
# $HS_firewall_rule need to be set - to get the name execute: get-netfirewallrule -displayname yourfirewallrule

$HS_firewall_rule = ''
$HS_firewall_rule_name = ((Get-NetFirewallRule $HS_firewall_rule | select-object -property DisplayName) -split '[={}]')[2]
write-host $HS_firewall_rule_name

# Self-elevate the script if required
# credits: https://blog.expta.com/2017/03/how-to-self-elevate-powershell-script.html

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
     $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
     Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
     Exit
    }
   }
   
enable-netfirewallrule $HS_firewall_rule
write-host "$HS_firewall_rule_name", "enabled" -ForegroundColor Green

write-host "Starting sleep timer for 2 seconds." -ForegroundColor Green
Start-sleep -s 2

Disable-NetFirewallRule $HS_firewall_rule
write-host "$HS_firewall_rule_name disabled" -ForegroundColor Red

Start-sleep -s 2

get-netfirewallrule -DisplayName