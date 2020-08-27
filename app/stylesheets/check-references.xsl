<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">

    <!-- check if the bibliographic references used in authors.xml, works.xml, editions.xml are contained in the bibliography -->
    <xsl:variable name="bib" select="doc('/home/ulrike/Git/bibacme/app/data/sources.xml')"/>

    <xsl:template match="/">
        <div>
            <xsl:for-each-group select="doc('/home/ulrike/Git/bibacme/app/data/works.xml')//@target" group-by="."> <!-- @resp or @target -->
                <xsl:if test="not($bib//bibl[@xml:id = substring-after(current-grouping-key(), '#')])"> 
                    <resp><xsl:value-of select="."/></resp>
                </xsl:if>
            </xsl:for-each-group>
        </div>
    </xsl:template>

</xsl:stylesheet>
