<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:template match="/">
        
        <list>
            <xsl:for-each select="doc('works.xml')//bibl[@xml:id]">
                <xsl:variable name="id" select="@xml:id"/>
                <xsl:if test="not(doc('editions.xml')//biblStruct[@corresp = $id])">
                    <item><xsl:value-of select="$id"/></item>
                </xsl:if>
            </xsl:for-each>
        </list>
        
    </xsl:template>
    
    
</xsl:stylesheet>