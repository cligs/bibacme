<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:output indent="yes"/>
    
    <xsl:variable name="authors-to-sort-out" select="doc('author-check.xml')//li/text()"/>
    
    <!--<xsl:template match="/">
        <listPerson xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:for-each select=".//person">
            <xsl:if test="@xml:id = $authors-to-sort-out">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
        </listPerson>
    </xsl:template>-->
    
    
    
    <xsl:template match="node() | @* | comment() | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="node() | @* | comment() | processing-instruction()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="person">
        <xsl:choose>
            <xsl:when test="@xml:id = $authors-to-sort-out">
                
            </xsl:when>
            <xsl:otherwise>
                <person xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates select="@* | child::* | comment()"/>
                </person>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- localhost:8080/rest/apps/bibacme/data/authors.xml?_xsl=/db/apps/bibacme/stylesheets/check.xsl -->
    <!--<xsl:template match="/">
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
    </xsl:template>-->
    
    <!--<xsl:template match="/">
        <div>
            <h2>Autores sin obras</h2>
            <ul>
                <xsl:for-each select="doc('../data/authors.xml')//tei:person">
                    <xsl:variable name="author-id" select="@xml:id"/>
                    <xsl:choose>
                        <xsl:when test="doc('../data/works.xml')//tei:bibl[tei:author/@key=$author-id]"/>
                        <xsl:otherwise>
                            <li>
                                <xsl:value-of select="$author-id"/>
                            </li>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>-->
    
    
    
</xsl:stylesheet>