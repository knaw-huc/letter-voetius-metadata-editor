<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cmd="http://www.clarin.eu/cmd/1"
    xmlns:letter-cmdp="http://www.clarin.eu/cmd/1/profiles/clarin.eu:cr1:p_1761816151556"
    xmlns:person-cmdp="http://www.clarin.eu/cmd/1/profiles/clarin.eu:cr1:p_1758888743558"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:param name="cwd" select="'file:/Users/menzowi/Documents/GitHub/hi-generic-letter-metadata-editor/'"/>
    <xsl:param name="app" select="'generic-letter-metadata'"/>
    <xsl:param name="config" select="doc(concat($cwd, '/data/apps/', $app, '/config.xml'))"/>
    
    <xsl:param name="letter-prof" select="'clarin.eu:cr1:p_1761816151556'"/>
    <xsl:param name="person-prof" select="'clarin.eu:cr1:p_1758888743558'"/>
    
    <xsl:param name="out" select="'./output'"/>
    
    <xsl:variable name="NL" select="system-property('line.separator')"/>
    
    <xsl:template name="main">
        <xsl:result-document href="{$out}/edges.csv">
            <xsl:text expand-text="yes">"letter","sender","reciever"{$NL}</xsl:text>
            <xsl:variable name="recs" select="concat($cwd, '/data/apps/', $app, '/profiles/', $letter-prof, '/records')"/>
            <xsl:for-each select="collection(concat($recs,'?match=record-\d+\.xml&amp;on-error=warning'))">
                <xsl:sort select="/cmd:CMD/cmd:Header/cmd:MdSelfLink/replace(.,'unl://','')" data-type="number" order="ascending"/>
                <xsl:variable name="rec" select="."/>
                <xsl:message expand-text="yes">DBG:rec[{base-uri($rec)}]</xsl:message>
                <xsl:text expand-text="yes">{/cmd:CMD/cmd:Header/cmd:MdSelfLink/replace(.,'unl://','')},{//letter-cmdp:Sender//@cmd:valueConceptLink/replace(.,'.*/person/(\d+)','$1')},{//letter-cmdp:Receiver//@cmd:valueConceptLink/replace(.,'.*/person/(\d+)','$1')}{$NL}</xsl:text>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="{$out}/nodes.csv">
            <xsl:text expand-text="yes">"person","name"{$NL}</xsl:text>
            <xsl:variable name="recs" select="concat($cwd, '/data/apps/', $app, '/profiles/', $person-prof, '/records')"/>
            <xsl:for-each select="collection(concat($recs,'?match=record-\d+\.xml&amp;on-error=warning'))">
                <xsl:sort select="/cmd:CMD/cmd:Header/cmd:MdSelfLink/replace(.,'unl://','')" data-type="number" order="ascending"/>
                <xsl:variable name="rec" select="."/>
                <xsl:message expand-text="yes">DBG:rec[{base-uri($rec)}]</xsl:message>
                <xsl:text expand-text="yes">{/cmd:CMD/cmd:Header/cmd:MdSelfLink/replace(.,'unl://','')},"{//person-cmdp:fullName/replace(normalize-space(.),'&quot;','&quot;&quot;')}"{$NL}</xsl:text>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>