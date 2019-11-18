<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:title>Esquema para el archivo "editions.xml" en Bib-ACMé</sch:title>
    <sch:p>Autora: Ulrike Henny-Krahmer</sch:p>
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    
    <sch:pattern>
        <sch:rule context="tei:listBibl/tei:biblStruct">
            <sch:let name="corresp-work" value="@corresp"/>
            <sch:let name="author-key" value=".//tei:author/@key"/>
            <sch:assert test="matches(@xml:id,'^E\d+$')">The id of an edition should have the form "E + number"</sch:assert>
            <sch:assert test="doc('../data/works.xml')//tei:bibl[@xml:id = substring-after($corresp-work,'works.xml#')]">There is no corresponding work-id in works.xml</sch:assert>
            <sch:assert test="doc('../data/works.xml')//tei:bibl[@xml:id = substring-after($corresp-work,'works.xml#')][tei:author/@key = $author-key]">The author key does not correspond to the author key in works.xml.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:listBibl//tei:pubPlace[.!='desconocido']">
            <sch:assert test="substring-after(@corresp,'countries.xml#') = doc('../data/countries.xml')//tei:listPlace/tei:place/@xml:id">This country key is missing in countries.xml.</sch:assert>
        </sch:rule>
        <sch:rule context="@xml:id">
            <sch:let name="edition-id" value="."/>
            <sch:report test="preceding::tei:biblStruct[@xml:id = $edition-id]">This edition id has already been defined.</sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>