param($Computername, $Location = 'OU=Corporate Computers')

if (Get-ADComputer $Computername) {
    Write-Error "The computer name '$Computername' already exists"
    return
}

$DomainDn = (Get-AdDomain).DistinguishedName
$DefaultOUPath = "$location,$DomainDn"

New-ADComputer -Name $Computername -Path $DefaultOUPath