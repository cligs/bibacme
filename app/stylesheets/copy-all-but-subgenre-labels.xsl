<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:cligs="https://cligs.hypotheses.org/ns/cligs"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8"/>
    
    <xsl:template match="node() | @* | comment() | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="node() | @* | comment() | processing-instruction()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Werte aus works.xml in die Korpusdateien übernehmen
    Aufruf: java -jar /home/ulrike/Programme/saxon/saxon9he.jar 
    /home/ulrike/Git/bibacme/app/data/works.xml 
    /home/ulrike/Git/bibacme/app/stylesheets/copy-all-but-subgenre-labels.xsl 
    -->
    <xsl:template match="/">
        <xsl:variable name="ausnahmen" select="('nh0001', 'nh0002', 'nh0003', 'nh0004', 'nh0005', 'nh0006', 'nh0007', 'nh0008', 'nh0009', 'nh0010')"/>
        <xsl:for-each select="collection('/home/ulrike/Git/hennyu/novelashispanoamericanas/corpus/master')//TEI[not(exists(index-of($ausnahmen, .//idno[@type='cligs'])))]">
            <xsl:variable name="idno" select=".//idno[@type='cligs']"/>
            <xsl:result-document href="{concat('/home/ulrike/Git/hennyu/novelashispanoamericanas/corpus/master_new/',$idno,'.xml')}">
                <xsl:apply-templates select=". | preceding-sibling::processing-instruction()"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="term[@type='text.genre.subgenre.title.interp' 
        or @type='text.genre.subgenre.paratext.interp' 
        or @type='text.genre.subgenre.historical.interp'
        or @type='text.genre.subgenre.litHist'
        or @type='text.genre.subgenre.litHist.interp'] |
        term[@type='text.genre.subgenre.summary'][following-sibling::term[@type='text.genre.subgenre.summary']]"/>
    
    <xsl:template match="term[@type='text.genre.subgenre.opening.interp']">
        <term xmlns="http://www.tei-c.org/ns/1.0" type="text.genre.subgenre.opening.implicit">
            <xsl:copy-of select="@resp | node()"/>
        </term>
    </xsl:template>
    
    <xsl:template match="term[@type='text.genre.subgenre.summary'][not(following-sibling::term[@type='text.genre.subgenre.summary'])]">
        <xsl:variable name="idno" select="ancestor::TEI//idno[@type='cligs']"/>
        <xsl:for-each select="doc('/home/ulrike/Git/bibacme/app/data/works.xml')//bibl[idno[@type='cligs']=$idno]/term[contains(@type,'subgenre.litHist') or contains(@type,'subgenre.summary')]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="{concat('text.genre.',@type)}">
                <xsl:copy-of select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:for-each>
    </xsl:template>
    
    
    
    <!-- title.interp löschen -->
    <!--<xsl:template match="term[@type='subgenre.title.interp']"/>-->
    
    <!-- @cligs:importance aufräumen -->
    <!--<xsl:template match="bibl[count(term[contains(@type,'current')]) gt 1 and not(term[contains(@type,'current')][@cligs:importance])]">
        <bibl xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="@* | author | title | term[not(contains(@type,'subgenre.summary'))] | note[@type='subgenre.litHist'] | term[contains(@type,'subgenre.summary.signal') or contains(@type,'subgenre.summary.theme')]"/>
            <xsl:choose>
                <xsl:when test="count(distinct-values(term[contains(@type,'current')]/normalize-space(.))) = 1">
                    <xsl:for-each select="term[contains(@type,'current')]">
                        <xsl:choose>
                            <xsl:when test="position() = 1">
                                <term xmlns="http://www.tei-c.org/ns/1.0">
                                    <xsl:copy-of select="@type | @resp"/>
                                    <xsl:attribute name="cligs:importance">2</xsl:attribute>
                                    <xsl:copy-of select="node()"/>
                                </term>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="term[contains(@type,'subgenre.summary.current')]"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="comment() | idno | country | note[not(@type='subgenre.litHist')] | ref | term[contains(@type,'subgenre.summary.identity') or contains(@type,'subgenre.summary.mode')]"/>
        </bibl>
    </xsl:template>-->
    
    <!--<xsl:template match="bibl[count(term[contains(@type,'theme')]) gt 1 and not(term[contains(@type,'theme')][@cligs:importance])]">
        <bibl xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="@* | author | title | term[not(contains(@type,'subgenre.summary'))] | note[@type='subgenre.litHist'] | term[contains(@type,'subgenre.summary.signal')]"/>
            <xsl:choose>
                <xsl:when test="count(distinct-values(term[contains(@type,'theme')]/normalize-space(.))) = 1">
                    <xsl:for-each select="term[contains(@type,'theme')]">
                        <xsl:choose>
                            <xsl:when test="position() = 1">
                                <term xmlns="http://www.tei-c.org/ns/1.0">
                                    <xsl:copy-of select="@type | @resp"/>
                                    <xsl:attribute name="cligs:importance">2</xsl:attribute>
                                    <xsl:copy-of select="node()"/>
                                </term>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="term[contains(@type,'subgenre.summary.theme')]"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="comment() | idno | country | note[not(@type='subgenre.litHist')] | ref | term[contains(@type,'subgenre.summary.current') or contains(@type,'subgenre.summary.identity') or contains(@type,'subgenre.summary.mode')]"/>
        </bibl>
    </xsl:template>-->
    
    
    <!--<xsl:template match="term[not(contains(@type,'summary.theme') or contains(@type,'summary.current'))][@cligs:importance]">
        <term xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@type | @resp | node()"/>
        </term>
    </xsl:template>-->
    
    <!--<xsl:template match="term[contains(@type,'summary.current') and @cligs:importance][preceding-sibling::term[contains(@type,'summary.current') and @cligs:importance]]">
        <term xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@type | @resp | node()"/>
        </term>
    </xsl:template>-->
    
    <!-- Reihenfolge anpassen -->
    <!--<xsl:template match="bibl">
        <bibl xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:apply-templates select="@* | author | title | term[not(contains(@type,'subgenre.summary'))] | note[@type='subgenre.litHist']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.signal.explicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.signal.implicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.theme.explicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.theme.implicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.theme.litHist']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.current.explicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.current.implicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.current.litHist']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.identity.explicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.identity.implicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.identity.litHist']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.intention.explicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.intention.implicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.intention.litHist']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.attitude.explicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.attitude.implicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.attitude.litHist']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.reality.explicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.reality.implicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.reality.litHist']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.medium.explicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.medium.implicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.medium.litHist']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.representation.explicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.representation.implicit']"/>
        <xsl:copy-of select="term[@type='subgenre.summary.mode.representation.litHist']"/>
        <xsl:apply-templates select="comment() | idno | country | note[not(@type='subgenre.litHist')] | ref"/>
        </bibl>
    </xsl:template>-->
    
    <!--<xsl:template match="term[@type='subgenre.summary']">
        <xsl:variable name="subtype" select="@subtype"/>
        <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.{$subtype}">
            <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
        </term>
    </xsl:template>-->
    
    <!--<xsl:template match="term[@type='subgenre.summary.signal']">
        <xsl:variable name="self" select="normalize-space(.)"/>
        <xsl:choose>
            <xsl:when test="preceding-sibling::term[@type='subgenre.title.explicit.norm'][normalize-space(.)=$self]">
                <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.signal.explicit">
                    <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
                </term>
            </xsl:when>
            <xsl:when test="preceding-sibling::term[@type='subgenre.title.implicit'][normalize-space(.)=$self]">
                <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.signal.implicit">
                    <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
                </term>
            </xsl:when>
            <xsl:otherwise>
                <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.signal.unclear">
                    <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
                </term>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    
    <!--<xsl:template match="term[.='-' or .='novela general']"/>-->
    
    
    <!-- Umstrukturierung der Summary-Kategorien -->
    <!--<xsl:template match="term[contains(@type,'summary.identity')]">
        <xsl:variable name="subgenre"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.explicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.theme.explicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.implicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.theme.implicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.litHist.interp'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.theme.litHist">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.explicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.identity.explicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.implicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.identity.implicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.litHist.interp'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.identity.litHist">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.explicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.current.explicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.implicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.current.implicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.litHist.interp'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.current.litHist">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.explicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.reality.explicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.implicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.reality.implicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.litHist.interp'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.reality.litHist">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.explicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.medium.explicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.implicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.medium.implicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.litHist.interp'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.medium.litHist">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.explicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.representation.explicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.implicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.representation.implicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.litHist.interp'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.representation.litHist">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.explicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.intention.explicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.implicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.intention.implicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.litHist.interp'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.intention.litHist">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.explicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.attitude.explicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.summary.signal.implicit'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.attitude.implicit">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
        <xsl:if test="preceding-sibling::term[@type='subgenre.litHist.interp'][normalize-space(.)=$subgenre]">
            <term xmlns="http://www.tei-c.org/ns/1.0" type="subgenre.summary.mode.attitude.litHist">
                <xsl:apply-templates select="@resp | @cligs:importance | node()"/>
            </term>
        </xsl:if>
    </xsl:template>-->
    
    
</xsl:stylesheet>