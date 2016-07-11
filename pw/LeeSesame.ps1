<#

funciones base de datos sesame

#>





<#
function setTriple {
}
function CalibreToTurtle {
get-childitem -path C:\users\usuario\Desktop\docs\*.opf |
 foreach-object { ([xml](Get-Content $_)).package.metadata.description} | out-file xx.out
}

#>


function invoke-SesameQuery {<#
.SYNOPSIS
Envia query SPARQL a la base datos rdf Sesame.
.DESCRIPTION
Envia query SPARQL a la base datos rdf Sesame. Control de errores mediante Try/catch. Devuelve un objeto
powershell con las propiedades del SELECT SPARQL. En caso de actualizaciones u otras operaciones que no devuelvan
datos el objeto será null. Pide los datos en JASON y son convertidos a objeto PWSHELL. 

.PARAMETER query
string con el contenido de la QUERY SPARQL
.EXAMPLE

.EXAMPLE

#>




param (
    [Parameter(Mandatory=$True,
            ValueFromPipeline=$False,
            HelpMessage="Introduzca query (sparql 1.1)")]
    [string]$query
    
    
)

Add-Type -Assembly System.Web   
 
$sesame = "http://localhost:8080/openrdf-sesame/repositories/DGT"
$content_type = ""



# Next, allow the use of self-signed SSL certificates.

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

# Create variables to store the values consumed by the Invoke-RestMethod command. The search variable contents are later embedded in the body variable.

$servidor = "DGT79159"
$url = "https://${servidor}:8080/openrdf-sesame/repositories/DGT/statements"
$query = "SELECT ?p ?o WHERE {?s ?p ?o} LIMIT 50"



$body = @{
    search = $search
    output_mode = "csv"
    earliest_time = "-2d@d"
    latest_time = "-1d@d"
}


Invoke-RestMethod -Method Post -Uri $url -Credential $cred -Body $body 

cmdlet Get-Credential at command pipeline position 1






<#
function nueva-norma {
param
    ley
    extracto
    titulo (label)
    extracto (comment)
    url

#>






function convert-calibre {
<#
.SYNOPSIS
Transforma la salida xml de la biblioteca de Calibre en un fichero turtle.
.DESCRIPTION
Transforma la salida xml de la biblioteca de Calibre en un fichero turtle.
.PARAMETER xmlCalibre
fichero xml exportado por calibre
.PARAMETER LogErrores
Crea un fichero con los libros no convertidos
.PARAMETER ErrorLog
Cuando se especifica con -LogErrores, especifica el path y nombre del fichero donde
se escribiran los libros no convertidos.
.EXAMPLE
Calibretoturtle libros.xml
.EXAMPLE
Calibretoturtle libros.xml -xmlCalibre libros.xml -LogErrores -ErrorLog c:/noconvertidos.txt
#>




param (
    [Parameter(Mandatory=$True,
            ValueFromPipeline=$False,
            HelpMessage="Nombre del fichero exportado de calibre")]
    [string]$xmlCalibre,
    [string]$ErrorLog = 'c:\noconvertidos.txt',
    [switch]$LogErrors
    
)

Add-Type -Assembly System.Web    

$GrafoTTL = @"
        PREFIX expression: <http://www.estrellaproject.org/lkif-core/expression.owl#>
        PREFIX legal-action:<http://www.estrellaproject.org/lkif-core/legal-action.owl#>
        PREFIX prov:<http://www.w3.org/ns/prov#>
        PREFIX lkif-extended:<http://www.estrellaproject.org/lkif-core/lkif-extended.owl#>
        PREFIX foaf:<http://xmlns.com/foaf/0.1/>
        PREFIX dgt:<http://DGT35160:8080/dgt/>
        PREFIX lkif-core:<http://www.estrellaproject.org/lkif-core/lkif-core.owl#>
        PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
        PREFIX norm:<http://www.estrellaproject.org/lkif-core/norm.owl#>
        PREFIX xsd:<http://www.w3.org/2001/XMLSchema#>
        PREFIX action:<http://www.estrellaproject.org/lkif-core/action.owl#>
        PREFIX owl:<http://www.w3.org/2002/07/owl#>
        PREFIX legal-role:<http://www.estrellaproject.org/lkif-core/legal-role.owl#>
        PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
        PREFIX skos:<http://www.w3.org/2004/02/skos/core#>
        <http://localhost:8080/dgt/documentos>
            rdf:type owl:Ontology ;
            owl:imports <http://localhost:8080/dgt/onto> ;
	        rdf:comment "fichero de documentos editados y convertidos desde calibre  los usuarios autorizados" ;
            owl:versionInfo "se recogen los documentos del calibre y se pasan a rdf, luego edición manual	" .

"@


    
     

	

   
    
    Write-Verbose "El fichero log de errores es $ErrorLog"
    $xmlCalibre = (resolve-path $xmlCalibre).ProviderPath
    
    ([xml](Get-Content $xmlCalibre)).calibredb.record |
     ForEach-Object {
        $id = [System.Web.HttpUtility]::UrlEncode($_.title.sort) 
        $titulo = $_.title.sort
        $autor =  $_.authors.author 
        $editor = if ($_.publisher) {$_.publisher} else {"Desconocido"}
        $size = $_.size
        $url =  [System.Web.HttpUtility]::UrlEncode($_.formats.format)     
        $tags = $_.tags.tag
	    $fechaPubl = $_.pubdate 
	    $fechaModi = $_.pubdate
	    $cover =if ($_.cover) {$_.cover} else {"Sin portada"}        
        $FechaGenerado = get-date

$libroTTL = @"
    $id 
        rdf:type foaf:document ;
        rdfs:label "$titulo" ;
	    dc:creator "$autor" ;
	    dc:publisher "$editor" ;
	    rdfs:url <$url> ;
	    dc:subject "$tags" ;
	   dct:issued "$fechaPubl" ;
	   dct:modified "$fechaModi" ;
	   dct:extent $size ;
	   foaf:img: <$cover> ;
       prov:generatedAtTime "$FechaGenerado" ;
	   prov:wasAttributedTo "42795331" ;
       prov:wasGeneratedWith "función Powershell convert-calibre" .

"@  
       
        out-file -Append -filepath C:\users\usuario\desktop\documentos.ttl -InputObject $LibroTTL 
       
    }
