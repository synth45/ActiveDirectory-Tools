#The Enterprise Standard for New Users

#Must contain employee's first and last name, middle initial and title
#username must be first initial and last name of the employee. If that is taken then it must be the first 
#initial, middle initial and last name. 
#If that's taken, it will have to be looked at manually.

#Must be created in a specified OU

#Must have a default password that's set to be changed on first login

#Must be member of a corporate group

param($Firstname,$MiddleInitial,$LastName,$Location = 'OU=Corporate Users',$Title)

$DefaultPassword = 'Welcome1'
$DomainDn = (Get-ADDomain).DistinguishedName
$DefaultGroup = 'Sales'

##Figure out what the user name should be
$Username = "$($Firstname.Substring(0,1))$Lastname"
$EaPrefBefore = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'

##This if construct runs if username is already in AD
if (Get-ADUser $Username) {
    $Username = "$($FirstName.Substring(0,1))$MiddleInitial$LastName"
    if (Get-ADUser $Username) {
        Write-Warning "No Acceptable username schema could be created"
        return
    }
}

##Create the user account

###Setting $ErrorActionPreference to what it was before
$ErrorActionPreference = $EaPrefBefore

###Creating a parameter hash table to feed into New-ADuser on line 54
$NewUserParams = @{
    'UserPrincipalName' = $Username
    'Name' = $Username
    'Givenname' = $Firstname
    'Surname' = $Lastname
    'Title' = $Title
    'SamAccountName' = $Username
    'AccountPassword' = (ConvertTo-SecureString $DefaultPassword -AsPlainText -Force)
    'Enabled' = $true
    'Initials' = $MiddleInitial
    'Path' = "$Location,$DomainDn"
    'ChangePasswordAtLogon' = $true
}

New-ADUser @NewUserParams

##Add the user account to the company standard group
Add-ADGroupMember -Identity $DefaultGroup -Members $Username