<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:title>Esquema para el archivo "authors.xml" en Bib-ACMé</sch:title>
    <sch:p>Autora: Ulrike Henny-Krahmer</sch:p>
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    
    <sch:pattern>
        <sch:rule context="tei:listPerson/tei:person">
            <sch:let name="author-id" value="@xml:id"/>
            <sch:assert test="matches($author-id,'^A\d+$')">The id of an author should have the form "A + number"</sch:assert>
            <sch:assert test="doc('../data/works.xml')//tei:bibl[tei:author/@key = $author-id]">There is no corresponding author-id in works.xml</sch:assert>
        </sch:rule>
        <sch:rule context="tei:nationality">
            <sch:assert test=". = doc('../data/nationalities.xml')//tei:term[@type='general']">The nationality is missing in nationalities.xml.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:country">
            <sch:assert test=". = ('Argentina', 'Cuba', 'México', 'desconocido')">The country should be one of "Argentina", "Cuba", "México", "desconocido".</sch:assert>
        </sch:rule>
        <sch:rule context="@xml:id">
            <sch:let name="author-id" value="."/>
            <sch:report test="preceding::tei:person[@xml:id = $author-id]">This author id has already been defined.</sch:report>
        </sch:rule>
        <sch:rule context="@resp">
            <sch:let name="source-id" value="substring-after(.,'#')"/>
            <sch:assert test="doc('../data/sources.xml')//tei:bibl[@xml:id = $source-id]">There is no corresponding bibliographic source for "<sch:value-of select="$source-id"/>" in sources.xml.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>