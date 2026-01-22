<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cmd="http://www.clarin.eu/cmd/1"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:param name="cwd" select="'file:/Users/menzowi/Documents/GitHub/hi-generic-letter-metadata-editor/'"/>
    <xsl:param name="app" select="'generic-letter-metadata'"/>
    <xsl:param name="config" select="doc(concat($cwd, '/data/apps/', $app, '/config.xml'))"/>
    
    <xsl:variable name="prof" select="'clarin.eu:cr1:p_1761816151556'"/>

    <xsl:variable name="NL" select="system-property('line.separator')"/>
    
    <xsl:template name="main">
        <xsl:text expand-text="yes">"letter","sender","reciever","identifiers","dateAsWritten"{$NL}</xsl:text>
        <xsl:variable name="recs" select="concat($cwd, '/data/apps/', $app, '/profiles/', $prof, '/records')"/>
        <xsl:for-each select="collection(concat($recs,'?match=record-\d+\.xml&amp;on-error=warning'))">
            <xsl:sort select="/cmd:CMD/cmd:Header/cmd:MdSelfLink/replace(.,'unl://','')" data-type="number" order="ascending"/>
            <xsl:variable name="rec" select="."/>
            <xsl:text expand-text="yes">{/cmd:CMD/cmd:Header/cmd:MdSelfLink/replace(.,'unl://','')},</xsl:text>
            <xsl:text expand-text="yes">{//*:Sender//@cmd:valueConceptLink/replace(.,'.*/person/(\d+)','$1')},</xsl:text>
            <xsl:text expand-text="yes">{//*:Receiver//@cmd:valueConceptLink/replace(.,'.*/person/(\d+)','$1')},</xsl:text>
            <xsl:for-each select="//*:Identifier">
                <xsl:text expand-text="yes">{*:holdingInstitution}:{replace(*:identifier,',','\\,')}</xsl:text>
                <xsl:choose>
                    <xsl:when test="position()=last()">
                        <xsl:text>,</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>|</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:text expand-text="yes">{//*:dateAsWritten}</xsl:text>
            <xsl:text expand-text="yes">{$NL}</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>