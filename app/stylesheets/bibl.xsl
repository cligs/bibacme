<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xhtml" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="ref">
        <xsl:text>&lt;</xsl:text>
        <a href="{@target}" target="blank">
            <xsl:apply-templates/>
        </a>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>
    <xsl:template match="seg[@rend = 'italic']">
        <span style="font-style:italic;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
</xsl:stylesheet>