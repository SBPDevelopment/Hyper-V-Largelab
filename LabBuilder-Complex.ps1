<#
.Synopsis
   Creates a Test Lab
.DESCRIPTION
   Creates the VHDX and VM for the following:
   - SBPCMDC01
   - SBPCMSQL01
   - SBPCM
   - SBPWin07-01
   - SBPWin07-02
   - SBPWin07-03
   - SBPWin07-04
   - SBPWin07-05
   - SBPWin10-06
   - SBPWin10-07
.EXAMPLE
   .\Set-TestLab.ps1
#>

[CmdletBinding()]
[OutputType([int])]
Param()

Begin{
    Write-Verbose "Importing modules..."
    $Modules = @("Hyper-V")
    $Modules | Import-Module
    $VirtualMachines = @("SBPCMDC01","SBPCMSQL1","SBPCM","SBPCMWin07-01","SBPCMWin07-02","SBPCMWin07-03","SBPCMWin07-04","SBPCMWin07-05","SBPCMWin10-06","SBPCMWin10-07","SBPCMWin10-08")
    $VHDPath = "C:\Hyper-VServers\SBPLab01\Drives"
    $VMPath =  "C:\Hyper-VServers\SBPLab01\Machines"
}

Process{
    ForEach ($VM in $VirtualMachines) {
        Write-Verbose "Virtual Machine clean up for $VM"
        If (Get-VM -Name $VM -ErrorAction SilentlyContinue) {
            Remove-VM -Name $VM
        }
        If (Test-path -Path "$VHDPath\$VM") {
            Remove-Item "$VHDPath\$VM" -Force -Recurse
        }

        Write-Verbose "Create VHDX for $VM"
        New-VHD -Dynamic -Path "$VHDPath\$VM\$VM-C.vhdx" -SizeBytes 100GB
        Write-Verbose "Create Virtual Machine"
        New-VM -VHDPath "$VHDPath\$VM\$VM-C.vhdx" -Generation 2 -MemoryStartupBytes 1024MB -Name $VM -Path "$VMPath\$VM"
        Set-VM -Name $VM -ProcessorCount 2

	}
    }
}
End
{
}