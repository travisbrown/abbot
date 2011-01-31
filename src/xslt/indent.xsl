<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes" encoding="iso-8859-1" />

<xsl:template match="*">
<xsl:copy-of select="."/>
</xsl:template>


</xsl:stylesheet>