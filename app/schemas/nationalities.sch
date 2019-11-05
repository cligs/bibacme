<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:title>Esquema para el archivo "nationalities.xml" en Bib-ACMé</sch:title>
    <sch:p>Autora: Ulrike Henny-Krahmer</sch:p>
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    
    <sch:pattern>
        <sch:rule context="tei:list/tei:item/tei:term[@type='general']">
            <sch:assert test=". = doc('../data/authors.xml')//tei:nationality">There is no such nationality in authors.xml.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>