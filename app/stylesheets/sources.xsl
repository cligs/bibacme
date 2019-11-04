<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Input file: works.xml bzw. works_old.xml -->
    
    <xsl:template match="/">
        <xsl:result-document href="bibacme-sources.csv" method="text" encoding="UTF-8">
            <xsl:text>author-name,work-title,earliest-publication-date,country,source,bibacme-work-id,cligs-idno,fictionality,narrativity,prose,>82p,">15,500w",own-structure,readership,realistic,note</xsl:text><xsl:text>
</xsl:text>
            <xsl:for-each select=".//tei:listBibl[@type='short-novels']/tei:bibl">
                <xsl:variable name="work-id" select="@xml:id"/>
                <xsl:variable name="source" select="tei:bibl[@type='source']/tei:ptr/substring-after(@target,'#')"/>
                <xsl:text>"</xsl:text><xsl:value-of select="tei:author"/>
                <xsl:text>","</xsl:text><xsl:value-of select="tei:title"/>
                <xsl:text>","</xsl:text><xsl:value-of select="min(doc('../data/leftovers/editions_old.xml')//tei:biblStruct[@corresp=$work-id]//tei:date/@when/number(.))"/>
                <xsl:text>","</xsl:text><xsl:value-of select="if ($source='Lichtblau') then 'Argentina' else if ($source = 'DLC') then 'Cuba' else if ($source='TorresRioseco') then 'México' else()"/>
                <xsl:text>","</xsl:text><xsl:value-of select="$source"/>
                <xsl:text>","-</xsl:text>
                <xsl:text>","-</xsl:text>
                <xsl:text>","fictional</xsl:text>
                <xsl:text>","narrative</xsl:text> 
                <xsl:text>","prose</xsl:text>
                <xsl:text>","</xsl:text><xsl:value-of select="if (tei:idno[@type='cligs']) then 'n.a.' else 'no'"/>
                <xsl:text>","</xsl:text><xsl:value-of select="if (tei:idno[@type='cligs']) then 'no' else 'n.a.'"/>
                <xsl:text>","own structure</xsl:text>
                <xsl:text>","adult</xsl:text>
                <xsl:text>","realistic</xsl:text>
                <xsl:text>",""</xsl:text><xsl:text>
</xsl:text>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>