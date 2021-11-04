<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xrf="https://projekte.kosit.org/xrechnung/xrechnung-visualization/functions"  
  exclude-result-prefixes="xs math xrf"
  expand-text="yes"
  version="3.0">
  
  <!-- Language of output -->
  <xsl:param name="lang" select="'de'"/>

  <!-- Filename with language file -->
  <xsl:variable name="l10n-filename" select="'l10n/' || $lang || '.xml'"/>
  
  <!-- Variable holding contents of l10n file -->
  <xsl:variable name="l10n-doc">
    <xsl:choose>
      <xsl:when test="doc-available($l10n-filename)">
        <xsl:sequence select="doc($l10n-filename)"/>
      </xsl:when>
      <xsl:when test="doc-available('l10n/de.xml')">
        <xsl:sequence select="doc('l10n/de.xml')"/>
        <!--<xsl:message>Unable to find localization for {$lang}. Using default from de.xml.</xsl:message>-->
      </xsl:when>
      <xsl:otherwise>
        <!--<xsl:message>Unable to find localization for {$lang}. Can't load default from de.xml. Using empty localization.</xsl:message>-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Key for quicker lookups of localized strings -->
  <xsl:key name="l10n" match="entry" use="@key"/>

  <!-- Function returning localized string -->
  <xsl:function name="xrf:_" as="xs:string">
    <xsl:param name="key" as="xs:string"/>
    
    <xsl:variable name="localized" select="key('l10n', $key, $l10n-doc)"/>
    
    <xsl:choose>
      <xsl:when test="$localized">
        <xsl:sequence select="string($localized)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="'???' || $key || '???'"/>
        <!--<xsl:message>Unable to find localization for {$key}.</xsl:message>-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- Function returning ID of localized string. 
       ID is holding original BT/BG number from EU norm -->
  <xsl:function name="xrf:get-id" as="xs:string">
    <xsl:param name="key" as="xs:string"/>
    
    <xsl:variable name="localized" select="key('l10n', $key, $l10n-doc)"/>
    
    <xsl:choose>
      <xsl:when test="$localized/@id">
        <xsl:sequence select="$localized/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="'???'"/>
        <!--<xsl:message>Unable to find BT/BG id for {$key}.</xsl:message>-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- We are emulating older tempate for getting labels in order to maintain backward compatability -->
  <xsl:template name="field-mapping">
    <xsl:param name="identifier"/>
    
    <label><xsl:value-of select="xrf:_($identifier)"/></label>
    <nummer><xsl:value-of select="xrf:get-id($identifier)"/></nummer>
  </xsl:template>
  
  
  <xsl:function name="xrf:field-label" as="xs:string">
    <xsl:param name="identifier"/>
    
    <xsl:sequence select="xrf:_($identifier)"></xsl:sequence>
  </xsl:function>  

</xsl:stylesheet>