<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <!-- copy IDs of bibacme works and authors to the corpus files
    Aufruf: java -jar /home/ulrike/Programme/saxon/saxon9he.jar 
    /home/ulrike/Git/bibacme/app/data/works.xml 
    /home/ulrike/Git/bibacme/app/stylesheets/copy-all-but-bibacme-ids.xsl 
    -->
    
    <xsl:output indent="yes"/>
    
    <xsl:template match="node() | @* | comment() | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="node() | @* | comment() | processing-instruction()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:variable name="ausnahmen" select="('nh0001', 'nh0002', 'nh0003', 'nh0004', 'nh0005', 'nh0006', 'nh0007', 'nh0008', 'nh0009', 'nh0010','nh0011', 'nh0012', 'nh0013', 'nh0014', 'nh0015', 'nh0016', 'nh0017', 'nh0018', 'nh0019', 'nh0020')"/>
        <xsl:for-each select="collection('/home/ulrike/Git/hennyu/novelashispanoamericanas/corpus/master')//TEI[not(exists(index-of($ausnahmen, .//idno[@type='cligs'])))]">
            <xsl:variable name="idno" select=".//idno[@type='cligs']"/>
            <xsl:result-document href="{concat('/home/ulrike/Git/hennyu/novelashispanoamericanas/corpus/master_new/',$idno,'.xml')}">
                <xsl:apply-templates select=". | preceding-sibling::processing-instruction()"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:variable name="works" select="doc('/home/ulrike/Git/bibacme/app/data/works.xml')//bibl"/>
    <xsl:variable name="authors" select="doc('/home/ulrike/Git/bibacme/app/data/authors.xml')//person"/>
    
    <xsl:template match="idno[@type='viaf'][parent::title[@type='idno']]">
        <xsl:variable name="cligs-idno" select="ancestor::TEI//idno[@type='cligs']"/>
        <xsl:copy-of select="."/>
        <idno xmlns="http://www.tei-c.org/ns/1.0" type="bibacme">
            <xsl:value-of select="$works[idno[@type='cligs']=$cligs-idno]/@xml:id"/>
        </idno>
    </xsl:template>
    
    
    <xsl:template match="idno[@type='viaf'][parent::author]">
        <xsl:variable name="author-surname" select="parent::author/name[@type='full']/substring-before(.,',')"/>
        <xsl:copy-of select="."/>
        <xsl:if test="$authors[.//surname=$author-surname]/@xml:id">
            <idno xmlns="http://www.tei-c.org/ns/1.0" type="bibacme">
                <xsl:value-of select="$authors[.//surname=$author-surname]/@xml:id"/>
            </idno>
        </xsl:if>
    </xsl:template>
    
    
</xsl:stylesheet>