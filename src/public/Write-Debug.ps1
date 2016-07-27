﻿Function Write-Debug {
<#
.SYNOPSIS
    Writes a debug message to the console.
    
.DESCRIPTION
    The Write-Debug cmdlet writes debug messages to the console from a script or command.
    
    By default, debug messages are not displayed in the console, but you can display them by using the Debug parameter or the $DebugPreference variable.
    
.EXAMPLE
    PS C:\>Write-Debug "Cannot open file."
    This command writes a debug message. Because the value of $DebugPreference is "SilentlyContinue", the message is not displayed in the console.
    
.EXAMPLE
    PS C:\>$DebugPreference
    SilentlyContinue
    PS C:\>Write-Debug "Cannot open file."
    PS C:\>
    PS C:\>Write-Debug "Cannot open file." -debug
    DEBUG: Cannot open file.
    This example shows how to use the Debug common parameter to override the value of the $DebugPreference variable for a particular command.
    The first command displays the value of the $DebugPreference variable, which is "SilentlyContinue", the default.
    The second command writes a debug message but, because of the value of $DebugPreference, the message does not appear.
    The third command writes a debug message. It uses the Debug common parameter to override the value of $DebugPreference and to display the debug messages resulting from this command.
    As a result, even though the value of $DebugPreference is "SilentlyContinue", the debug message appears.
    For more information about the Debug common parameter, see about_CommonParameters.
    
.EXAMPLE
    PS C:\>$DebugPreference
    SilentlyContinue
    PS C:\>Write-Debug "Cannot open file."
    PS C:\>
    PS C:\>$DebugPreference = "Continue"
    PS C:\>Write-Debug "Cannot open file."
    DEBUG: Cannot open file.
    This command shows the effect of changing the value of the $DebugPreference variable on the display of debug messages.
    The first command displays the value of the $DebugPreference variable, which is "SilentlyContinue", the default.
    The second command writes a debug message but, because of the value of $DebugPreference, the message does not appear.
    The third command assigns a value of "Continue" to the $DebugPreference variable.
    The fourth command writes a debug message, which appears on the console.
    For more information about $DebugPreference, see about_Preference_Variables.
    
.INPUTS
    System.String
    
.OUTPUTS
    None
#>


    [CmdletBinding(HelpUri='http://go.microsoft.com/fwlink/?LinkID=113424', RemotingCapability='None')]
     param(
         [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
         [Alias('Msg')]
         [AllowEmptyString()]
         [string]
         ${Message})
     
     begin
     {
        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
         try {
             $outBuffer = $null
             if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
             {
                 $PSBoundParameters['OutBuffer'] = 1
             }
             $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Debug', [System.Management.Automation.CommandTypes]::Cmdlet)
             $scriptCmd = {& $wrappedCmd @PSBoundParameters }
             $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
             $steppablePipeline.Begin($PSCmdlet)
         } catch {
             throw
         }
     }
     
     process
     {
         try {
             $steppablePipeline.Process($_)
         } catch {
             throw
         }
     }
     
     end
     {
        if ($script:Logger -ne $null) {
            $script:Logger.Trace($Message)
        }
         try {
             $steppablePipeline.End()
         } catch {
             throw
         }
     }
}
