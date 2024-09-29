<#
.Synopsis
    Lists Folder ACLs for a targeted directory and subdirectories without inheritance
.DESCRIPTION
    Leverages the Get-ACL cmdlet's Access property to display the ACLs for a  directory and subdirectories in a list format.
.EXAMPLE
    Local Drive: Get-FoldersACL -Path C:\Scripts
.EXAMPLE
    Network Drive: Get-FoldersACL -Path \\Server01\Share
.EXAMPLE
    Local drive with subfolders: Get-FoldersACL -Path C:\Scripts -Recurse $true
.NOTES
    Created by Dimitri Redant - Novembre 1, 2017
    Version 1.0
#>

Function Get-FoldersACL{[cmdletbinding()]

    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)][ValidateNotNullorEmpty()][string[]]$Path,
        [Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)][ValidateNotNullorEmpty()][string[]]$Recurse
    )#EndParam
        BEGIN{Write-Verbose "Reading ACLs for $($MyInvocation.Mycommand)"
        }#BEGIN

        PROCESS{ 
                $Directory = Get-Acl -Path $Path
                    Try{
                        Write-Verbose "Reading Permissions for Folder $($Path)"
                        ForEach($Dir in $Directory.Access){
                            [PSCustomObject]@{
                                Path = $Path[0]
                                Group = $Dir.IdentityReference
                                AccessType = $Dir.AccessControlType
                                Rights = $Dir.FileSystemRights
                                }
                        }#EndForEach
                    }#EndTry
                    Catch{
                            Write-Error $PSItem
                    }#EndCatch
                If ($Recurse -eq $true) { 
                    $Directories = Get-ChildItem -Path $Path -Directory -Recurse -ErrorAction SilentlyContinue
                    Foreach ($dir in $Directories) {
                        $acls = Get-Acl -Path $dir.FullName | Where-Object { $_.Access.IsInherited -eq $false } -ErrorAction SilentlyContinue
                        Try{
                            Write-Verbose "Reading Permissions for Folder $($_.FullName)"
                            ForEach($acl in $acls.Access){
                                [PSCustomObject]@{
                                    Path = $dir.FullName
                                    Group = $acl.IdentityReference
                                    AccessType = $acl.AccessControlType
                                    Rights = $acl.FileSystemRights
                                    Inherited = $acl.Access.IsInherited                      
                                    }
                            }#EndForEach
                        }#EndTry
                        Catch{
                              Write-Error $PSItem
                        }#EndCatch
                    }#EndIF
                }
         }#PROCESS
         END{Write-Verbose "Ending $($MyInvocation.Mycommand)"
         }#END

}#EndFunction


<#
Remark:
When older Powershell version is used it could be necessary to convert filesystemrights to proper text.

Switch ($access.FileSystemRights) { 
    2032127 {$AccessMask = "FullControl"} 
    1179785 {$AccessMask = "Read"} 
    1180063 {$AccessMask = "Read, Write"} 
    1179817 {$AccessMask = "ReadAndExecute"} 
    -1610612736 {$AccessMask = "ReadAndExecuteExtended"} 
    1245631 {$AccessMask = "ReadAndExecute, Modify, Write"} 
    1180095 {$AccessMask = "ReadAndExecute, Write"} 
    268435456 {$AccessMask = "FullControl (Sub Only)"} 
    default {$AccessMask = "Unknown"
}
#>
