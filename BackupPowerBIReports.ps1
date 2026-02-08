#===========================================================================================================================================================
# SCRIPT..............................: BackupPowerBIReports.ps1
# Author..............................: Asgdom Tesfaye 
# Date................................: 7/05/2023
#===========================================================================================================================================================

#Set-ExecutionPolicy RemoteSigned
#using silent connection to PBI service account
$username = "PBI_USER"
$encryptedPassword = Get-Content "S:\DBAOps\PS_Scripts\KeyPass\encryptedPBIsvc.txt"
$password = $encryptedPassword | ConvertTo-SecureString
$credential = New-Object System.Management.Automation.PSCredential($username, $password)
# Connect to Power BI Service Account
Connect-PowerBIServiceAccount -Credential $credential

#First, Collect all (or one) of the workspaces in a parameter called PBIWorkspace
$PBIWorkspace = Get-PowerBIWorkspace 							# Collect all workspaces you have access to
#$PBIWorkspace = Get-PowerBIWorkspace -Name 'My Workspace Name' 	# Use the -Name parameter to limit to one workspace
$PBIWorkspace.name
#Now collect todays date
$TodaysDate = Get-Date –Format "yyyyMMdd" 

#Almost finished: Build the outputpath. This Outputpath creates a news map, based on todays date
$OutPutPath = "S:\PowerBIReportBackup"  

#Now loop through the workspaces, hence the ForEach
ForEach($Workspace in $PBIWorkspace)
{
	#For all workspaces there is a new Folder destination: Outputpath + Workspacename
	$Folder = $OutPutPath + "\" + $Workspace.name 
	#If the folder doens't exists, it will be created.
	If(!(Test-Path $Folder))
	{
		New-Item –ItemType Directory –Force –Path $Folder
	}
	#At this point, there is a folder structure with a folder for all your workspaces 
	
	
	#Collect all (or one) of the reports from one or all workspaces 
	$PBIReports = Get-PowerBIReport –WorkspaceId $Workspace.Id 						 # Collect all reports from the workspace we selected.
	#$PBIReports = Get-PowerBIReport -WorkspaceId $Workspace.Id -Name "My Report Name" # Use the -Name parameter to limit to one report
		
		#Now loop through these reports: 
		ForEach($Report in $PBIReports)
		{
			#Your PowerShell comandline will say Downloading Workspacename Reportname
			Write-Host "Downloading "$Workspace.name":" $Report.name 
			
			#The final collection including folder structure + file name is created.
			$OutputFile = $OutPutPath + "\" + $Workspace.name + "\" + $Report.name + "_" + $TodaysDate + ".pbix" 
			
			# If the file exists, delete it first; otherwise, the Export-PowerBIReport will fail.
			 if (Test-Path $OutputFile)
				{
					Remove-Item $OutputFile
				}
			
             
			#The pbix is now really getting downloaded
			Export-PowerBIReport –WorkspaceId $Workspace.ID –Id $Report.ID –OutFile $OutputFile -ErrorAction SilentlyContinue
		}
}
