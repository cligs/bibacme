xquery version "3.0";

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=html5 media-type=text/html";

import module namespace app = "http://localhost/app" at "modules/app.xqm";

declare function local:select-nav($view as xs:string?, $nav-entry as xs:string+) as xs:string {
    if ($view = $nav-entry or concat($view, "s") = $nav-entry)
    then
        "sel"
    else
        "def"
};

let $view := request:get-parameter("view", ())
let $id := request:get-parameter("id", ())
let $page := request:get-parameter("p", 1)
let $author := request:get-parameter("autor", ())
let $decade := request:get-parameter("decada", ())
let $country := request:get-parameter("pais", ())
let $nationality := request:get-parameter("nacionalidad", ())
let $work := request:get-parameter("obra", ())
let $letter := request:get-parameter("letra", ())
let $order := request:get-parameter("orden", "alfabetico")
return
    <html>
        <head>
            <meta
                charset="utf-8"/>
            <meta
                name="viewport"
                content="width=device-width, initial-scale=1.0"/>
            <link
                rel="stylesheet"
                type="text/css"
                href="{$app:home}/resources/style.css"/>
            <script
                type="text/javascript"
                src="{$app:home}/resources/plotly-latest.min.js"/>
            <title>Bibliografía digital de novelas argentinas, mexicanas y cubanas (1830-1910)</title>
        </head>
        <body>
            <header>
                <h1
                    class="main"><a
                        href="{$app:home}/">Bib-ACMé</a></h1>
                <h1><a
                        href="{$app:home}/">Bibliografía digital de novelas argentinas, cubanas y mexicanas (1830-1910)</a></h1>
                <nav>
                    <ul>
                        <li>
                            <a
                                href="#"
                                class="{local:select-nav($view, ("sources", "criteria", "data"))}">Sobre Bib-ACMé</a>
                            <ul>
                                <li><a
                                        href="{$app:home}/sobre/fuentes"
                                        class="{local:select-nav($view, "sources")}">Fuentes</a></li>
                                <li><a
                                        href="{$app:home}/sobre/criterios-seleccion"
                                        class="{local:select-nav($view, "criteria")}">Criterios de selección</a></li>
                                <li><a
                                        href="{$app:home}/sobre/entidades-bibliograficas"
                                        class="{local:select-nav($view, "entities")}">Entidades bibliográficas</a></li>
                                <li><a
                                        href="{$app:home}/sobre/datos"
                                        class="{local:select-nav($view, "data")}">Datos básicos</a></li>
                            </ul>
                        </li>
                        <li><a
                                href="{$app:home}/autores"
                                class="{local:select-nav($view, "authors")}">Autores</a></li>
                        <li><a
                                href="{$app:home}/obras"
                                class="{local:select-nav($view, "works")}">Obras</a></li>
                        <li><a
                                href="{$app:home}/ediciones"
                                class="{local:select-nav($view, "editions")}">Ediciones</a></li>
                        <li><a
                                href="#"
                                class="{
                                        local:select-nav($view, ("autores-por-nacionalidad", "autores-por-sexo",
                                        "obras-por-decada", "obras-por-nacionalidad-de-autor", "obras-por-pais-de-primera-edicion",
                                        "ediciones-por-decada"))
                                    }">Sinopsis</a>
                            <ul>
                                <li><a
                                        href="{$app:home}/sinopsis/autores-por-nacionalidad"
                                        class="{local:select-nav($view, "autores-por-nacionalidad")}">Autores por nacionalidad</a></li>
                                <li><a
                                        href="{$app:home}/sinopsis/autores-por-sexo"
                                        class="{local:select-nav($view, "autores-por-sexo")}">Autores por sexo</a></li>
                                <li><a
                                        href="{$app:home}/sinopsis/obras-por-ano"
                                        class="{local:select-nav($view, "obras-por-ano")}">Obras por año</a></li>
                                <li><a
                                        href="{$app:home}/sinopsis/obras-por-autor"
                                        class="{local:select-nav($view, "obras-por-autor")}">Obras por autor</a></li>
                                <li><a
                                        href="{$app:home}/sinopsis/obras-por-decada"
                                        class="{local:select-nav($view, "obras-por-decada")}">Obras por década</a></li>
                                <li><a
                                        href="{$app:home}/sinopsis/obras-por-nacionalidad-de-autor"
                                        class="{local:select-nav($view, "obras-por-nacionalidad-de-autor")}">Obras por nacionalidad de autor</a></li>
                                <li><a
                                        href="{$app:home}/sinopsis/obras-por-pais-de-primera-edicion"
                                        class="{local:select-nav($view, "obras-por-pais-de-primera-edicion")}">Obras por país de primera edición</a></li>
                                <li><a
                                        href="{$app:home}/sinopsis/ediciones-por-decada"
                                        class="{local:select-nav($view, "ediciones-por-decada")}">Ediciones por década</a></li>
                                <li><a
                                        href="{$app:home}/sinopsis/ediciones-por-obra"
                                        class="{local:select-nav($view, "ediciones-por-obra")}">Ediciones por obra</a></li>
                            </ul>
                        </li>
                    </ul>
                </nav>
            </header>
            <main>
                {
                    if ($view = "sources")
                    then
                        app:sources()
                    else
                        if ($view = "criteria")
                        then
                            app:criteria()
                        else
                            if ($view = "entities")
                            then
                                app:entities()
                            else
                                if ($view = "data")
                                then
                                    app:data()
                                else
                                    if ($view = "authors")
                                    then
                                        app:authors($page, $nationality, $decade, $country, $letter)
                                    else
                                        if ($view = "author" and $id)
                                        then
                                            app:author($id)
                                        else
                                            if ($view = "works")
                                            then
                                                app:works($page, $author, $decade, $country, $letter)
                                            else
                                                if ($view = "work" and $id)
                                                then
                                                    app:work($id)
                                                else
                                                    if ($view = "editions")
                                                    then
                                                        app:editions($page, $author, $decade, $country, $work, $order, $letter)
                                                    else
                                                        if ($view = "edition" and $id)
                                                        then
                                                            app:edition($id)
                                                        else
                                                            if ($view = "autores-por-nacionalidad")
                                                            then
                                                                app:autores-por-nacionalidad()
                                                            else
                                                                if ($view = "autores-por-sexo")
                                                                then
                                                                    app:autores-por-sexo()
                                                                else
                                                                    if ($view = "obras-por-ano")
                                                                    then
                                                                        app:obras-por-ano()
                                                                    else
                                                                        if ($view = "obras-por-autor")
                                                                        then
                                                                            app:obras-por-autor()
                                                                        else
                                                                            if ($view = "obras-por-decada")
                                                                            then
                                                                                app:obras-por-decada()
                                                                            else
                                                                                if ($view = "obras-por-nacionalidad-de-autor")
                                                                                then
                                                                                    app:obras-por-nacionalidad-de-autor()
                                                                                else
                                                                                    if ($view = "obras-por-pais-de-primera-edicion")
                                                                                    then
                                                                                        app:obras-por-pais-de-primera-edicion()
                                                                                    else
                                                                                        if ($view = "ediciones-por-decada")
                                                                                        then
                                                                                            app:ediciones-por-decada()
                                                                                        else
                                                                                            if ($view = "ediciones-por-obra")
                                                                                            then
                                                                                                app:ediciones-por-obra()
                                                                                            else
                                                                                                <section
                                                                                                    class="index">
                                                                                                    <!-- erklären: warum die drei Länder -->
                                                                                                    <p>Bib-ACMé reúne datos sobre novelas argentinas, cubanas y mexicanas que se publicaron
                                                                                                        entre 1830 y 1910.</p>
                                                                                                    <p>El objetivo de la bibliografía es sobre todo hacer posible una visión general
                                                                                                        de las novelas que se publicaron en este período y ámbito geográfico y cultural.</p>
                                                                                                    <!-- erklären: was sind die Räume, um die es geht -->
                                                                                                    <p>Bib-ACMé se basa en bibliografías existentes (sobre todo en los trabajos de Myron Lichtblau,
                                                                                                        Carlos Trelles y Juan Iguiniz), llevando los registros impresos a un entorno digital para facilitar
                                                                                                        análisis cuantitativos sobre autores, obras y ediciones.</p>
                                                                                                    <p>A modo de ejemplo, algunos análisis se muestran en este sitio
                                                                                                        en la sección "Sinopsis".</p>
                                                                                                    <p>Más allá de la dimensión bibliográfica en sí, el objetivo de este proyecto es el de
                                                                                                        hacer posible que un corpus de novelas determinado se ponga en relación con lo que se considera
                                                                                                        el acercamiento a la <em>población estadística</em>, o sea el conjunto de novelas de referencia del
                                                                                                        período histórico y espacio geográfico-cultural examinado.</p>
                                                                                                    <p>El trabajo se está realizando en el contexto del proyecto <a
                                                                                                            href="http://cligs.hypotheses.org"
                                                                                                            target="blank">"Estilística computacional
                                                                                                            del género literario" (CLiGS)</a>, financiado por
                                                                                                        el <a
                                                                                                            href="https://www.bmbf.de/"
                                                                                                            target="blank">Ministerio de Educación e Investigación
                                                                                                            alemán (BMBF)</a>.</p>
                                                                                                </section>
                }
            </main>
            <footer>
                <section>
                    <p>Ulrike Henny (ed). <em>Bib-ACMé. Bibliografía digital de novelas
                            argentinas, cubanas y mexicanas (1830-1910).</em> Würzburg, 2017.</p>
                    <p><strong>Contacto</strong>: ulrike.henny /at/ uni-wuerzburg.de</p>
                </section>
                <aside><a
                        href="https://cligs.hypotheses.org"
                        target="blank">
                        <img
                            src="{$app:home}/resources/cligs_logo.png"
                            alt="CLiGS"
                            title="CLiGS"
                            width="100px"/>
                    </a></aside>
            </footer>
        </body>
    </html>