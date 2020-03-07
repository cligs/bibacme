<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:cligs="cligs"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- 
        This script generates several statistical charts analyzing the works contained in the bibliography Bib-ACMé.
        
        @author: Ulrike Henny-Krahmer
        
        How to call the script:
        java -jar saxon9he.jar /home/ulrike/Git/bibacme/app/data/works.xml /home/ulrike/Git/scripts-nh/corpus/overviews.xsl
    -->
    
    <xsl:variable name="decade-labels">"1830-1840", "1841-1850", "1851-1860", "1861-1870", "1871-1880", "1881-1890", "1891-1900", "1901-1910"</xsl:variable>
    <xsl:variable name="decades" select='"1840", "1850", "1860", "1870", "1880", "1890", "1900", "1910"'/>
    <xsl:variable name="works" select="doc('/home/ulrike/Git/bibacme/app/data/works.xml')"/>
    <xsl:variable name="editions" select="doc('/home/ulrike/Git/bibacme/app/data/editions.xml')"/>
    <xsl:variable name="data-dir" select="'/home/ulrike/Git/data-nh/corpus/overviews/'"/>
    
    <xsl:template match="/">
        <!-- the following templates can be called one after the other: -->
        
        <!-- creates a bar chart showing the number of Argentine works in Bib-ACMé by decade -->
        <!--<xsl:call-template name="works-by-decade">
            <xsl:with-param name="country">Argentina</xsl:with-param>
        </xsl:call-template>-->
        
        <!-- creates a bar chart showing the number of Cuban works in Bib-ACMé by decade -->
        <!--<xsl:call-template name="works-by-decade">
            <xsl:with-param name="country">Cuba</xsl:with-param>
        </xsl:call-template>-->
        
        <!-- creates a bar chart showing the number of Mexican works in Bib-ACMé by decade -->
        <!--<xsl:call-template name="works-by-decade">
            <xsl:with-param name="country">México</xsl:with-param>
        </xsl:call-template>-->
        
        <!-- creates a histogram showing the number of editions per work -->
        <xsl:call-template name="editions-per-work"/>
            
        
    </xsl:template>
    
    <xsl:template name="editions-per-work">
        <!-- creates a histogram showing the number of editions per work -->
        <xsl:result-document href="{concat($data-dir, 'editions-per-work.html')}" method="html" encoding="UTF-8">
            <html>
                <head>
                    <!-- Plotly.js -->
                    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
                </head>
                <body>
                    <div id="editions-per-work" style="width:850px;height:600px;margin: 0 auto;"></div>
                    <script>
                        var data = [
                        {
                        x: [<xsl:value-of select="string-join(cligs:get-editions-per-work(),',')"/>],
                        type: "histogram",
                        xbins: {size: 1}
                        }
                        ];
                        
                        var layout = {
                        xaxis: {title: "number of editions", tickfont: {size: 14}, titlefont: {size: 16}},
                        yaxis: {title: "number of works", tickfont: {size: 14}, titlefont: {size: 16}}
                        };
                        
                        Plotly.newPlot("editions-per-work", data, layout);
                    </script>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="works-by-decade">
        <xsl:param name="country"/>
        <!-- creates a bar chart showing the number of Argentine works in Bib-ACMé by decade -->
        <xsl:result-document href="{concat($data-dir, 'works-by-decade-', translate(lower-case($country),'é','e'), '.html')}" method="html" encoding="UTF-8">
            <html>
                <head>
                    <!-- Plotly.js -->
                    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
                </head>
                <body>
                    <div id="works-by-decade" style="width:850px;height:600px;margin: 0 auto;"></div>
                    <script>
                        var data = [
                        {
                        x: [<xsl:value-of select="$decade-labels"/>],
                        y: [<xsl:value-of select="string-join(cligs:get-first-edition-decades-counts($country),',')"/>],
                        type: "bar"
                        }
                        ];
                        
                        var layout = {
                        xaxis: {title: "decade", tickfont: {size: 14}, titlefont: {size: 16}},
                        yaxis: {title: "number of works", tickfont: {size: 14}, titlefont: {size: 16}}
                        };
                        
                        Plotly.newPlot("works-by-decade", data, layout);
                    </script>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:function name="cligs:get-editions-per-work" as="xs:string+">
        <xsl:for-each select="$works//listBibl/bibl">
            <xsl:variable name="editions" select="$editions//biblStruct[substring-after(@corresp,'#') = current()/@xml:id]"/>
            <xsl:value-of select="xs:string(count($editions))"/>
        </xsl:for-each>
    </xsl:function>
    
    
    <xsl:function name="cligs:get-first-edition-decades-counts" as="xs:string+">
        <xsl:param name="country"/>
        <xsl:for-each select="$decades">
            <xsl:value-of select="xs:string(count(cligs:get-first-edition-decades($country)[. = xs:integer(current())]))"/>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="cligs:get-first-edition-decades" as="xs:integer+">
        <xsl:param name="country"/>
        <xsl:variable name="works" select="$works//listBibl/bibl[country=$country]"/>
        <xsl:if test="empty($works)">
            <xsl:message terminate="yes">
                Error: No works could be found for the country <xsl:value-of select="$country"/>.
            </xsl:message>
        </xsl:if>
        <xsl:for-each select="$works">
            <xsl:variable name="edition-dates" select="$editions//biblStruct[substring-after(@corresp,'#') = current()/@xml:id]//date[@when or @to]"/>
            <xsl:if test="empty($edition-dates)">
                <xsl:message terminate="yes">
                    Error: No edition dates were found for the work <xsl:value-of select="@xml:id"/>.    
                </xsl:message>
            </xsl:if>
            <xsl:variable name="edition-years" select="cligs:get-edition-years($edition-dates)"/>
            <xsl:variable name="first-edition-year" select="min($edition-years)"/>
            <xsl:variable name="decade-first-edition" select="cligs:get-decade-first-edition($first-edition-year)"/>
            <xsl:if test="empty($decade-first-edition)">
                <xsl:message terminate="yes">
                    Error: The decade of the first edition could not be determined for the year <xsl:value-of select="$first-edition-year"/> and the work <xsl:value-of select="@xml:id"/>
                </xsl:message>
            </xsl:if>
            <xsl:value-of select="$decade-first-edition"/>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="cligs:get-edition-years" as="xs:integer+">
        <xsl:param name="edition-dates" as="node()+"/>
        <xsl:for-each select="$edition-dates">
            <xsl:choose>
                <xsl:when test="./@when">
                    <xsl:value-of select="xs:integer(substring(current()/@when,1,4))"/>
                </xsl:when>
                <xsl:when test="./@to">
                    <xsl:value-of select="xs:integer(substring(current()/@to,1,4))"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="cligs:get-decade-first-edition" as="xs:integer*">
        <xsl:param name="first-edition-year" as="xs:integer"/>
        <xsl:if test="not($first-edition-year > 1829 and $first-edition-year &lt; 1911)">
            <xsl:message terminate="yes">
                Error: the edition year <xsl:value-of select="$first-edition-year"/> is out of range.
            </xsl:message>
        </xsl:if>
        <xsl:for-each select="$decades">
            <xsl:variable name="pos" select="position()"/>
            <xsl:choose>
                <xsl:when test="$pos > 1">
                    <xsl:if test="number($decades[$pos - 1]) &lt; $first-edition-year and $first-edition-year &lt;= number(current())">
                        <xsl:value-of select="xs:integer(current())"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$first-edition-year &lt;= number(current())">
                        <xsl:value-of select="xs:integer(current())"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    
</xsl:stylesheet>