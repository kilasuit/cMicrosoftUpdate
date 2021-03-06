function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("True","False")]
		[System.String]
		$Enable
	)

	Write-Verbose "Get the Windows Server Update Service automatic minor updates installation status"

    Try {
        if ((Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name AutoInstallMinorUpdates -ErrorAction SilentlyContinue) -eq "1") {
            $AutoInstallMinorUpdates = "True"
        }
        else {
            $AutoInstallMinorUpdates = "False"
        }
    }
    Catch {
        $AutoInstallMinorUpdates = "False"
    }

	$returnValue = @{
		Enable = $AutoInstallMinorUpdates
	}

	$returnValue

}


function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("True","False")]
		[System.String]
		$Enable
	)

	
    if ($Enable -eq "true") {
        Write-Verbose "Set the Windows Server Update Service automatic minor updates installation status to: True"
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name AutoInstallMinorUpdates -Value 1 -type dword -Force
    }
    else {
        Write-Verbose "Set the Windows Server Update Service automatic minor updates installation status to: false"
        Set-ItemProperty -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name AutoInstallMinorUpdates -Value 0 -type dword -Force
    }

}


function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param (
		[parameter(Mandatory = $true)]
		[ValidateSet("True","False")]
		[System.String]
		$Enable
	)

	Write-Verbose "Test if the Windows Server Update Service automatic minor updates installation status is set to $Enable"
    
    Try {
        $State = Get-ItemPropertyValue -path "HKLM:\SOFTWARE\Policies\Microsoft\windows\WindowsUpdate\AU" -name AutoInstallMinorUpdates -ErrorAction SilentlyContinue
    }
    Catch {
        $State = "0"
    }
    Switch ($Enable) {
        'True' { 
            if ($State -eq "1") {
                Write-Verbose "OK: Test if the Windows Server Update Service automatic minor updates installation status is set to True"
                $Return = $true
            }
            elseif ($state -eq "0") {
                Write-Verbose "NOK: Test if the Windows Server Update Service automatic minor updates installation status is set to False and should be True"
                $Return = $false
            }
        }
        'False' {
            if ($State -eq "1") {
                Write-Verbose "OK: Test if the Windows Server Update Service automatic minor updates installation status is set to False"
                $Return = $false
            }
            elseif ($state -eq "0") {
                Write-Verbose "NOK: Test if the Windows Server Update Service automatic minor updates installation status is set to False and should be True"
                $Return = $true
            }
        }
    }
    $Return
}


Export-ModuleMember -Function *-TargetResource

