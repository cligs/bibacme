<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- (Geburts- und) Todesdaten der Autoren aus dem Korpus abfragen, um zu sehen, ob deshalb noch Text im Copyright sind -->
    
    <xsl:variable name="corpus" select="collection('/home/ulrike/Git/hennyu/novelashispanoamericanas/corpus/master')//TEI"/>
    <xsl:variable name="authors" select="doc('/home/ulrike/Git/bibacme/app/data/authors.xml')//person"/>
    
    <!--<xsl:template match="/">
        <authors>
            <xsl:for-each-group select="$corpus//author" group-by="name[@type='short']">
                <xsl:sort select="current-grouping-key()"/>
                <xsl:variable name="author-id" select="idno[@type='bibacme']"/>
                <xsl:variable name="year-of-death" select="$authors[@xml:id = $author-id]//death/date/@when/substring(.,1,4)"/>
                <xsl:variable name="year-of-birth" select="$authors[@xml:id = $author-id]//birth/date/@when/substring(.,1,4)"/>
                <author birth="{$year-of-birth}" death="{$year-of-death}"><xsl:value-of select="current-grouping-key()"/></author>
            </xsl:for-each-group>
        </authors>
    </xsl:template>-->
    
    <!-- Welche Ausgaben unterliegen noch dem Leistungsschutzrecht? (25 Jahre ab Veröffentlichung)
    Bei welchen ist das Erscheinungsjahr der zugrundeliegenden Druckausgabe unbekannt? -->
    <!--<xsl:template match="/">
        <editions>
            <xsl:for-each select="$corpus">
                <!-\-<xsl:if test=".//bibl[@type='print-source']/date/@when/number(.) > 1995">
                    <idno><xsl:value-of select=".//idno[@type='cligs']"/></idno>
                </xsl:if>-\->
                <xsl:if test=".//bibl[@type='print-source'][not(date)]">
                    <idno><xsl:value-of select=".//idno[@type='cligs']"/></idno>
                    <xsl:copy-of select=".//bibl[@type='digital-source']"></xsl:copy-of>
                    <xsl:copy-of select=".//bibl[@type='print-source']"></xsl:copy-of>
                </xsl:if>
            </xsl:for-each>
        </editions>
    </xsl:template>-->
    
    <!-- alle Romane, die aus "La novela corta" bezogen wurden, auflisten -->
    <xsl:template match="/">
        <editions>
            <xsl:for-each select="$corpus">
                <xsl:if test=".//term[@type='text.source.institution'][normalize-space(.)='La novela corta: una biblioteca virtual']">
                    <idno><xsl:value-of select=".//idno[@type='cligs']"/></idno>
                </xsl:if>
            </xsl:for-each>
        </editions>
    </xsl:template>
    
</xsl:stylesheet>