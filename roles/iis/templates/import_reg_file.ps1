# read in reg file with the settings we need
$regstuff = Get-Content "\\fakecomapnyname.com\files\public\IT\Protected\Projects\SOLIDWORKS-2019-deployment\fakesettings.reg"

# Fix it so it applies to the specific profile for this loop, profile
$regstuff = $regstuff.Replace("[HKEY_CURRENT_USER\","[HKEY_USERS\$($Item.SID)\")

# write it to our temporary location
$regstuff | Out-File "$env:TEMP\regstuff-fixed.reg"

write-output $($Item.Username)
# import it
reg.exe import "$env:TEMP\regstuff-fixed.reg"
