<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="not(parent::*)">
        <!-- matches on the root element -->
        <xsl:element name="{name()}">
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      
      <xsl:when test="name()='textClass'">
        <encodingDesc>
        <xsl:apply-templates/>
          </encodingDesc>
        </xsl:when>
      
      <xsl:when test="name()='title'">
        <xsl:choose>
          <xsl:when test="contains(@*,'245')">
            <xsl:element name="{name()}">
              <xsl:apply-templates/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="{name()}">
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:element name="{name()}">
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
      
    </xsl:choose>

  </xsl:template>
  
  
</xsl:stylesheet>
