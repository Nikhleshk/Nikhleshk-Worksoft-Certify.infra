$version = "0.1"

$ApplicationName = "Outokumpu Business Object Library"

###
# Checks before starting
#
# If no application name, script can't continue
if ($ApplicationName -eq "" -Or !$ApplicationName) {write-output "No Application Name specified. Exiting.";break}

# If with application name CN is too long, script can't continue
$l = -join("GG "+$ApplicationName+" DevOps Quality Assurance")
if ($l.Length -gt 64) {write-output "CN longer than 64 char not allowed in AD. Application Name too long. Exiting.";break}


###
# Starting.
#
# Base parameters for execution
$AzDevOpsOrg = "Outokumpu"
$ApplicationBaseOU = "OU=Cloud,OU=GRP Services,DC=od,DC=cssdom,DC=com"
$ServerBaseOU = "OU=Cloud,OU=Servers,DC=od,DC=cssdom,DC=com"
$adServer = "AV0DCOD12.od.cssdom.com"
$Domain = "od.cssdom.com"



# Generate DN
$ApplicationFullPath = -join("OU="+$ApplicationName+","+$ApplicationBaseOU)

# Check for existence of Application OU in OU=Cloud
$NewApplicationOU = Get-ADObject -SearchBase $ApplicationBaseOU -filter {(ObjectClass -eq "organizationalUnit" -and Name -eq $ApplicationName)} -server $adServer -verbose

# Exit if No Application OU
if (!$NewApplicationOU)
    {
    Write-Host "Application OU $($ApplicationFullPath) does not exist"
    exit;
    }

###
# Script to create AD Security Groups

# Fixed parameters for AD information
$adGroupScope = "Global"
$adGroupType = "Security"
    
Write-Output ""
Write-Output "Creating new authorization groups for Application: $ApplicationName"
Write-Output ""

# Set OU Path for authorization groups
$OUpath = -join("OU=Groups,"+$NewApplicationOU)

# Get Azure DevOps Project Admin group
# all the other groups will be Managed by this Admin group.
$newADGroupName = -join("GG "+$ApplicationName+" DevOps Admin")
$managedbygroup = Get-ADGroup -Filter "name -eq '$newADGroupName'" -Server $adServer

$NewGroupList = ("GG OBOL DDMRP Developer","GG OBOL DDMRP User","GG OBOL KPI Developer","GG OBOL KPI User","GG OBOL WIMM Developer","GG OBOL WIMM User","GG OBOL ONP Developer","GG OBOL ONP User")

# Create Azure DevOps Authorization Groups
foreach ($newADGroupName in $NewGroupList) {
	$description = "Job role authorization group"
	# 	
    New-ADGroup -Name $newADGroupName -SamAccountName $newADgroupname -GroupCategory $ADGroupType -GroupScope $ADGroupScope -Path $OUpath -ManagedBy $managedbygroup -Description $description -Server $adServer

    # Protect from deletion    
    Get-ADObject -SearchBase $OUpath -filter {(ObjectClass -eq "group" -and Name -eq $newADGroupName)} -server $adServer | Set-ADObject -ProtectedFromAccidentalDeletion:$true
	Write-Output "AD Security Group: $newADGroupName has been created to AD OU: $OUpath"
	Write-Output ""    
}

# Sets ACLs for the Managed By
# There seems to be delay between  group creation and availability of ACLs to be updateable.
#
sleep -seconds 900 

# Set permissions on groups
foreach ($newADGroupName in $NewGroupList) {
    Write-Host "Updating ACL on: $($newADGroupName)"
    # Set ACL to allow Management of Members by "ManagedBy"
    $group = Get-ADGroup -Identity $newADGroupName -server $adServer

    $NTPrincipal = New-Object System.Security.Principal.NTAccount $managedbygroup.samAccountName
    # GUID for Members
    $objectGUID = New-Object GUID 'bf9679c0-0de6-11d0-a285-00aa003049e2'
    # Get current ACL
    $acl = Get-ACL "AD:$($group.distinguishedName)"
    $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $NTPrincipal,'WriteProperty','Allow',$objectGUID
    # Add ACL for ManagedBy identity
    $acl.AddAccessRule($ace)
    Set-ACL -AclObject $acl -Path "AD:$($group.distinguishedName)"
}