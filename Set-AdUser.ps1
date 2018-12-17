param ([string]$Username, [hashtable]$Attributes)

##Find the username 
    $UserAccount = Get-ADUser -Identity $Username
    if (!$UserAccount) {
        ##If the username isn't found throw an error and exit
        Write-Error "The username '$Username' does not exist" 
        return

}

##The attributes parameter will contain only the parameters for the Set-AdUser cmdlet except for 
##Password. If this is in $Attributes then it needs to be processed differently.
if ($Attributes.ContainsKey('Password')) {
    $UserAccount | Set-ADAccountPassword -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Attributes.Password -Force)
    ##Remove the password key because we'll be passing this hashtable directly to Set-AdUser later
    $Attributes.Remove('Password')
}

$UserAccount | Set-ADUser @Attributes      