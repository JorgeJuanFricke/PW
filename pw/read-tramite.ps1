<#
LDATAlee-Recurso.PSM1

.SYNOPSIS
lee recurso, si pone propiedades solo las pedidas, si no pasar por todas


.EXAMPLE

LDATAlread-tramite -sujeto dgt:tramiteTRAN -propiedad etiqueta, comentario
pedir datos etiqueta y comentario

LDATAread-tramite -sujeto dgt:tramiteINTE
pedir todas las propiedades


#>
$myHash = @{sujeto="";propiedad="";objeto=""} 
$triple = new-object psObject -property $myhash
$triples = @($triple)
$triple.sujeto = read-host -prompt "Sujeto"
$triple.propiedad = "dgt:etiqueta"
$triple.objeto = read-host -prompt "etiqueta"
$triples.add($triple)
<#
$triple.propiedad = "dgt:comentario"
$triple.objeto = read-host -prompt "comentario"
$triples.add($triple)
$triples.count
#>

$triples

