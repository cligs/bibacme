<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <sch:title>Esquema para el archivo "works.xml" en Bib-ACMé</sch:title>
    <sch:p>Autora: Ulrike Henny-Krahmer</sch:p>
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    
    <sch:pattern>
        <sch:rule context="tei:listBibl/tei:bibl">
            <sch:let name="work-id" value="@xml:id"/>
            <sch:assert test="matches($work-id,'^W\d+$')">The id of a work should have the form "W + number"</sch:assert>
            <sch:assert test="doc('../data/editions.xml')//tei:biblStruct[@corresp = concat('works.xml#',$work-id)]">There is no corresponding work-id in editions.xml</sch:assert>
        </sch:rule>
        <sch:rule context="tei:author">
            <sch:let name="author-key" value="@key"/>
            <sch:let name="author-surname" value="if (contains(.,',')) then substring-before(.,',') else ."/>
            <sch:assert test="doc('../data/authors.xml')//tei:person[@xml:id = $author-key]">There is no corresponding author-id in authors.xml</sch:assert>
            <sch:assert test="doc('../data/authors.xml')//tei:person[@xml:id = $author-key][tei:persName[tei:surname=$author-surname or tei:name=$author-surname]]">The author's surname does not match the name in authors.xml</sch:assert>
        </sch:rule>
        <sch:rule context="tei:idno[@type='cligs']">
            <sch:assert test="matches(.,'nh\d{4}')">A CLiGS idno should have the form "nh + 4 numbers".</sch:assert>
        </sch:rule>
        <sch:rule context="tei:country">
            <sch:assert test=". = ('Argentina', 'Cuba', 'México')">The country should be one of "Argentina", "Cuba", "México".</sch:assert>
        </sch:rule>
        <sch:rule context="tei:note[@type='source']">
            <sch:assert test="tei:ptr/substring-after(@target,'#') = doc('../data/sources.xml')//tei:listBibl/tei:bibl/@xml:id">This source is not mentioned in sources.xml.</sch:assert>
        </sch:rule>
        <sch:rule context="@xml:id">
            <sch:let name="work-id" value="."/>
            <sch:report test="preceding::tei:bibl[@xml:id = $work-id]">This work id has already been defined.</sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>