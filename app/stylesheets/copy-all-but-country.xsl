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
    
    <xsl:template match="listBibl/bibl">
        <bibl xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="@* | child::* | comment()"/>
            <xsl:variable name="source" select="bibl[@type='source']/ptr/@target"/>
            <country><xsl:choose>
                <xsl:when test="$source = '#Torres-Rioseco'">México</xsl:when>
                <xsl:when test="$source = '#Lichtblau'">Argentina</xsl:when>
                <xsl:when test="$source = '#DLC'">Cuba</xsl:when>
                <xsl:when test="$source = '#elem.mx'">México</xsl:when>
            </xsl:choose></country>
        </bibl>
    </xsl:template>
    
</xsl:stylesheet>