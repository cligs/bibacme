<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output method="xhtml" encoding="UTF-8"/>
    <xsl:template match="biblStruct">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="author">
        <span class="author">
            <xsl:apply-templates/>
            <xsl:if test="not(ends-with(.,'.'))">
                <xsl:text>. </xsl:text>    
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="title[@level = 'm' or @level = 'j'][@type='main']">
        <span style="font-style:italic;">
            <xsl:apply-templates/>
            <xsl:if test="following-sibling::title[@type='sub']">
                <xsl:text>. </xsl:text>
                <xsl:value-of select="following-sibling::title[@type='sub']"/>
            </xsl:if>
            <xsl:text>. </xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="title[@level = 'a'][@type='main']">
        <span>
            <xsl:text>"</xsl:text>
            <xsl:apply-templates/>
            <xsl:if test="following-sibling::title[@type='sub']">
                <xsl:text>. </xsl:text>
                <xsl:value-of select="following-sibling::title[@type='sub']"/>
            </xsl:if>
            <xsl:text>." </xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="note | title[@type='sub']"/>
    <xsl:template match="publisher">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::pubPlace">
            <xsl:text>: </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="pubPlace">
        <xsl:apply-templates/>
        <xsl:choose>
            <xsl:when test="following-sibling::date">
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="parent::imprint/following-sibling::extent">
                <xsl:text>. </xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="date">
        <xsl:apply-templates/>
        <xsl:text>. </xsl:text>
    </xsl:template>
    <xsl:template match="extent">
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="biblScope">
        <xsl:apply-templates/>
        <xsl:text>. </xsl:text>
    </xsl:template>
    <xsl:template match="edition">
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::imprint/publisher|             following-sibling::imprint/pubPlace|             following-sibling::imprint/date">
            <xsl:text>. </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="ref">
        &lt;<a href="{.}" target="blank">
            <xsl:apply-templates/>
        </a>&gt;
    </xsl:template>
</xsl:stylesheet>