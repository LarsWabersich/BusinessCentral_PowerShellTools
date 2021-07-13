#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
#  Simple script to unpublish multiple uninstalled versions  #
#  Currently only used for revision versions                 #
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

#Run this script as administrator from the Developer- or Administration Shell
#Alternatively import the required tools from the Service- or Role Tailored Client folder before


#Service Tier Name 
$Instance = ""

#Extension Details
$ExtensionName = ""
$VersionCount = 0
$LastVersion = 0
$Version = "1.0.0.$VersionCount"

#Toggle to get a confirmation per uninstalled version
$WriteOutput = $true

do {
    if($WriteOutput) {
      Write-Output "Uninstalling Version $Version ..."
    }
    Get-NAVAppInfo -ServerInstance $Instance -Name $ExtensionName -Version $Version | Unpublish-NAVApp
    $VersionCount += 1
    $Version = "1.0.0.$VersionCount"
} until ($VersionCount -eq $LastVersion)

