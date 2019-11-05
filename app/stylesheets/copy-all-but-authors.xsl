<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output indent="yes"/>
    
    <xsl:template match="node() | @* | comment() | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="node() | @* | comment() | processing-instruction()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="person[idno][sex][nationality]">
        <xsl:copy>
            <xsl:apply-templates select="@*  | persName | birth | death"/>
            <xsl:apply-templates select="sex"/>
            <xsl:apply-templates select="nationality"/>
            <xsl:apply-templates select="idno"/>
            <xsl:apply-templates select="note"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>