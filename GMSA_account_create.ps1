# Create GSG
New-ADGroup -Name gsg_name -Description "Security group for purpose" -GroupCategory Security -GroupScope Global
Add-ADGroupMember -Identity gsg_name -Members SERVER01$

# Create GMSA
New-ADServiceAccount -Name gmsa_name -PrincipalsAllowedToRetrieveManagedPassword gsg_name -Enabled:$true -DNSHostName gmsa_name.domain.local -SamAccountName gmsa_name -ManagedPasswordIntervalInDays 30
Set-ADServiceAccount -Identity gmsa_name -KerberosEncryptionType AES128,AES256

# from command prompt on SERVER01:
klist.exe -li 0x3e7 purge
gpupdate /force

# Other options
Get-ADServiceAccount -Identity gmsa_name$  -Properties PrincipalsAllowedToDelegateToAccount 
Set-ADServiceAccount -Identity gmsa_name$ -PrincipalsAllowedToDelegateToAccount "gsg_name"
Get-ADGroupMember -Identity gmsg_name$ | select *

