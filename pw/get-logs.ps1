<# 
.SYNOPSYS
    OBTIENE LOS LOGS DE LOS HOST ESPECIFICADOS
.DESCRIPTION
.PARAMETER
.EXAMPLE
.INPUTS
.OUPUTS
.NOTES   
.LINK
#>
function Get-LogHtml
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [validateSet("System", "Application", "Security")]
        [string]$LogName,
        [Parameter(Mandatory = $true)]
        [string]$SaveFile
    )
    Begin
    {
        $htmlFormat = @"
<style>
Table {border-width: 1px; border-style: solid; border-color:black;}
TH {border-width: 1px; padding: 3px; border-style: solid;}
TR:nth-child(even) {background: #CCC}
TR:nth-child(odd) {background: #FFF}
</style>
"@

   $HTMLhead += "<H1>Información del log de eventos del host
                $($env:COMPUTERNAME)</H1>"
                $HTMLhead += "<H2>Nombre del Log: $($LogName)</H2>"
           }
           Process
           {
              $events = Get-EventLog -LogName $LogName -Newest 50 | Select-Object -Property Index, EventId, Message
           }
           End
           {
                $events | convertto-html -Head $HTMLhead -body $htmlFormat | Out-File -FilePath $SaveFile
           }
      }
}
