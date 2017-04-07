xquery version "3.0";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

import module namespace data="http://localhost/data" at "modules/data.xqm";

if ($exist:path eq "/") then
    (: forward root path to index.xq :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq"/>
    </dispatch>
else if ($exist:path eq "/autores") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="authors"/>
        </forward>
    </dispatch>
else if (matches($exist:path, "/autor/A[0-9]+$")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="author"/>
            <add-parameter name="id" value="{$exist:resource}"/>
        </forward>
    </dispatch>
else if ($exist:path eq "/obras") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="works"/>
            <add-parameter name="page" value="{request:get-parameter('p', 1)}"/>
        </forward>
    </dispatch>
else if (matches($exist:path, "/obra/W[0-9]+$")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="work"/>
            <add-parameter name="id" value="{$exist:resource}"/>
        </forward>
    </dispatch>
else if ($exist:path eq "/ediciones") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="editions"/>
            <add-parameter name="page" value="{request:get-parameter('p', 1)}"/>
        </forward>
    </dispatch>
else if (matches($exist:path, "/edicion/E[0-9]+$")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="edition"/>
            <add-parameter name="id" value="{$exist:resource}"/>
        </forward>
    </dispatch>
(: ########## SINOPSIS ########## :)
else if ($exist:path eq "/sinopsis/autores-por-nacionalidad") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="autores-por-nacionalidad"/>
        </forward>
    </dispatch>
else if ($exist:path eq "/sinopsis/autores-por-sexo") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="autores-por-sexo"/>
        </forward>
    </dispatch>
else if ($exist:path eq "/sinopsis/obras-por-autor") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="obras-por-autor"/>
        </forward>
    </dispatch>
else if ($exist:path eq "/sinopsis/obras-por-decada") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="obras-por-decada"/>
        </forward>
    </dispatch>
else if ($exist:path eq "/sinopsis/obras-por-nacionalidad-de-autor") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="obras-por-nacionalidad-de-autor"/>
        </forward>
    </dispatch>
else if ($exist:path eq "/sinopsis/obras-por-pais-de-primera-edicion") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="obras-por-pais-de-primera-edicion"/>
        </forward>
    </dispatch>
else if ($exist:path eq "/sinopsis/ediciones-por-decada") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="ediciones-por-decada"/>
        </forward>
    </dispatch>
(: ########## SOBRE ########## :)
else if ($exist:path eq "/sobre/fuentes") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="sources"/>
        </forward>
    </dispatch>
else if ($exist:path eq "/sobre/criterios-seleccion") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="criteria"/>
        </forward>
    </dispatch>
else if ($exist:path eq "/sobre/entidades-bibliograficas") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="entities"/>
        </forward>
    </dispatch>
else if ($exist:path eq "/sobre/datos") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index.xq">
            <add-parameter name="view" value="data"/>
        </forward>
    </dispatch>
(: ########## DATA ########## :)
else if ($exist:path eq "/datos/autores") then
    data:get-XML("authors.xml")
else if ($exist:path eq "/datos/obras") then
    data:get-XML("works.xml")
else if ($exist:path eq "/datos/ediciones") then
    data:get-XML("editions.xml")
else if ($exist:path eq "/datos/fuentes") then
    data:get-XML("sources.xml")
else if ($exist:path eq "/test") then  
    <output>
        {data:get-work-numbers-by-pubPlace-first()}
    </output>
else
    (: everything else is passed through :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>