clear
# Use at your own risk!
# Try it in your active directory lab setup first!
# This script is inspired from https://github.com/JavelinNetworks/HoneypotBuster/blob/master/Invoke-HoneypotBuster.ps1

Import-Module ActiveDirectory
//Set-ADUser -Identity fatih -ServicePrincipalNames @{Add='HTTP/webserver','HTTP/SomeAlias'}

function Show-Menu
{
     param (
           [string]$Title = 'Active Directory Honeypot Accounts'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Press '1' for creating honeypot active directory user."
     Write-Host "2: Press '2' for creating honeypot active directory computer."
     Write-Host "3: Press '3' for creating honeypot inactive domain administrator."
     Write-Host "4: Press '4' for creating honeypot  DNS record."
     Write-Host "5: Press '5' for creating honeypot SPN record."
     Write-Host "Q: Press 'Q' to quit."
}

do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {

'1' {
cls
Write-Host "Create honeypot active directory user."
$username = Read-Host -Prompt 'Active Directory Username'
$desc = Read-Host -Prompt 'User Description'
if ($username) {

$aduser = New-ADUser -Name $username -AccountPassword(Read-Host  -AsSecureString "AccountPassword")  -Description $desc  -PassThru | Enable-ADAccount

if($?)
{
 write-host   "$username created successfuly with '$desc' description."
 
}
else
{
  write-host "Try creating user again!"
}


} else {
    Write-Warning -Message "No username input."
}

           } 
           

'2' {
                cls
Write-Host "Create honeypot active directory computer name."               
Import-Module ActiveDirectory
 $computername = Read-Host -Prompt 'Active Directory Computer Name'
 $computerdesc = Read-Host -Prompt 'Active Directory Computer Name Description'
New-ADComputer -Name $computername -SamAccountName $computername  -Description $computerdesc

if($?)
{
 write-host   "$computername created successfuly with '$computerdesc' description."
 
}
else
{
  write-host "Try creating computer name again!"
}


           }  
           

'3' {
cls    
Write-Host " honeypot inactive domain administrator."         
$username = Read-Host -Prompt 'Active Directory username to add domain administrator group. (inactive)'
$desc = Read-Host -Prompt 'Domain Admin Description'
if ($username) {

$aduser = New-ADUser -Name $username -AccountPassword(Read-Host  -AsSecureString "AccountPassword")  -Description $desc  -PassThru | Enable-ADAccount
net group "Domain Admins" $username /ADD /DOMAIN
Disable-ADAccount -Identity $username 


if($?)
{
 write-host   "$username created successfuly with '$desc' description."
 
}
else
{
  write-host "Try creating user again!"
}

 } }          
           
           
'4' {
cls
Write-Host "Create honeypot  DNS record"   
$dnsname = Read-Host -Prompt 'DNS Name'
$IPAdress = Read-Host -Prompt 'IP Adress'
$zonename = Read-Host -Prompt 'Zonename (for exp: test.local or test.com'

Add-DnsServerResourceRecordA -Name $dnsname -ZoneName $zonename -AllowUpdateAny -IPv4Address $IPAdress -TimeToLive 01:00:00

if($?)
{
 write-host   "$dnsname dns name created successfuly with '$IPAdress' IP adress and $zonename zonename."
 
}
else
{
  write-host "Try creating DNS record again!"
}

           }  

           
'5' {
cls
Write-Host "Create honeypot SPN record." 
$computername = Read-Host -Prompt 'Computer Name'
$username = Read-Host -Prompt 'Username'
$domainname = Read-Host -Prompt 'Domain name without suffix'
$domainsuffix = Read-Host -Prompt 'Domain name suffix'

Setspn -a $computername/$username.$domainname.$domainsuffix:60111 $domainname\$username


if($?)
{
 write-host   "SPN created successfully."
 
}
else
{
  write-host "Try creating SPN record again!"
}
     
           }    
           
           
                  
                      
           'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')


