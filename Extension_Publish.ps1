#+++++++++++++++++++++++++++++#
#  Used to publish a new App  #
#+++++++++++++++++++++++++++++#

#Run this script as administrator from the Developer- or Administration Shell
#Alternatively import the required tools from the Service- or Role Tailored Client folder before

#Step1
#Name of the server instance found in the NAV/BC Administration
$Instance = ""

#Following information is found in app.json in your extension workspace 
$ExtensionPublisher = ""
$ExtensionName = ""
$Version = ""

#Path to some base-folder containing the .app file
$ExtensionPath = ""

# AppFile Name by default is <Publisher including spaces>_<Name including spaces>_<Version>.app
$Extension = $ExtensionPath + $ExtensionPublisher + "_" + $ExtensionName + "_" + $Version + ".app"

#Set true if you want to write the last error message into the output
$ShowError = $false

$ErrorActionPreference = 'Stop'
try {
    Publish-NAVApp -ServerInstance $Instance -Path $Extension -SkipVerification
    Sync-NavApp -ServerInstance $Instance -Name $ExtensionName -Version $VersionNew
    Install-NAVApp -ServerInstance $Instance -Name $ExtensionName 
    Write-Output "The extension" + $ExtensionName + " has been installed."
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
