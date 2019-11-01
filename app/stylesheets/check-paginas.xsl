<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:template match="/">
        <works>
        <xsl:for-each select=".//listBibl/bibl">
            <xsl:variable name="work-id" select="@xml:id"/>
            <xsl:choose>
                <xsl:when test="doc('../data/editions.xml')//biblStruct[@corresp=$work-id][//extent/@n or //biblScope/@n]"></xsl:when>
                <xsl:otherwise>
                    <id><xsl:value-of select="@xml:id"/></id>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        </works>
    </xsl:template>
    
</xsl:stylesheet>