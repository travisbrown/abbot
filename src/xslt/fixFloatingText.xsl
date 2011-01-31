<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    exclude-result-prefixes="#all" xmlns="http://www.tei-c.org/ns/1.0">

    <xsl:strip-space elements="*"/>

    <xsl:output method="xml" indent="yes" encoding="utf-8"/>

    <xsl:template match="*">

        <xsl:variable name="parentNameList">
            <list>
                <xsl:for-each select="ancestor::*">
                    <item>
                        <xsl:value-of select="name()"/>
                    </item>
                </xsl:for-each>
            </list>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="not(parent::*)">
                <!-- matches on the root element -->
                <xsl:processing-instruction name="oxygen">
                    <xsl:attribute name="att"
                        >RNGSchema="http://segonku.unl.edu/teianalytics/TEIAnalytics.rng"
                        type="xml"</xsl:attribute>
                </xsl:processing-instruction>
                <xsl:text><![CDATA[
]]></xsl:text>
                <xsl:element name="{name()}">
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="name()='div' and @type and $parentNameList//item='floatingText'">
                <xsl:element name="{name()}">
                    <xsl:copy-of select="@* except @type"/>
                    <xsl:copy-of select="child::node()|@*" copy-namespaces="no"/>
                </xsl:element>
            </xsl:when>

            <xsl:when test="lower-case(name())='floatingtext' and ancestor::sp">
                <q>
                    <xsl:element name="{name()}">
                        <xsl:copy-of select="@* except @type"/>
                        <xsl:copy-of select="child::node()|@*" copy-namespaces="no"/>
                    </xsl:element>
                </q>
            </xsl:when>

            <xsl:otherwise>
                <xsl:element name="{name()}">
                    <xsl:copy-of select="@*[not(name()='TEIform')]"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
