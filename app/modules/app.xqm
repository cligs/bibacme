xquery version "3.0";

module namespace app="http://localhost/app";


declare namespace tei="http://www.tei-c.org/ns/1.0";
declare default collation "?lang=es";
declare variable $app:root := "/db/apps/bibacme";
declare variable $app:home := "/exist/apps/bibacme";
declare variable $app:works := doc(concat($app:root, "/data/works.xml"))//tei:listBibl/tei:bibl;
declare variable $app:authors := doc(concat($app:root, "/data/authors.xml"))//tei:person;
declare variable $app:editions := doc(concat($app:root, "/data/editions.xml"))//tei:listBibl/tei:biblStruct;
declare variable $app:sources := doc(concat($app:root, "/data/sources.xml"))//tei:bibl;
declare variable $app:decades := ("1840", "1850", "1860", "1870", "1880", "1890", "1900", "1910");
declare variable $app:decade-labels := ("1830-1840", "1841-1850", "1851-1860", "1861-1870", "1871-1880", "1881-1890", "1891-1900", "1901-1910");
declare variable $app:countries := doc(concat($app:root, "/data/countries.xml"))//tei:listPlace/tei:place;
declare variable $app:nationalities := doc(concat($app:root, "/data/nationalities.xml"))//tei:item;
declare variable $app:alphabet := ("A", "B", "C", "CH", "D", "E", "F", "G", "H", "I", "J", "K", "L", "LL",
"M", "N", "Ñ", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");

import module namespace overviews="http://localhost/overviews" at "overviews.xqm";
import module namespace data="http://localhost/data" at "data.xqm";



(: ######################### PAGES ######################## :)


(: ########## overview authors ########## :)
declare function app:authors($currpage as numeric, $currnationality as xs:string?, $currdecade as xs:string?, $currcountry as xs:string?, $currletter as xs:string?){
    let $authors-ordered := for $author at $pos in $app:authors
                               let $surname := data($author//tei:surname)
                               let $forename := data($author//tei:forename)
                               let $name := string-join(($surname, $forename), ", ")
                               let $id := $author/@xml:id
                               let $nationality := $author/tei:nationality
                               let $decades := data:get-author-decades($id)
                               let $countries := data:get-author-countries($id)
                               let $letter := data:get-first-letter($name)
                               where every $val in 
                                        (if ($currletter) then $currletter = $letter else true(),
                                        if ($currnationality) then $currnationality = $nationality else true(),
                                        if ($currdecade) then $currdecade = $decades else true(),
                                        if ($currcountry) then $currcountry = $countries else true())
                                        satisfies $val = true()
                               order by $name
                               return $author
    let $num-authors := count($authors-ordered)
    let $num-pages := max((1,xs:integer(ceiling($num-authors div 15))))
    return
    <section>
        <h2>Autores ({$num-authors})</h2>
        <div class="pagenav">
            {if ($num-authors > 0)
            then
            <ul>
                <li>Páginas:</li>
                {if ($currpage > 3)
                 then <li><a href="{$app:home}/autores?p=1&amp;nacionalidad={$currnationality}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;letra={$currletter}">1</a> ...</li>
                 else (),
                 if ($currpage > 2)
                 then <li><a href="{$app:home}/autores?p={$currpage - 2}&amp;nacionalidad={$currnationality}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;letra={$currletter}">{$currpage - 2}</a></li>
                 else(),
                 if ($currpage > 1)
                 then <li><a href="{$app:home}/autores?p={$currpage - 1}&amp;nacionalidad={$currnationality}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;letra={$currletter}">{$currpage - 1}</a></li>
                 else (),
                 <li>{$currpage}</li>,
                 if ($currpage < $num-pages)
                 then <li><a href="{$app:home}/autores?p={$currpage + 1}&amp;nacionalidad={$currnationality}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;letra={$currletter}">{$currpage + 1}</a></li>
                 else(),
                 if ($currpage < $num-pages - 1)
                 then <li><a href="{$app:home}/autores?p={$currpage + 2}&amp;nacionalidad={$currnationality}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;letra={$currletter}">{$currpage + 2}</a></li>
                 else (),
                 if ($currpage < $num-pages - 2)
                 then <li>... <a href="{$app:home}/autores?p={$num-pages}&amp;nacionalidad={$currnationality}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;letra={$currletter}">{$num-pages}</a></li>
                 else()}
            </ul>
            else <p>No hay resultados para esta búsqueda.</p>}
        </div>
        <ul>
            {
            for $author in $authors-ordered[position() = xs:integer($currpage * 15 - 15) to xs:integer($currpage * 15)]
            let $author-key := $author/@xml:id
            let $author-name := data:get-author-name($author-key, "surname")
            order by $author-name
            return 
                <li><a href="{$app:home}/autor/{$author-key}">{$author-name}</a><br/><span class="italic smaller">{data:get-author-nationality($author)}</span></li>
            }
        </ul>
        <form action="#" method="GET" style="position: absolute; top: 0; right: 0;">
            <select name="letra" onchange="this.form.submit()">
                <option class="default" value="">letra</option>
                {for $let in $app:alphabet
                order by $let
                return
                    <option>
                        {if ($let = $currletter)
                        then attribute selected {"selected"}
                        else ()}{$let}
                    </option>}
            </select>
            <select name="decada" onchange="this.form.submit()">
                <option class="default" value="">década</option>
                {for $dec at $pos in $app:decades
                let $dec-label := $app:decade-labels[$pos]
                return
                    <option value="{$dec}">
                        {if ($dec = $currdecade)
                        then attribute selected {"selected"}
                        else ()}{$dec-label}
                    </option>}
            </select>
            <select name="pais" onchange="this.form.submit()">
                <option class="default" value="">país</option>
                {for $country at $pos in $app:countries
                let $short := $country/@xml:id
                return
                    <option value="{$short}">
                        {if ($short = $currcountry)
                        then attribute selected {"selected"}
                        else ()}{$country}</option>}
            </select>
            <select name="nacionalidad" onchange="this.form.submit()">
                <option class="default" value="">nacionalidad / origen</option>
                {for $nac in $app:nationalities/tei:term[@type="general"]
                order by $nac
                return
                    <option>
                        {if ($nac = $currnationality)
                        then attribute selected {"selected"}
                        else ()}{$nac}
                    </option>}
            </select>
            <button class="link" onclick="resetForm(), this.form.reset()" style="float: right;">borrar</button>
            <script type="text/javascript">
                function resetForm(){{
                    opts = document.getElementsByTagName('option');
                    for (i = 0; i &lt; opts.length; i++){{
                        opts[i].removeAttribute('selected');
                    }}
                }}
            </script>
        </form>
    </section>
};



(: ########## single page author ########## :)
declare function app:author($id as xs:string){
    let $author := $app:authors[@xml:id=$id]
    let $surname := $author/tei:persName/tei:surname/data(.)
    let $author-key := $author/@xml:id
    let $author-name := data:get-author-name($author-key, "forename")
    let $nationality := $author/tei:nationality/data(.)
    let $birth := $author//tei:birth
    let $death := $author//tei:death
    return
    <section class="author">
        <h2>{$author-name}</h2>
        <!-- to do: mit XSLT noch mehr Infos ausgeben -->
        <p>({$nationality})</p>
        {if ($birth)
        then <p>Nacido: {string-join(($birth/tei:date, $birth/tei:placeName), " en ")}.</p>
        else()}
        {if ($death)
        then <p>Muerto: {string-join(($death/tei:date, $death/tei:placeName), " en ")}.</p>
        else()}
    </section>,
    <section class="author">
        <h3>Obras</h3>
        <ul>
            {
            for $work in $app:works[tei:author/@key = $id]
            let $title := $work/tei:title/data(.)
            order by $title
            return 
                <li><a href="{$app:home}/obra/{$work/@xml:id}">{$title}</a></li>
            }
        </ul>
    </section>
};



(: ########## overview works ########## :)
declare function app:works($currpage as numeric, $currauthor as xs:string?, $currdecade as xs:string?, $currcountry as xs:string?, $currletter as xs:string?){
    
    let $works-ordered := for $work at $pos in $app:works
                               let $title := data($work//tei:title[1])
                               let $author := $work//tei:author
                               let $decade := data:get-first-edition-decade($work/@xml:id)
                               let $countries := data:get-publication-countries($work/@xml:id)
                               let $letter := data:get-first-letter($title)
                               where every $val in 
                                        (if ($currletter) then $currletter = $letter else true(),
                                        if ($currauthor) then $author = $currauthor else true(),
                                        if ($currdecade) then $decade = $currdecade else true(),
                                        if ($currcountry) then $currcountry = $countries else true())
                                        satisfies $val = true()
                               order by translate($title,"¡¿","")
                               return $work
    let $num-works := count($works-ordered)
    let $num-pages := max((1,xs:integer(ceiling($num-works div 15))))
    return
    <section class="works">
        <h2>Obras ({$num-works})</h2>
        <div class="pagenav">
        {if ($num-works > 0)
            then
            <ul>
                <li>Páginas:</li>
                {if ($currpage > 3)
                 then <li><a href="{$app:home}/obras?p=1&amp;autor={$currauthor}&amp;decada={$currdecade}&amp;pais={$currcountry}">1</a> ...</li>
                 else (),
                 if ($currpage > 2)
                 then <li><a href="{$app:home}/obras?p={$currpage - 2}&amp;autor={$currauthor}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;letra={$currletter}">{$currpage - 2}</a></li>
                 else(),
                 if ($currpage > 1)
                 then <li><a href="{$app:home}/obras?p={$currpage - 1}&amp;autor={$currauthor}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;letra={$currletter}">{$currpage - 1}</a></li>
                 else (),
                 <li>{$currpage}</li>,
                 if ($currpage < $num-pages)
                 then <li><a href="{$app:home}/obras?p={$currpage + 1}&amp;autor={$currauthor}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;letra={$currletter}">{$currpage + 1}</a></li>
                 else(),
                 if ($currpage < $num-pages - 1)
                 then <li><a href="{$app:home}/obras?p={$currpage + 2}&amp;autor={$currauthor}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;letra={$currletter}">{$currpage + 2}</a></li>
                 else (),
                 if ($currpage < $num-pages - 2)
                 then <li>... <a href="{$app:home}/obras?p={$num-pages}&amp;autor={$currauthor}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;letra={$currletter}">{$num-pages}</a></li>
                 else()}
            </ul>
            else <p>No hay resultados para esta búsqueda.</p>}
        </div>
        <ul>
            {
            for $work at $pos in $works-ordered[position() = xs:integer($currpage * 15 - 15) to xs:integer($currpage * 15)]
            let $title := data($work//tei:title)
            let $cligs-id := $work//tei:idno[@type='cligs']
            let $author-key := $work//tei:author/@key
            let $author-name := data:get-author-name($author-key, "forename")
            return
                <li><a href="{$app:home}/obra/{$work/@xml:id}">{$title}</a><br/><span class="italic smaller">{string-join($author-name,", ")}</span></li>
            }
        </ul>
        <form action="#" method="GET" style="position: absolute; top: 0; right: 0;">
            <select name="letra" onchange="this.form.submit()">
                <option class="default" value="">letra</option>
                {for $let in $app:alphabet
                order by $let
                return
                    <option>
                        {if ($let = $currletter)
                        then attribute selected {"selected"}
                        else ()}{$let}
                    </option>}
            </select>
            <select name="autor" onchange="this.form.submit()">
                <option class="default" value="">autor</option>
                {for $author in $app:authors
                let $author-key := $author/@xml:id
                let $author-name := data:get-author-name($author-key, "surname")
                order by $author-name
                return 
                    <option>
                        {if ($author-name = $currauthor)
                        then attribute selected {"selected"}
                        else ()}{$author-name}
                    </option>}
            </select>
            <select name="decada" onchange="this.form.submit()">
                <option class="default" value="">década</option>
                {for $dec at $pos in $app:decades
                let $dec-label := $app:decade-labels[$pos]
                return
                    <option value="{$dec}">
                        {if ($dec = $currdecade)
                        then attribute selected {"selected"}
                        else ()}{$dec-label}
                    </option>}
            </select>
            <select name="pais" onchange="this.form.submit()">
                <option class="default" value="">país</option>
                {for $country at $pos in $app:countries
                let $short := $country/@xml:id
                return
                    <option value="{$short}">
                        {if ($short = $currcountry)
                        then attribute selected {"selected"}
                        else ()}{$country}</option>}
            </select>
            <button class="link" onclick="resetForm(), this.form.reset()" style="float: right;">borrar</button>
            <script type="text/javascript">
                function resetForm(){{
                    opts = document.getElementsByTagName('option');
                    for (i = 0; i &lt; opts.length; i++){{
                        opts[i].removeAttribute('selected');
                    }}
                }}
            </script>
        </form>
    </section>
};



(: ########## single page work ########## :)
declare function app:work($id as xs:string){
    let $work := $app:works[@xml:id = $id]
    let $title := $work/tei:title/data(.)
    let $authors := $work/tei:author
    let $editions := $app:editions[some $work-id in tokenize(@corresp,'\s') satisfies $work-id = $id]
    return
    (<section class="work">
        <h2>{$title}</h2>
        {for $author in $authors
         return 
            <p>Autor(a): <a href="{$app:home}/autor/{$author/@key}">{$author}</a></p>
        }
    </section>,
    <section class="work">
        <h3>Ediciones</h3>
        <ul>
            { 
               for $edition in $editions
               let $result := transform:transform($edition, doc(concat($app:root, "/stylesheets/edition.xsl")), ())
               let $date := $edition//tei:date
               let $date-value := if ($date[@when])
                                  then substring($date/@when,1,4)
                                  else if ($date[@from and @to])
                                  then substring($date/@to,1,4)
                                  else $date
               order by $date-value empty least
               return $result
            }
        </ul>
    </section>)
};


(: ########## overview editions ########## :)
declare function app:editions($currpage as numeric, $currauthor as xs:string?, $currdecade as xs:string?, $currcountry as xs:string?, $currwork as xs:string?, $order as xs:string, $currletter as xs:string?){
    
    let $editions-ordered := for $edition at $pos in $app:editions
                               let $title := data(($edition//tei:title)[1])
                               let $author := $edition//tei:author
                               let $date := ($edition//tei:date)[1]
                               let $place := ($edition//tei:pubPlace)[1]
                               let $decade := data:get-edition-decade($date)
                               let $year := data:get-edition-year($date)
                               let $year := if ($year != 0) then $year else ()
                               let $country := $place/@corresp
                               let $work-ids := tokenize($edition/@corresp,"\s")
                               let $letter := data:get-first-letter($title)
                               let $order-title := translate($title,"¡¿","")
                               where every $val in 
                                        (if ($currletter) then $currletter = $letter else true(),
                                        if ($currauthor) then $author = $currauthor else true(),
                                        if ($currdecade) then $decade = $currdecade else true(),
                                        if ($currcountry) then $currcountry = $country else true(),
                                        if ($currwork)  then $currwork = $work-ids else true())
                                        satisfies $val = true()
                               order by if ($order = "alfabetico") then $order-title else $year ascending empty greatest, $order-title
                               return $edition
    let $num-editions := count($editions-ordered)
    let $num-pages := max((1,xs:integer(ceiling($num-editions div 15))))
    return
    <section class="ediciones">
        <h2>Ediciones ({$num-editions})</h2>
        <div class="pagenav">
        {if ($num-editions > 0)
            then
            (<ul>
                <li>Páginas:</li>
                {if ($currpage > 3)
                 then <li><a href="{$app:home}/ediciones?p=1&amp;autor={$currauthor}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;obra={$currwork}&amp;letra={$currletter}&amp;orden={$order}">1</a> ...</li>
                 else (),
                 if ($currpage > 2)
                 then <li><a href="{$app:home}/ediciones?p={$currpage - 2}&amp;autor={$currauthor}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;obra={$currwork}&amp;letra={$currletter}&amp;orden={$order}">{$currpage - 2}</a></li>
                 else(),
                 if ($currpage > 1)
                 then <li><a href="{$app:home}/ediciones?p={$currpage - 1}&amp;autor={$currauthor}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;obra={$currwork}&amp;letra={$currletter}&amp;orden={$order}">{$currpage - 1}</a></li>
                 else (),
                 <li>{$currpage}</li>,
                 if ($currpage < $num-pages)
                 then <li><a href="{$app:home}/ediciones?p={$currpage + 1}&amp;autor={$currauthor}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;obra={$currwork}&amp;letra={$currletter}&amp;orden={$order}">{$currpage + 1}</a></li>
                 else(),
                 if ($currpage < $num-pages - 1)
                 then <li><a href="{$app:home}/ediciones?p={$currpage + 2}&amp;autor={$currauthor}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;obra={$currwork}&amp;letra={$currletter}&amp;orden={$order}">{$currpage + 2}</a></li>
                 else (),
                 if ($currpage < $num-pages - 2)
                 then <li>... <a href="{$app:home}/ediciones?p={$num-pages}&amp;autor={$currauthor}&amp;decada={$currdecade}&amp;pais={$currcountry}&amp;obra={$currwork}&amp;letra={$currletter}&amp;orden={$order}">{$num-pages}</a></li>
                 else()}
            </ul>,
            <ul>
                <li>Orden:
                    <form action="#" method="GET">
                        <input type="radio" value="alfabetico" name="orden" id="alfabetico" onchange="this.form.submit()">
                            {if ($order = "alfabetico")
                            then attribute checked {"checked"}
                            else ()}
                        </input>
                        <label for="alfabetico">alfabético</label>
                        <input type="radio" value="cronologico" name="orden" id="cronologico" onchange="this.form.submit()">
                            {if ($order = "cronologico")
                            then attribute checked {"checked"}
                            else ()}
                        </input>
                        <input type="hidden" name="obra" value="{$currwork}"/>
                        <input type="hidden" name="autor" value="{$currauthor}"/>
                        <input type="hidden" name="decada" value="{$currdecade}"/>
                        <input type="hidden" name="pais" value="{$currcountry}"/>
                        <input type="hidden" name="letra" value="{$currletter}"/>
                        <label for="cronologico">cronológico</label>
                    </form>
                </li>
            </ul>)
            else <p>No hay resultados para esta búsqueda.</p>}
        </div>
        <ul>
            {
            for $edition in $editions-ordered[position() = xs:integer($currpage * 15 - 15) to xs:integer($currpage * 15)]
            let $title := data(($edition//tei:title)[1])
            let $year := data:get-edition-year(($edition//tei:date)[1])
            let $author-key := $edition//tei:author/@key
            let $author-name := data:get-author-name($author-key, "forename")
            let $edition-id := $edition/@xml:id
            return
                <li>
                    <a href="{$app:home}/edicion/{$edition-id}">{$title}</a><br/><span class="italic smaller">{string-join($author-name,", ")}{if ($year) then concat(", ", $year) else ()}</span>
                </li>
            }
        </ul>
        <form action="#" method="GET" style="position: absolute; top: 0; right: 0;">
            <select name="letra" onchange="this.form.submit()">
                <option class="default" value="">letra</option>
                {for $let in $app:alphabet
                order by $let
                return
                    <option>
                        {if ($let = $currletter)
                        then attribute selected {"selected"}
                        else ()}{$let}
                    </option>}
            </select>
            <select name="obra" onchange="this.form.submit()">
                <option class="default" value="">obra</option>
                {for $work at $pos in $app:works
                let $work-id := $work/@xml:id
                let $work-title := $work/tei:title[1]
                order by $work-title
                return
                    <option value="{$work-id}">
                        {if ($work-id = $currwork)
                        then attribute selected {"selected"}
                        else ()}{$work-title}</option>}
            </select>
            <select name="autor" onchange="this.form.submit()">
                <option class="default" value="">autor</option>
                {for $author in $app:authors
                let $author-key := $author/@xml:id
                let $author-name := data:get-author-name($author-key, "surname")
                order by $author-name
                return 
                    <option>
                        {if ($author-name = $currauthor)
                        then attribute selected {"selected"}
                        else ()}{$author-name}
                    </option>}
            </select>
            <select name="decada" onchange="this.form.submit()">
                <option class="default" value="">década</option>
                {for $dec at $pos in $app:decades
                let $dec-label := $app:decade-labels[$pos]
                return
                    <option value="{$dec}">
                        {if ($dec = $currdecade)
                        then attribute selected {"selected"}
                        else ()}{$dec-label}
                    </option>}
            </select>
            <select name="pais" onchange="this.form.submit()">
                <option class="default" value="">país</option>
                {for $country at $pos in $app:countries
                let $short := $country/@xml:id
                return
                    <option value="{$short}">
                        {if ($short = $currcountry)
                        then attribute selected {"selected"}
                        else ()}{$country}</option>}
            </select>
            <input type="hidden" name="orden" value="{$order}"/>
            <button class="link" onclick="resetForm(), this.form.reset()" style="float: right;">borrar</button>
            <script type="text/javascript">
                function resetForm(){{
                    opts = document.getElementsByTagName('option');
                    for (i = 0; i &lt; opts.length; i++){{
                        opts[i].removeAttribute('selected');
                    }}
                }}
            </script>
        </form>
    </section>
};



(: ########## single page edition ########## :)
declare function app:edition($id as xs:string){
    let $edition := $app:editions[@xml:id = $id]
    let $authors := $edition//tei:author
    let $works := $app:works[@xml:id = tokenize($edition/@corresp, "\s")]
    return
    <section class="edition">
        <h2>Edición</h2>
        {transform:transform($edition, doc(concat($app:root, "/stylesheets/edition.xsl")), ())}
        {for $author in $authors
         return <p>Autor(a): <a href="{$app:home}/autor/{$author/@key}">{$author/data(.)}</a></p>}
        {for $work in $works
         return <p>Obra: <a href="{$app:home}/obra/{$work/@xml:id}">{$work/tei:title/data(.)}</a></p>}
    </section>
};




(: ########## sinopsis pages ########## :)

declare function app:autores-por-nacionalidad(){
    (<h2>Sinopsis</h2>,
    (: number of authors per country :)
    let $data := map {
        "x" := data:get-nationalities(),
        "y" := data:get-nationality-numbers()
    }
    let $params := map {
        "title" := "Autores por nacionalidad / origen",
        "containerId" := "ChartAutores_1",
        "xaxis-title" := "nacionalidad / origen",
        "yaxis-title" := "número de autores"
    }
    return
    (<div id="ChartAutores_1" style="width:700px;height:600px;margin: 0 auto;"></div>,
    overviews:bar-chart($params, $data)))
};


declare function app:autores-por-sexo(){
    (<h2>Sinopsis</h2>,
    (: number of authors by sex :)
    let $data := map {
        "labels" := data:get-sexes(),
        "values" := data:get-sex-numbers()
    }
    let $params := map {
        "title" := "Autores por sexo",
        "containerId" := "ChartAutores_2"
    }
    return
    (<div id="ChartAutores_2" style="width:500px;height:500px;margin: 0 auto;"></div>,
    overviews:pie-chart($params, $data)))
};


declare function app:obras-por-ano(){
    (<h2>Sinopsis</h2>,
    (: number of works per year (by first edition):)
    let $first-ed-years := for $work in $app:works
                           let $work-id := $work/@xml:id
                           let $year := data:get-first-edition-year($work-id)
                           return $year
    let $num-editions := for $year in (1830 to 1910)
                        return count($first-ed-years[xs:integer(.) = $year])
    let $params := map {
        "title" := "Obras por año",
        "containerId" := "ChartObras_5",
        "xaxis-title" := "año",
        "yaxis-title" := "número de obras",
        "y_range" := 20
    }
    let $data := map {
        "x" := (1830 to 1910),
        "y" := $num-editions
    }
    return 
    (<div id="ChartObras_5" style="width:900px;height:400px;margin: 0 auto;"></div>,
        overviews:bar-chart($params, $data)),
        
    (: number of works per year (by first edition & argentine authors):)
    let $first-ed-years := let $author-ids := $app:authors//range:field-eq("nationality", "argentina/o")/@xml:id
                           return
                                for $work in $app:works[range:field-eq("author-key", $author-ids)]
                                let $work-id := $work/@xml:id
                                return data:get-first-edition-year($work-id)
    let $num-editions := for $year in (1830 to 1910)
                        return count($first-ed-years[xs:integer(.) = $year])
    let $params := map {
        "title" := "Obras por año (escritas por autores de nacionalidad argentina)",
        "containerId" := "ChartObras_6",
        "xaxis-title" := "año",
        "yaxis-title" := "número de obras",
        "color" := "light blue",
        "y_range" := 20
    }
    let $data := map {
        "x" := (1830 to 1910),
        "y" := $num-editions
    }
    return 
    (<div id="ChartObras_6" style="width:900px;height:400px;margin: 0 auto;"></div>,
        overviews:bar-chart($params, $data)),
        
    (: number of works per year (by first edition & cuban authors):)
    let $first-ed-years := let $author-ids := $app:authors//range:field-eq("nationality", "cubana/o")/@xml:id
                           return
                                for $work in $app:works[range:field-eq("author-key", $author-ids)]
                                let $work-id := $work/@xml:id
                                return data:get-first-edition-year($work-id)
    let $num-editions := for $year in (1830 to 1910)
                        return count($first-ed-years[xs:integer(.) = $year])
    let $params := map {
        "title" := "Obras por año (escritas por autores originarios de Cuba)",
        "containerId" := "ChartObras_7",
        "xaxis-title" := "año",
        "yaxis-title" := "número de obras",
        "color" := "#CC0000",
        "y_range" := 20
    }
    let $data := map {
        "x" := (1830 to 1910),
        "y" := $num-editions
    }
    return 
    (<div id="ChartObras_7" style="width:900px;height:400px;margin: 0 auto;"></div>,
        overviews:bar-chart($params, $data)),
        
    (: number of works per year (by first edition & mexican authors):)
    let $first-ed-years := let $author-ids := $app:authors//range:field-eq("nationality", "mexicana/o")/@xml:id
                           return
                                for $work in $app:works[range:field-eq("author-key", $author-ids)]
                                let $work-id := $work/@xml:id
                                return data:get-first-edition-year($work-id)
    let $num-editions := for $year in (1830 to 1910)
                        return count($first-ed-years[xs:integer(.) = $year])
    let $params := map {
        "title" := "Obras por año (escritas por autores de nacionalidad mexicana)",
        "containerId" := "ChartObras_8",
        "xaxis-title" := "año",
        "yaxis-title" := "número de obras",
        "color" := "#006633",
        "y_range" := 20
    }
    let $data := map {
        "x" := (1830 to 1910),
        "y" := $num-editions
    }
    return 
    (<div id="ChartObras_8" style="width:900px;height:400px;margin: 0 auto;"></div>,
        overviews:bar-chart($params, $data))
    )
};



declare function app:obras-por-autor(){
    (<h2>Sinopsis</h2>,
    (: number of works per author :)
    let $map := data:get-work-numbers-by-author()
    let $values := app:get-map-values($map)
    let $data := map {
        "x" := $values
    }
    let $params := map {
        "title" := "Obras por autor",
        "containerId" := "ChartObras_4",
        "xaxis-title" := "número de obras",
        "yaxis-title" := "número de autores",
        "legend-name" := "autores"
    }
    return
    (<div id="ChartObras_4" style="width:900px;height:600px;margin: 0 auto;"></div>,
        overviews:histogram($params, $data)))
};


declare function app:obras-por-nacionalidad-de-autor(){
    (<h2>Sinopsis</h2>,
    (: number of works by author nationality :)
    let $map := data:get-work-numbers-by-nationality()
    let $keys := app:get-map-keys($map)
    let $values := app:get-map-values($map)
    let $data := map {
        "x" := $keys,
        "y" := $values
    }
    let $params := map {
        "title" := "Obras por nacionalidad / origen de autor",
        "containerId" := "ChartObras_1",
        "xaxis-title" := "nacionalidad / origen de autor",
        "yaxis-title" := "número de obras"
    }
    return
    (<div id="ChartObras_1" style="width:700px;height:600px;margin: 0 auto;"></div>,
        overviews:bar-chart($params, $data)))
};


declare function app:obras-por-pais-de-primera-edicion(){
    (<h2>Sinopsis</h2>,
    (: number of works by publication place of first edition :)
    let $map := data:get-work-numbers-by-pubPlace-first()
    let $keys := app:get-map-keys($map)
    let $values := app:get-map-values($map)
    let $data := map {
        "x" := $keys,
        "y" := $values
    }
    let $params := map {
        "title" := "Obras por país de primera edición",
        "containerId" := "ChartObras_2",
        "xaxis-title" := "país del lugar de publicación",
        "yaxis-title" := "número de obras"
    }
    return
    (<div id="ChartObras_2" style="width:700px;height:600px;margin: 0 auto;"></div>,
        overviews:bar-chart($params, $data)))
};


declare function app:obras-por-decada(){
    (<h2>Sinopsis</h2>,
    (: number of works per decade (by first edition):)
    let $first-ed-decs := for $work in $app:works
                           let $work-id := $work/@xml:id
                           let $dec := data:get-first-edition-decade($work-id)
                           return $dec
    let $num-editions := for $dec in $app:decades
                        return count($first-ed-decs[. = $dec])
    let $params := map {
        "title" := "Obras por década",
        "containerId" := "ChartObras_3",
        "xaxis-title" := "década",
        "yaxis-title" := "número de obras"
    }
    let $data := map {
        "x" := $app:decade-labels,
        "y" := $num-editions
    }
    return 
    (<div id="ChartObras_3" style="width:900px;height:600px;margin: 0 auto;"></div>,
        overviews:bar-chart($params, $data)))
};



declare function app:ediciones-por-decada(){
    (<h2>Sinopsis</h2>,
    (: number of editions per decade :)
    let $ed-decs := for $ed in $app:editions
                    let $date := ($ed//tei:date)[1]
                    let $dec := data:get-edition-decade($date)
                    return $dec
    let $num-editions := for $dec in $app:decades
                        return count($ed-decs[. = $dec])
    let $params := map {
        "title" := "Ediciones por década",
        "containerId" := "ChartEdiciones_1",
        "xaxis-title" := "década",
        "yaxis-title" := "número de ediciones"
    }
    let $data := map {
        "x" := $app:decade-labels,
        "y" := $num-editions
    }
    return 
    (<div id="ChartEdiciones_1" style="width:900px;height:600px;margin: 0 auto;"></div>,
        overviews:bar-chart($params, $data)))
};



declare function app:ediciones-por-obra(){
    (<h2>Sinopsis</h2>,
    (: number of editions per work :)
    let $num-editions := for $work in $app:works
                         let $work-id := $work/@xml:id
                         return count($app:editions//range:field-eq("work-key", $work-id))
    let $params := map {
        "title" := "Ediciones por obra",
        "containerId" := "ChartEdiciones_2",
        "xaxis-title" := "número de ediciones",
        "yaxis-title" := "número de obras",
        "legend-name" := "obras"
    }
    let $data := map {
        "x" := $num-editions
    }
    return 
    (<div id="ChartEdiciones_2" style="width:900px;height:600px;margin: 0 auto;"></div>,
        overviews:histogram($params, $data)))
};



(: ########## fuentes page ########## :)
declare function app:sources(){
    <section class="sources">
        <h2>Fuentes</h2>
        <ul>
            {
            for $bibl in $app:sources
            let $bibl-result := transform:transform($bibl, doc(concat($app:root, "/stylesheets/bibl.xsl")), ())
            order by $bibl
            return <li>{$bibl-result}</li>
            }
        </ul>
    </section>
};


(: ########## criterios page ########## :)
declare function app:criteria(){
    <section class="criteria">
        <h2>Criterios de selección</h2>
        <p>Por novela se entiende una obra literaria narrativa escrita predominantemente en 
        prosa y de una cierta extensión.</p>
        <p>Siguiendo los límites extensivas de Óscar Mata, se clasifica como novela un texto con
            35.000 o más palabras. Textos de una extensión entre 5.000 y 35.000 palabras se clasifican 
            como novelas cortas. Las novelas cortas también forman parte de esta bibliografía. 
            El número de palabras sólo se considera en los casos en que el texto está disponible 
            en <em>full text</em>. En los otros casos, se toma en cuenta si la obra está 
            denominada como <em>novela</em> en el título o subtítulo de las ediciones y si se considera 
            novela por estudiosos de literatura, por ejemplo en bibliografías de la novela
            argentina, cubana y mexicana. Si está accesible una edición de la obra, se verifica 
            si es una narración y si el texto está escrito en prosa.</p>
        <!-- narración? leyenda? cuento? relato? crónicas noveladas? -->
        <p>Sólo se incluyen obras que fueron publicadas entre 1830 y 1910 (cuando se tenga ese dato). 
            Es decir que por un lado se excluyen obras que quedaron inéditas hasta 1910 y por otro 
            lado se prescinde de acopiar informaciones sobre ediciones posteriores a este año, 
            aun cuando la obra haya sido publicada antes. Novelas inacabadas no son consideradas.</p>
        <p>La bibliografía sólo contiene novelas escritas en español, ninguna traducción al español ni
            tampoco novelas escritas en otros idiomas.</p>
        <p>Pueden haber sido publicadas en formato de libro (independientemente o como 
            parte de una colección de novelas, por ejemplo en antologías o en una edición de la 
            obra literaria conjunta de un autor); también pueden estar publicadas en revistas 
            literarias o periódicos.</p>
        <p>Finalmente, por <em>novela argentina</em>, <em>novela cubana</em> y <em>novela mexicana</em> se entienden 
            obras escritas por autores de nacionalidad o bien origen argentino, cubano o mexicano y obras 
            publicadas en los países Argentina, Cuba y México entre 1830 y 1910.</p>
        <!-- rund 250 Wörter pro Cuartilla? https://es.wikipedia.org/wiki/Cuartilla_(papel)
        dann wären 5000 Wörter 20 Seiten 
        - Kapitelstruktur
        - mind. 20 Seiten 
        - als novela bezeichnet (Titel)
        - als novela bezeichnet (extern) 
        - selbständig publiziert
        - muss: literarisch, fiktiv, narrativ
        -> mindestens 2 der optionalen sollen gegeben sein -->
    </section>
};


(: ########## criterios page ########## :)
declare function app:entities(){(
    <section class="entities">
        <h2>Entidades bibliográficas</h2>
        <p>En el sentido de los <em>Requerimientos funcionales para registros bibliográficos</em> (FRBR),
        se entienden por <span class="italic">entidades</span> "los 
        <span class="italic">objetos</span> clave que interesan a los usuarios de los datos 
        bibliográficos."<sup><a href="#N1">1</a></sup> En el caso de Bib-ACMé, estos son 
        primordialmente los autores de las novelas, 
        las obras literarias mismas y las ediciones que de ellas se han publicado.</p> 
        <p>Aplicando los 
        conceptos de FRBR, un <span class="bold">autor</span> es la persona responsable del
        contenido intelectual o artístico de una novela. La <span class="bold">obra</span>
        es el producto de creación intelectual o artística. En FRBR, una <span class="italic">obra</span>
        se considera como una "creación intelectual o artística diferenciada" mientras que 
        una <span class="italic">expresión</span> es la "realización intelectual o artística
        de una <span class="italic">obra</span>". Además, hay los 
        dos conceptos de <span class="italic">manifestación</span> ("la materialización física de una 
        <span class="italic">expresión</span> de una <span class="italic">obra</span>") y 
        <span class="italic">ejemplar</span> ("un <span class="italic">ejemplar</span> concreto 
        de una <span class="italic">manifestación</span>").<sup><a href="#N2">2</a></sup></p>
        <p>Lo que 
        en Bib-ACMé se denomina <span class="bold">edición</span> corresponde a una expresión
        en el sentido de que cada realización nueva (posiblemente cambiada) de una obra que se 
        publica en forma de libro, 
        como parte de un libro, en una revista o en un periódico, se registra como una edición
        separada. Pero el concepto de edición aquí utilizado corresponde también a una manifestación
        en cuanto que una subsiguiente tirada de la publicación de una obra (por ejemplo en el 
        año siguiente) se registra igualmente como edición.</p>
        <p>En esta bibliografía no se recogen las publicaciones en sí (es decir, los que equivalen 
        a libros físicos) sino las referencias bibliográficas
        que corresponden a las expresiones de las obras. Así, una novela puede ser publicada
        como parte de un libro o en dos libros. Por ejemplo:</p>
        
        <p class="sample">Gamboa, Federico. "El mechero de gas." 
        <span class="italic">Del natural.
        Esbozos contemporáneos.</span> Tipografía La Unión: Guatemala, 1889. p. 11-56.</p>
        
        <p class="sample">Ramos, José Antonio. <span class="italic">Humberto Fabra</span>.
        Gemler Hermanos: París, 1908. 2 tomos.</p>
        
        <p>Cuando no fue posible consultar una determinada publicación para determinar
        cuales son las obras contenidas en ella, se acoge la publicación como tal. Por ejemplo:</p>
        
        <p class="sample">Zarzamendi, M. M. <span class="italic">Cuatro leyendas.</span> Edición 
        de La República. Imprenta Políglota: México, 1883.</p>
        
        <p>Las informaciones se codifican en TEI, siguiendo los "P5: Guidelines 
        for Electronic Text Encoding and Interchange" y el capítulo 
        3.11 "Bibliographic Citations and References" en particular.<sup><a href="#N3">3</a></sup></p>
    </section>,
    <section class="entities">
        <ol>
            <li class="bibl" id="N1"><span class="italic">Requisitos Funcionales de los Registros 
            Bibliográficos: informe final.</span>
            Traducción española de Xavier Agenjo y María Luisa Martínez-Conde.
            Traducción  actualizada  por  María  Violeta  Bertolini y Elena Escolano.
            International  Federation  of  Library  Associations and  Institutions, 2016, p. 26.
                <a href="https://www.ifla.org/files/assets/cataloguing/frbr/frbr-es-with-addenda_2016.pdf">&lt;https://www.ifla.org/files/assets/cataloguing/frbr/frbr-es-with-addenda_2016.pdf&gt;</a>
            </li>
            <li class="bibl" id="N2">Ibid.</li>
            <li class="bibl" id="N3"><span class="italic">P5: Guidelines for Electronic Text 
            Encoding and Interchange.</span> 
            Text Encoding Initiative Consortium, 2016. <a href="http://www.tei-c.org/release/doc/tei-p5-doc/en/Guidelines.pdf">&lt;http://www.tei-c.org/release/doc/tei-p5-doc/en/Guidelines.pdf&gt;</a></li>
        </ol>
    </section>
)};


(: ########## data page ########## :)
declare function app:data(){
    <section class="data">
        <h2>Datos básicos</h2>
        <table>
            <tr>
                <td>Autores:</td>
                <td><a href="{$app:home}/datos/autores" target="blank">autores.xml</a></td>
            </tr>
            <tr>
                <td>Obras:</td>
                <td><a href="{$app:home}/datos/obras" target="blank">obras.xml</a></td>
            </tr>
            <tr>
                <td>Ediciones:</td>
                <td><a href="{$app:home}/datos/ediciones" target="blank">ediciones.xml</a></td>
            </tr>
            <tr>
                <td>Fuentes:</td>
                <td><a href="{$app:home}/datos/fuentes" target="blank">fuentes.xml</a></td>
            </tr>
        </table>
    </section>
};



declare function app:get-map-keys($map as map()){
    for $key in map:keys($map)
    order by map:get($map, $key) descending
    return $key
};

declare function app:get-map-values($map as map()){
    for $key in map:keys($map)
    let $val := map:get($map, $key)
    order by $val descending
    return $val
};



