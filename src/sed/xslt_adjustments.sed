
s/<xsl:template match="TEI | tei">/<xsl:template match="*[not(parent::*)]">/

s/<xsl:template match="div">/<xsl:template match="div | div0 | div1 | div2 | div3 | div4 | div5 | div6 | div7">/

s/<TEI>/<xsl:processing-instruction name="oxygen"><xsl:attribute name="att">RNGSchema="http:\/\/segonku.unl.edu\/teianalytics\/TEIAnalytics.rng" type="xml"<\/xsl:attribute><\/xsl:processing-instruction><TEI xmlns="http:\/\/www.tei-c.org\/ns\/1.0" n="{$file}">/
