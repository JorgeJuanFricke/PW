


function invoke-SesameQuery {<#
.SYNOPSIS
Envia query SPARQL a la base datos rdf Sesame.
.DESCRIPTION
Envia query SPARQL a la base datos rdf Sesame. Control de errores mediante Try/catch. Devuelve un objeto
powershell con las propiedades del SELECT SPARQL. En caso de actualizaciones u otras operaciones que no devuelvan
datos el objeto será null. Pide los datos en JSON y son convertidos automaticamente a un PSObject: 
(NO hace falta CONVERTTO-JSON). 

.PARAMETER query
string con el contenido de la QUERY SPARQL
.EXAMPLE

.EXAMPLE

#>

<#
$myHash = @{sujeto="";propiedad="";objeto=""} 
$triple = new-object psObject -property $myhash
#>

param (
    [Parameter(Mandatory=$True,
            ValueFromPipeline=$False,
            HelpMessage="Introduzca query (sparql 1.1)")]
    [string]$query
    
    
)

Add-Type -Assembly System.Web   
 


$url = "http://localhost:8080/openrdf-sesame/repositories/DGT"
$body = @{query = $query} 
$headers = New-object "System.collections.generic.dictionary[[string],[string]]"
$headers.add("tuAccept", "application/sparql-results+json")
 


Try {
    $datos = Invoke-RestMethod -Method GET -Uri $url -Body $body -headers $headers -ContentType 'application/x-www-form-urlencoded'  -Erroraction Stop -verbose
    
    $datos

        }

Catch {
   
    write-output $Error
    }
}


invoke-sesameQuery "SELECT ?s where {?s ?p ?o}" 
