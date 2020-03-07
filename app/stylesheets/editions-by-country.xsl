<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:variable name="works" select="doc('/home/ulrike/Git/bibacme/app/data/works.xml')"/>
    <xsl:variable name="editions" select="doc('/home/ulrike/Git/bibacme/app/data/editions.xml')"/>
    
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        <xsl:for-each-group select="$works//bibl" group-by="country">
            ############
            <xsl:value-of select="current-grouping-key()"/><xsl:text>
</xsl:text>
            total works: <xsl:value-of select="count(current-group())"/><xsl:text>
</xsl:text>
            <xsl:variable name="work-ids" select="current-group()/@xml:id"/>
            total editions: <xsl:value-of select="count($editions//biblStruct[substring-after(@corresp,'works.xml#') = $work-ids])"/><xsl:text>
</xsl:text>
            <xsl:for-each-group select="$editions//biblStruct[substring-after(@corresp,'works.xml#') = $work-ids]" group-by=".//pubPlace/substring-after(@corresp,'countries.xml#')">
                <xsl:value-of select="current-grouping-key()"/>: <xsl:value-of select="count(current-group())"/><xsl:text>
</xsl:text>
            </xsl:for-each-group>
        </xsl:for-each-group>
    </xsl:template>
    
</xsl:stylesheet>