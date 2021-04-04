Function Get-DosDevicePaths {
    <#
	.SYNOPSIS
		Resolves all volumes/drive letters to their DOS device paths, used by WSFCs/WF/etc. Credit goes to https://morgantechspace.com/2014/11/Get-Volume-Path-from-Drive-Name-using-Powershell.html

	.DESCRIPTION
		Resolves all volumes/drive letters to their DOS device paths, used by WSFCs/WF/etc. Credit goes to https://morgantechspace.com/2014/11/Get-Volume-Path-from-Drive-Name-using-Powershell.html

	.EXAMPLE
		Get-DosDevicePaths

        Lists all DOS device paths for each volume

	.OUTPUTS
    e.g.

  	DevicePath              DriveLetter
    ----------              -----------
    \Device\HarddiskVolume3 C:         
    \Device\HarddiskVolume5 D:         

	.NOTES
		https://morgantechspace.com/2014/11/Get-Volume-Path-from-Drive-Name-using-Powershell.html

  .LINK
    https://morgantechspace.com/2014/11/Get-Volume-Path-from-Drive-Name-using-Powershell.html

	#>

    # Biuild System Assembly in order to call Kernel32:QueryDosDevice. 
    $DynAssembly = New-Object System.Reflection.AssemblyName('SysUtils')
    $AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly($DynAssembly, [Reflection.Emit.AssemblyBuilderAccess]::Run)
    $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('SysUtils', $False)
 
    # Define [Kernel32]::QueryDosDevice method
    $TypeBuilder = $ModuleBuilder.DefineType('Kernel32', 'Public, Class')
    $PInvokeMethod = $TypeBuilder.DefinePInvokeMethod('QueryDosDevice', 'kernel32.dll', ([Reflection.MethodAttributes]::Public -bor [Reflection.MethodAttributes]::Static), [Reflection.CallingConventions]::Standard, [UInt32], [Type[]]@([String], [Text.StringBuilder], [UInt32]), [Runtime.InteropServices.CallingConvention]::Winapi, [Runtime.InteropServices.CharSet]::Auto)
    $DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
    $SetLastError = [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError')
    $SetLastErrorCustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder($DllImportConstructor, @('kernel32.dll'), [Reflection.FieldInfo[]]@($SetLastError), @($true))
    $PInvokeMethod.SetCustomAttribute($SetLastErrorCustomAttribute)
    $Kernel32 = $TypeBuilder.CreateType()
 
    $Max = 65536
    $StringBuilder = New-Object System.Text.StringBuilder($Max)
 
    Get-WmiObject Win32_Volume | ? { $_.DriveLetter } | % {
        $ReturnLength = $Kernel32::QueryDosDevice($_.DriveLetter, $StringBuilder, $Max)
 
        if ($ReturnLength)
        {
            $DriveMapping = @{
                DriveLetter = $_.DriveLetter
                DevicePath = $StringBuilder.ToString()
            }
 
            New-Object PSObject -Property $DriveMapping
        }
    }
}
