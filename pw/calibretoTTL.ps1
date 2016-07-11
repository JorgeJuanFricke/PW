
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


[CmdletBinding()]

param (
    [Parameter(Mandatory=$True,
            ValueFromPipeline=$False,
            HelpMessage="Nombre del fichero exportado de calibre")]
    [string]]$xmlCalibre,
    [string]$ErrorLog = 'c:\noconvertidos.txt',
    [switch]$LogErrors
    
)


    

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


    
     
     $libroTTL = @"
        &Libro.id
        rdf:type foaf:document ;
        rdfs:label &libro.title ;
	    rdfs:url &
	    dc:creator &libro.authors.author ;
	    dc:publisher &libro.publisher ;
	    dc:format "EPUB" ;
	  dc:subject "Calibre" ;
	  dct:issued "0101-01-01" ;
	  dct:modified "0101-01-01" ;
	  # dct:tableOfContents "" ;
	  dct:extent 130579 ;
	  foaf:img: <C:/DATOS/dcmtos/JohnSchember/CalibreQuickStartGuide(1)/cover.jpg>
	  
	  prov:wasGeneratedBy "dgt:edición" ;
	  prov:generatedAtTime "20150313" ;
	  prov:wasAttributedTo "42795331" .
	
"@
    }
    $xmlCalibre = (resolve-path $xmlCalibre).ProviderPath
    $settings = new-object System.Xml.XmlReaderSettings
    $settings.ProhibitDTD = $false
    $reader = [xml.xmlreader]::create($xmlCalibre, $settings)
    $libro = ""
 }

        Write-Verbose "El fichero log de errores es $ErrorLog"
        # foreach --no multiples entradas
        while ($libro = $reader.Read()) {
            write-out $libro
