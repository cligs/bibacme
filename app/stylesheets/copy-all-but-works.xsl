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
    
    <xsl:template match="note[@type='subgenre_lithist']">
        <term xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="@* | node() | comment()"/>
        </term>
    </xsl:template>
    
    <!--<xsl:template match="bibl[@type='source']">
        <note xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="node() | @* | comment() | processing-instruction()"/>
        </note>
    </xsl:template>-->
    
    <!--<xsl:template match="bibl">
        <xsl:copy>
            <xsl:apply-templates select="@* | author | title | term | comment()"/>
            <xsl:apply-templates select="note[not(@type='source')]"/>
            <xsl:apply-templates select="idno"/>
            <xsl:apply-templates select="ref"/>
            <xsl:apply-templates select="country"/>
            <xsl:apply-templates select="note[@type='source']"/>
        </xsl:copy>
    </xsl:template>-->
    
</xsl:stylesheet>