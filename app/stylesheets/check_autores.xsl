<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <!-- localhost:8080/rest/apps/bibacme/data/authors.xml?_xsl=/db/apps/bibacme/stylesheets/check.xsl -->
    <xsl:template match="/">
        <div>
            <h2>Autores sin obras</h2>
            <ul>
                <xsl:for-each select="doc('xmldb:exist:///db/apps/bibacme/data/authors.xml')//tei:person">
                    <xsl:variable name="author-id" select="@xml:id"/>
                    <xsl:choose>
                        <xsl:when test="doc('xmldb:exist:///db/apps/bibacme/data/works.xml')//tei:bibl[tei:author/@key=$author-id]"/>
                        <xsl:otherwise>
                            <li>
                                <xsl:value-of select="$author-id"/>
                            </li>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>
</xsl:stylesheet>