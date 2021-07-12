#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
#  Used to install a new version of the extension                    #  
#  This script will run code defined in the upgrade codeunit         #
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

#Run this script as administrator from the Developer- or Administration Shell
#Alternatively import the required tools from the Service- or Role Tailored Client folder before

#Step1
#Name of the server instance found in the NAV/BC Administration
$Instance = ""

#Check which version has been last published in your target database!
$VersionOld = "" 

#Following information is found in app.json in your extension workspace 
$VersionNew = ""
$ExtensionPublisher = ""
$ExtensionName = ""

#Path to some base-folder containing the .app file
$ExtensionPath = ""


# AppFile Name by default is <Publisher including spaces>_<Name including spaces>_<Version>.app
$Extension = $ExtensionPath + $ExtensionPublisher + "_" + $ExtensionName + "_" + $VersionNew + ".app"

#Set to true if the old version should automatically be removed from the system
$DeleteOldVersion = $true
#Set true if you want to write the last error message into the output
$ShowError = $false

$ErrorActionPreference = 'Stop'
try {
    $UpgradeSuccesfull = $false;
    Uninstall-NAVApp -ServerInstance $Instance -Name $ExtensionName -Version $VersionOld
    Publish-NAVApp -ServerInstance $Instance -Path $Extension -SkipVerification
    Sync-NavApp -ServerInstance $Instance -Name $ExtensionName -Version $VersionNew
    Start-NAVAppDataUpgrade -ServerInstance $Instance -Name $ExtensionName -Version $VersionNew
    $UpgradeSuccesfull = $true
}
catch {
    Write-Output "An Error occured while upgrading the extension."
    if ($ShowError) {
        Write-Output $Error[0]
    } else {
        Write-Output "Please check the event viewer for more information."
    }
    $Error.Clear()
}
finally {
    if($UpgradeSuccesfull -and $DeleteOldVersion) {
        Unpublish-NAVApp -ServerInstance $Instance -Name $ExtensionName -Version $VersionOld
        Write-Output "Upgrade successful, the previous version was unpublished."
    }
    if ($UpgradeSuccesfull -and (-not $DeleteOldVersion)) {
        Write-Output "Upgrade successful, the previous Version was NOT unpublished."
    }
}
