[(español)](README.md)

# Bib-ACMé: Digital bibliography of Argentina, Cuban, and Mexican novels (1830-1910)

The digital bibliography Bib-ACMé is a collection of data about Argentine, Cuban, and Mexican novels that were published between 1830 and 1910. The aim of the bibliography is to facilitate a general overview of the novels which were published in the selected period and the geographical and cultural area. Bib-ACMé is based on existing bibliographies of the Argentine, Cuban, and Mexican literature and novels of the 19th century (especially the works of [Myron Lichtblau](https://catalog.hathitrust.org/Record/003156022), [Arturo Torres-Rioseco](https://catalog.hathitrust.org/Record/001168729) and the [Diccionario de la Literatura Cubana](http://www.cervantesvirtual.com/obra/diccionario-de-la-literatura-cubana--0/))). These bibliographies, which have been primarily designed as print publications, are transferred to a digital environment to open them up for quantitative analyses about the authors, works, and editions.

## Data and web application
On the one hand, Bib-ACMé is a compilation of bibliographical metadata encoded in XML-TEI. The data set is contained in the folder [app/data](app/data). The principal TEI files are [authors.xml](app/data/authors.xml), [works.xml](app/data/works.xml), and [editions.xml](app/data/editions.xml). On the other hand, Bib-ACMé also is a web application for browsing through the data. The application is written in XQuery and provided as an app for the XML database eXist. The web application is published on the site http://bibacme.cligs.digital-humanities.de.

## Project, licenses, and citation
This work was initiated in the context of the project ["Computational Literary Genre Stylistics"](CLiGS)(https://cligs.hypotheses.org), which was financed by the Federal Ministry of Education and Research (BMBF). The data (XML-TEI files) is offered with a [Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license and the application (code) with a [GNU General Public License 3.0](https://www.gnu.org/licenses/gpl-3.0.html) license.

If you use the application or the data, please cite it as:

*Ulrike Henny-Krahmer (ed). Bib-ACMé. Bibliografía digital de novelas argentinas, cubanas y mexicanas (1830-1910). Würzburg, 2017ff.*

If you have any suggestions or comments please contact ulrike.henny /at/ web.de
