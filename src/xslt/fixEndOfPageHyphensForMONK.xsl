<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <xsl:strip-space elements="*"/>

  <xsl:param name="file"/>

  <xsl:variable name="regex"
    >[\s.?#@%^_+!=,:;()\[\]{}"~`$*/|&#8216;&#8217;&#8220;&#8221;&#191;&#171;&#187;&#161;&#8531;&#8532;&#8212;&#8211;&#9758;&#8230;&#160;&gt;&lt;]+</xsl:variable>

  <xsl:variable name="regexAlphaClass">[A-Za-z]+</xsl:variable>

  <xsl:variable name="regexWordSymbols"
    >[&#188;&#189;&#243;&#225;&#250;&#193;&#211;&amp;]+</xsl:variable>
  <xsl:variable name="regexNumbers">[0-9]+</xsl:variable>

  <xsl:variable name="loneApostrophe">'</xsl:variable>
  <xsl:variable name="loneHyphen">-</xsl:variable>

  <xsl:output method="xml" indent="yes" encoding="utf-8"/>

  <xsl:template match="*[not(name()='p')]">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*[not(name()='TEIform')]"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="//p">

    <xsl:variable name="pbCopy">
      <xsl:copy-of select="descendant::pb"/>
    </xsl:variable>

    <xsl:element name="{name()}">

      <xsl:choose>
        <xsl:when test="not(descendant::orig)">
          <xsl:copy-of select="@*[not(name()='TEIform')]"/>
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:when test="descendant::orig and descendant::pb">

          <xsl:variable name="paragraphWithDescendantOrig">
            <xsl:for-each select="text() | *">
              <xsl:choose>

                <xsl:when
                  test="(text() or descendant::*/text()) 
                  and string-length(name())&gt;0
                  and not(name()='orig')
                  ">
                  <!-- traps 'hi' and its ilk (but not orig) as child of present paragraph -->
                  <z>
                    <xsl:element name="{name()}">
                      <xsl:copy-of select="@*[not(name()='TEIform')]"/>

                      <xsl:attribute name="childOfCurrentParagraph">yes</xsl:attribute>

                      <xsl:apply-templates/>
                    </xsl:element>
                  </z>
                </xsl:when>

                <xsl:when test="text() and not(name()='hi')">
                  <z id="orig1">
                    <xsl:value-of select="normalize-space(.)"/>
                  </z>

                  <xsl:copy-of select="$pbCopy"/>

                  <z id="reg">
                    <xsl:value-of select="normalize-space(@reg)"/>
                  </z>
                </xsl:when>
                <xsl:when test=".[not(text())][not(*)]">
                  <xsl:call-template name="markupTokensAsWords"/>
                </xsl:when>

              </xsl:choose>
            </xsl:for-each>
          </xsl:variable>

          <!-- retain for debugging
            <xsl:copy-of select="$paragraphWithDescendantOrig"/>
          -->

          <xsl:variable name="paragraphWithDescendantOrigAndRegElementAdded">
            <xsl:for-each select="$paragraphWithDescendantOrig/*">

              <xsl:variable name="currentNode">
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:variable>

              <xsl:variable name="regValue">
                <xsl:value-of select="normalize-space(preceding-sibling::*[1][@id])"/>
              </xsl:variable>

              <xsl:choose>

                <xsl:when test="name()='pb'">
                  <xsl:element name="{name()}">
                    <xsl:copy-of select="@*[not(name()='TEIform')]"/>
                    <xsl:apply-templates/>
                  </xsl:element>
                </xsl:when>

                <xsl:when test="preceding-sibling::z[1]/@id='reg'">
                  <orig>
                    <xsl:value-of select="."/>
                  </orig>
                </xsl:when>
                <xsl:when test="following-sibling::z[1]/@id='reg'">
                  <orig>
                    <xsl:value-of select="."/>
                  </orig>
                </xsl:when>

                <xsl:when test="@id='reg'">
                  <reg>
                    <xsl:value-of select="."/>
                  </reg>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="."/>
                  <xsl:if
                    test="not(following-sibling::*[1]/attribute::type)
                    and not(ends-with($regValue,$currentNode))
                    and not(@type='nonWord')
                    ">
                    <xsl:text> </xsl:text>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:variable>

         <!-- retain for debugging
            <xsl:copy-of select="$paragraphWithDescendantOrigAndRegElementAdded"/>
          -->

          <xsl:for-each select="$paragraphWithDescendantOrigAndRegElementAdded">

            <xsl:call-template name="displayFinal"/>

          </xsl:for-each>

        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:element>

  </xsl:template>

  <xsl:template name="markupTokensAsWords">
    <xsl:analyze-string regex="{$regex}" select="normalize-space(.)">

      <xsl:non-matching-substring>
        <xsl:choose>

          <xsl:when test="matches(.,$regexAlphaClass)">
            <z>
              <xsl:value-of select="."/>
            </z>
          </xsl:when>

          <xsl:when test="matches(.,$regexWordSymbols)">
            <z>
              <xsl:value-of select="."/>
            </z>
          </xsl:when>

          <xsl:when test="matches(.,$regexNumbers)">
            <z>
              <xsl:value-of select="."/>
            </z>
          </xsl:when>

          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:non-matching-substring>

      <xsl:matching-substring>
        <xsl:choose>
          <xsl:when test=".=' '">
            <xsl:value-of select="."/>
          </xsl:when>
          <xsl:otherwise>
            <z type="nonWord">
              <xsl:value-of select="."/>
            </z>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <xsl:template name="displayFinal">

    <xsl:for-each select="child::*">
      <xsl:choose>

        <xsl:when test="descendant::*">

          <xsl:for-each select="child::*">
            <xsl:element name="{name()}">
              <xsl:copy-of
                select="@*[not(name()='TEIform')]
                [not(name()='childOfCurrentParagraph')]
                "/>
              <xsl:apply-templates/>
            </xsl:element>
          </xsl:for-each>

          <xsl:if
            test="not(following-sibling::z[1]/@type='nonWord') 
            and not(@type='nonWord')
            and not(following-sibling::*[1][name()='orig'])">
            <xsl:text> </xsl:text>
          </xsl:if>
        </xsl:when>

        <xsl:when test="name()='reg' and not(following-sibling::reg)">
<xsl:value-of select="."/>
            <xsl:copy-of select="preceding-sibling::pb"/>
          <xsl:text> </xsl:text>
        </xsl:when>

        <xsl:when test="name()='orig'"/>

        <xsl:otherwise>
          <xsl:value-of select="."/>
          <xsl:if
            test="not(following-sibling::z[1]/@type='nonWord') 
            and not(@type='nonWord')
            and not(following-sibling::*[1][name()='orig'])
            ">
            <xsl:text> </xsl:text>
          </xsl:if>

          <xsl:if test="following-sibling::z[1]/*/@childOfCurrentParagraph">
            <xsl:text> </xsl:text>
          </xsl:if>

        </xsl:otherwise>
      </xsl:choose>

    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
