<#

.SYNOPSIS

Obtiene hardware y precios de tal sitio web

. EXAMPLE

ninguno

#>

param (
    ## A Elegir de una lista de empresas
)


## AMAZON
#$Amazon_TarjetaGrafica = "https://www.amazon.es/s/ref=nb_sb_ss_i_1_7?__mk_es_ES=%C3%85M%C3%85%C5%BD%C3%95%C3%91&url=search-alias%3Dcomputers&field-keywords=tarjeta+grafica&sprefix=TARJETA%2Caps%2C186&rh=n%3A667049031%2Ck%3Atarjeta+grafica"
#//*[@id="result_3"]/div/div[3]/div[1]/a/h2
#result_3 > div > div:nth-child(3) > div:nth-child(1) > a > h2
#result_4 > div > div:nth-child(3) > div:nth-child(1) > a > h2
#result_28 > div > div:nth-child(3) > div:nth-child(1) > a > h2


## PC COMPONENTES
#$PCCOMPONENTES_TarjetaGrafica = "http://www.pccomponentes.com/tarjetas_graficas.html"
#//*[@id="productos"]/div/div/ul/ul[1]/li[1]/div/div/span[2]/a/span
#productos > div > div > ul > ul:nth-child(1) > li:nth-child(1) > div > div 
#//*[@id="productos"]/div/div/ul/ul[3]/li[1]/div/div/span[2]/a/span> 
#//*[@id="productos"]/div/div/ul/ul[3]/li[1]/div/div/span[2]/a/span
#//*[@id="productos"]/div/div/ul/ul[2]/li[1]/div/div/div[1]/a/img

#//*[@id="productos"]/div/div/ul/ul[5]/li[1]/div/div/span[2]/a/span

$url = "http://www.pccomponentes.com/tarjetas_graficas.html"
$result = Invoke-WebRequest $url
$result.ParsedHtml
