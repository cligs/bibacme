<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:title>Esquema para el archivo "countries.xml" en Bib-ACMé</sch:title>
    <sch:p>Autora: Ulrike Henny-Krahmer</sch:p>
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    
    <sch:pattern>
        <sch:rule context="tei:listPlace/tei:place">
            <sch:assert test="@xml:id = doc('../data/editions.xml')//tei:listBibl//tei:pubPlace/substring-after(@corresp,'countries.xml#')">This country is not mentioned in editions.xml.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>