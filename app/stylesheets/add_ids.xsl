<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:template match="node()|@*|comment()|processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*|comment()|processing-instruction()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="listBibl/biblStruct">
        <xsl:variable name="position" select="count(preceding-sibling::biblStruct) + 1"/>
        <xsl:copy>
            <xsl:attribute name="corresp" select="@corresp"/>
            <xsl:attribute name="xml:id">E<xsl:value-of select="$position"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>