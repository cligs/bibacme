<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:cligs="https://cligs.hypotheses.org/ns/cligs"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- input: works.xml -->
    
    <!-- gibt es bei den terms Doppelungen? (identischer Typ und identischer Wert) -->
    <!--<xsl:template match="/">
        <bibls>
            <xsl:for-each select="//term">
                <xsl:variable name="self" select="."/>
                <xsl:for-each select="preceding-sibling::term[@type=$self/@type]">
                    <xsl:if test="normalize-space($self) = normalize-space(current())">
                        <xsl:choose>
                            <xsl:when test="@resp">
                                <xsl:if test="@resp = $self/@resp">
                                    <bibl><xsl:value-of select="parent::bibl/@xml:id"/>; <xsl:value-of select="@type"/></bibl>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <bibl><xsl:value-of select="parent::bibl/@xml:id"/>; <xsl:value-of select="@type"/></bibl>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </bibls>
    </xsl:template>-->
    
    
    <!--<xsl:template match="/">
        <bibls>
            <xsl:for-each select="//bibl">
                <xsl:variable name="theme" select="term[contains(@type,'theme')]"/>
                <xsl:if test="count($theme) gt 1 and not($theme[@cligs:importance])">
                    <bibl><xsl:value-of select="@xml:id"/></bibl>
                </xsl:if>
                <xsl:variable name="current" select="term[contains(@type,'current')]"/>
                <xsl:if test="count($current) gt 1 and not($current[@cligs:importance])">
                    <bibl><xsl:value-of select="@xml:id"/></bibl>
                </xsl:if>
            </xsl:for-each>
        </bibls>
    </xsl:template>-->
    
    
    <xsl:template match="/">
        <!-- Wertelisten ausgeben -->
        <labels>
            <labels group="summary.implicit">
                <xsl:for-each-group select="//term[contains(@type,'summary') and contains(@type,'litHist')]" group-by="normalize-space(.)">
                    <xsl:sort/>
                    <label><xsl:value-of select="."/></label>
                </xsl:for-each-group>
            </labels>
        </labels>
    </xsl:template>
    
    <!--<xsl:template match="/">
        <!-\- Werte überprüfen: values of explicit.norm, implicit, interp that are not in signal -\->
        <entries>
            <xsl:for-each select="//bibl">
                <xsl:variable name="signals" select="term[contains(@type, 'signal')]/normalize-space(.)"/>
                <xsl:for-each select="term[@type='subgenre.title.interp']">
                    <xsl:if test="not(exists(index-of($signals, normalize-space(current()))))">
                        <entry><xsl:value-of select="parent::bibl/@xml:id"/></entry>
                    </xsl:if>    
                </xsl:for-each>
            </xsl:for-each>
        </entries>
    </xsl:template>-->
    
    <!--<xsl:template match="/">
        <!-\- Werte überprüfen: Werte in signal, die nicht in den Folgekategorien abgedeckt sind -\->
        <entries>
            <xsl:for-each select="//bibl">
                <xsl:variable name="summaries" select="term[contains(@type, 'summary') and not(contains(@type, 'signal'))]/normalize-space(.)"/>
                <xsl:for-each select="term[contains(@type,'signal')]">
                    <xsl:if test="not(exists(index-of($summaries, normalize-space(current()))))">
                        <entry><xsl:value-of select="parent::bibl/@xml:id"/></entry>
                    </xsl:if>    
                </xsl:for-each>
            </xsl:for-each>
        </entries>
    </xsl:template>-->
    
    <!--<xsl:template match="/">
        <!-\- Werte überprüfen: Werte in title.interp, die nicht in title.implicit oder explicit.norm abgedeckt sind -\->
        <entries>
            <xsl:for-each select="//bibl">
                <xsl:variable name="titles" select="term[@type = 'subgenre.title.implicit' or @type='subgenre.title.explicit.norm']/normalize-space(.)"/>
                <xsl:for-each select="term[@type='subgenre.title.interp']">
                    <xsl:if test="not(exists(index-of($titles, normalize-space(current()))))">
                        <entry><xsl:value-of select="parent::bibl/@xml:id"/></entry>
                    </xsl:if>    
                </xsl:for-each>
            </xsl:for-each>
        </entries>
    </xsl:template>-->
    
    <!--<xsl:template match="/">
        <!-\- Werte überprüfen: Werte in litHist.interp, die im Folgenden nicht abgedeckt sind -\->
        <entries>
            <xsl:for-each select="//bibl">
                <xsl:variable name="summaries" select="term[contains(@type,'summary')]/normalize-space(.)"/>
                <xsl:for-each select="term[@type='subgenre.litHist.interp']">
                    <xsl:if test="not(exists(index-of($summaries, normalize-space(current()))))">
                        <entry><xsl:value-of select="parent::bibl/@xml:id"/></entry>
                    </xsl:if>    
                </xsl:for-each>
            </xsl:for-each>
        </entries>
    </xsl:template>-->
    
</xsl:stylesheet>