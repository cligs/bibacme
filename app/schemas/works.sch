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
        <sch:rule context="tei:note[@type]">
            <sch:assert test="@type = ('source', 'subgenre.litHist')">"<sch:value-of select="@type"/>" is not supported as a note type.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:term">
            <sch:let name="term-types" value="('subgenre.title.explicit','subgenre.title.explicit.norm','subgenre.title.implicit',
                'subgenre.litHist','subgenre.litHist.interp','subgenre.summary.signal.explicit','subgenre.summary.signal.implicit',
                'subgenre.summary.theme.explicit','subgenre.summary.theme.implicit','subgenre.summary.theme.litHist',
                'subgenre.summary.identity.explicit','subgenre.summary.identity.implicit','subgenre.summary.identity.litHist',
                'subgenre.summary.current.explicit','subgenre.summary.current.implicit','subgenre.summary.current.litHist',
                'subgenre.summary.mode.attitude.explicit','subgenre.summary.mode.attitude.implicit','subgenre.summary.mode.attitude.litHist',
                'subgenre.summary.mode.intention.explicit','subgenre.summary.mode.intention.implicit','subgenre.summary.mode.intention.litHist',
                'subgenre.summary.mode.reality.explicit','subgenre.summary.mode.reality.implicit','subgenre.summary.mode.reality.litHist',
                'subgenre.summary.mode.medium.explicit','subgenre.summary.mode.medium.implicit','subgenre.summary.mode.medium.litHist',
                'subgenre.summary.mode.representation.explicit','subgenre.summary.mode.representation.implicit','subgenre.summary.mode.representation.litHist',
                'subgenre.paratext.interp')"/>
            <sch:assert test="@type = $term-types">"<sch:value-of select="@type"/>" is not supported as a term type.</sch:assert>
        </sch:rule>
        <sch:rule context="@xml:id">
            <sch:let name="work-id" value="."/>
            <sch:report test="preceding::tei:bibl[@xml:id = $work-id]">This work id has already been defined.</sch:report>
        </sch:rule>
        <sch:rule context="@resp[. != '#uhk'] | tei:ptr/@target">
            <sch:let name="source-id" value="substring-after(.,'#')"/>
            <sch:assert test="doc('../data/sources.xml')//tei:bibl[@xml:id = $source-id]">There is no corresponding bibliographic source for "<sch:value-of select="$source-id"/>" in sources.xml.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>