[(english)](README_en.md)

# Bib-ACMé: Bibliografía digital de novelas argentinas, cubanas y mexicanas (1830-1910)

La bibliografía digital Bib-ACMé reúne datos sobre novelas argentinas, cubanas y mexicanas que se publicaron entre 1830 y 1910. El objetivo de la bibliografía es sobre todo hacer posible una visión general de las novelas que se publicaron en este período y ámbito geográfico y cultural. Bib-ACMé se basa en bibliografías existentes de la literatura y de las novelas argentinas, cubanas y mexicanas del siglo XIX (sobre todo los trabajos de [Myron Lichtblau](https://catalog.hathitrust.org/Record/003156022), [Arturo Torres-Rioseco](https://catalog.hathitrust.org/Record/001168729) y el [Diccionario de la Literatura Cubana](http://www.cervantesvirtual.com/obra/diccionario-de-la-literatura-cubana--0/)), llevando los registros impresos a un entorno digital para facilitar análisis cuantitativos sobre autores, obras y ediciones.

## Datos y aplicación web 
Por una parte, Bib-ACMé es una recopilación de metadatos bibliográficos codificados en XML-TEI. El conjunto de datos se encuentra en la carpeta [app/data](app/data). Los archivos TEI principales son [authors.xml](app/data/authors.xml), [works.xml](app/data/works.xml) y [editions.xml](app/data/editions.xml). Por otra parte, Bib-ACMé consiste en una aplicación web para navegar los datos. La aplicación está programada en XQuery y facilitada como una app para la base de datos XML eXist-db. La aplicación web está publicada en la página http://bibacme.cligs.digital-humanities.de.

## Proyecto, licencias y citación
El trabajo se inició en el contexto del proyecto ["Estilística computacional del género literario" (CLiGS)](https://cligs.hypotheses.org), financiado por el Ministerio de Educación e Investigación alemán (BMBF). Los datos (archivos XML-TEI) están licenciados bajo la licencia [Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) y la aplicación (el código) bajo la licencia [GNU General Public License 3.0](https://www.gnu.org/licenses/gpl-3.0.html).

Si utiliza esta aplicación o los datos incluidos, por favor haga referencia a ella. Se propone citar la aplicación de la siguiente manera: 

*Ulrike Henny-Krahmer (ed). Bib-ACMé. Bibliografía digital de novelas argentinas, cubanas y mexicanas (1830-1910). Würzburg, 2017ff.*

Si tiene sugerencias o comentarios por favor contacte ulrike.henny /at/ web.de
