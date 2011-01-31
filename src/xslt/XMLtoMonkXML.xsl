<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:strip-space elements="*"/>
   <xsl:output method="xml" indent="yes" encoding="utf-8"/>
   <xsl:param name="file"/>
   <!--XSLT processor used to create this stylesheet: SAXON 9.1.0.6 from Saxonica--><xsl:template match="*">
      <xsl:variable name="elementName">
         <xsl:value-of select="lower-case(name())"/>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="lower-case(name())='idg'"/>
         <xsl:when test="lower-case(name())='letter'">
            <floatingText type="letter">
               <body>
                  <xsl:apply-templates/>
               </body>
            </floatingText>
         </xsl:when>
         <xsl:when test="(lower-case(name())='p' or lower-case(name())='q') and child::text/body/div1">
            <xsl:for-each select="descendant::div1[parent::body]">
               <xsl:variable name="divType">
                  <xsl:value-of select="@type"/>
               </xsl:variable>
               <xsl:element name="{$elementName}">
                  <text>
                     <xsl:attribute name="useAttributeForFloatingText">
                        <xsl:value-of select="$divType"/>
                     </xsl:attribute>
                     <xsl:apply-templates/>
                  </text>
               </xsl:element>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="*|@*|text()"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--begin suppression of extra name[s]/resp[s] in respStmt--><xsl:template match="name[parent::respStmt][preceding-sibling::name] | resp[parent::respStmt][preceding-sibling::resp]"
                 priority="1"/>
   <!--end suppression of extra name[s]/resp[s] in respStmt--><!--begin suppression tagsDecl|refsDecl|classDecl|taxonomy|authority|funder--><xsl:template match="tagsDecl | refsDecl | classDecl | taxonomy | authority | funder"
                 priority="1"/>
   <!--end suppression tagsDecl|refsDecl|classDecl|taxonomy|authority|funder--><!--begin suppression lb within orig--><xsl:template match="lb[parent::orig]" priority="1"/>
   <!--end suppression lb within orig--><!--begin special treatment of orig in EAF collection--><xsl:template match="orig" priority="1">
      <xsl:variable name="currentRegValue">
         <xsl:value-of select="@reg"/>
      </xsl:variable>
      <xsl:variable name="followingOrigValue">
         <xsl:value-of select="following-sibling::orig[1][not(@reg)]"/>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="ends-with($currentRegValue,$followingOrigValue) and @reg and not(string-length($followingOrigValue)=0)"/>
         <xsl:when test="not(@reg)">
            <xsl:value-of select="preceding-sibling::orig[1][@reg]/@reg"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="child::lb">
               <lb/>
            </xsl:if>
            <xsl:value-of select="@reg"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--end special treatment of orig in EAF collection--><!--begin suppression of duplicate encodingDesc tags--><xsl:template match="encodingDesc[preceding::encodingDesc] | encodingdesc[preceding::encodingdesc]"
                 priority="1"/>
   <!--end suppression of duplicate encodingDesc tags--><!--begin suppression of tags where no element may occur--><xsl:template match="unclear" priority="1">
      <xsl:value-of select="."/>
   </xsl:template>
   <!--end suppression of tags where no element may occur--><!--begin handling of foreign tags--><xsl:template match="foreign" priority="1">
      <xsl:element name="foreign">
         <xsl:for-each select="@lang">
            <xsl:attribute name="xml:lang">
               <xsl:value-of select="."/>
            </xsl:attribute>
         </xsl:for-each>
         <xsl:value-of select="."/>
      </xsl:element>
   </xsl:template>
   <!--end handling of foreign tags--><!--begin suppression of tags where no element may occur--><xsl:template match="sic" priority="1">
      <xsl:value-of select="@corr"/>
   </xsl:template>
   <!--end suppression of tags where no element may occur--><!--begin suppression of textClass where it may not occur in TCP
                texts--><xsl:template match="profileDesc[ancestor::teiHeader] | profiledesc[ancestor::teiheader]"
                 priority="1"/>
   <!--end suppression of textClass where it may not occur in TCP
                texts--><!--begin suppression of title@type='245' where it may not occur in TCP
                texts--><xsl:template match="title[@type='245' or @type='246']" priority="1">
      <xsl:element name="title">
         <xsl:value-of select="."/>
      </xsl:element>
   </xsl:template>
   <!--end suppression of title@type='245' where it may not occur in TCP
                texts--><!--begin conversion of @ref attributes to @facs attribute in ECCO
                texts--><xsl:template match="pb" priority="1">
      <xsl:element name="pb">
         <xsl:for-each select="@*">
            <xsl:choose>
               <xsl:when test="name()='ref'">
                  <xsl:attribute name="facs">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="n">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:copy-of select="@*"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </xsl:element>
   </xsl:template>
   <!--end conversion of @ref attributes to @facs attribute in ECCO
                texts--><!--begin suppression of divX@type='title page' (with space in @type) where it
                may not occur in TCP texts--><xsl:template match="             div[contains(@type,' ')] |             div1[contains(@type,' ')] |             div2[contains(@type,' ')] |             div3[contains(@type,' ')] |             div4[contains(@type,' ')] |             div5[contains(@type,' ')] |             div6[contains(@type,' ')] |             div7[contains(@type,' ')] |             div8[contains(@type,' ')] |             div9[contains(@type,' ')]"
                 priority="1">
      <xsl:element name="div">
         <xsl:for-each select="@*">
            <xsl:choose>
               <xsl:when test="contains(.,&#34;'s &#34;)">
                  <xsl:attribute name="type">
                     <xsl:value-of select="replace(., &#34;'s &#34;, '_')"/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="contains(.,' ')">
                  <xsl:attribute name="type">
                     <xsl:value-of select="replace(replace(.,' ','_'),&#34;'&#34;,'')"/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:copy-of select="@*"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </xsl:element>
   </xsl:template>
   <!--end suppression of title@type='245' where it may not occur in TCP
                texts--><!--begin suppression of list[parent::signed]where it may not occur in TCP
                texts--><xsl:template match="list[parent::signed]" priority="1">
      <xsl:for-each select=".">
         <xsl:value-of select="."/>
         <xsl:text/>
      </xsl:for-each>
   </xsl:template>
   <!--begin suppression of list[parent::signed]where it may not occur in TCP
                texts--><!--begin addition of text parent for group elements that lack
                them--><xsl:template match="group[not(parent::text)]" priority="1">
      <text>
         <group>
            <xsl:apply-templates/>
         </group>
      </text>
   </xsl:template>
   <!--end addition of text parent for group elements that lack them--><!--begin replacement of head tags with label tags for children of headnotes
                and tailnotes in ECCO--><xsl:template match="head[parent::headnote or parent::tailnote]" priority="1">
      <label>
         <xsl:apply-templates/>
      </label>
   </xsl:template>
   <!--end replacement of head tags with label tags for children of headnotes and
                tailnotes in ECCO--><!--begin replacement of headnote|tailnote with note in ECCO
                collection--><xsl:template match="headnote|tailnote" priority="1">
      <note>
         <xsl:choose>
            <xsl:when test="name()='headnote'">
               <xsl:attribute name="type">head</xsl:attribute>
            </xsl:when>
            <xsl:when test="name()='tailnote'">
               <xsl:attribute name="type">tail</xsl:attribute>
            </xsl:when>
         </xsl:choose>
         <xsl:apply-templates/>
      </note>
   </xsl:template>
   <!--end replacement of headnote|tailnote with note in ECCO
                collection--><!--begin handling of header element in NCF and ECCO collection--><xsl:template match="header | temphead" priority="1">
      <teiHeader>
         <xsl:apply-templates/>
      </teiHeader>
   </xsl:template>
   <!--end handling of header element in NCF and ECCO collection--><!--begin substitution of hi@rend=sup with sup tags--><xsl:template match="hi[starts-with(@rend,'sup')]" priority="1">
      <sup>
         <xsl:apply-templates/>
      </sup>
   </xsl:template>
   <!--end substitution of hi@rend=sup with sup tags--><!--begin suppression of paragraph tags in several contexts --><xsl:template match="p" priority="1">
      <xsl:choose>
         <xsl:when test="ancestor::cell">
            <seg type="p">
               <xsl:apply-templates/>
            </seg>
         </xsl:when>
         <xsl:when test="child::text">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <p>
               <xsl:for-each select="/attribute::*">
                  <xsl:choose>
                     <xsl:when test="@TEIform"/>
                     <xsl:otherwise>
                        <xsl:copy-of select="@*"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:for-each>
               <xsl:apply-templates/>
            </p>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--end suppression of paragraph tags in several contexts --><!--begin substitution of quote tag for q tag and suppression of q tags that
                surround quoted text --><xsl:template match="q | Q" priority="1">
      <xsl:choose>
         <xsl:when test="child::text">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <quote>
               <xsl:apply-templates/>
            </quote>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--end substitution of quote tag for q tag and suppression of q tags that
                surround quoted text --><!--begin gap processing and also collapse space in gap@extent='1 letter' (with
                space in @extent) where it may not occur in TCP texts--><xsl:template match="gap" priority="1">
      <xsl:choose>
         <xsl:when test="contains(@extent,' ')">
            <xsl:element name="gap">
               <xsl:for-each select="@extent">
                  <xsl:choose>
                     <xsl:when test="contains(.,' ')">
                        <xsl:attribute name="extent">
                           <xsl:value-of select="substring-before(.,' ')"/>
                        </xsl:attribute>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:copy-of select="@*"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:for-each>
               <xsl:apply-templates/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--end gap processing and also collapse space in gap@extent='1 letter' (with
                space in @extent) where it may not occur in TCP texts--><!--begin template that converts 'text' element of quoted text to
                'floatingText' in the output files--><xsl:template match="text" priority="1">
      <xsl:choose>
         <xsl:when test="ancestor::text and parent::q">
            <floatingText>
               <xsl:if test="descendant::body/*[starts-with(name(),'div')]/@type">
                  <xsl:attribute name="type">
                     <xsl:value-of select="descendant::body/*[starts-with(name(),'div')][1]/@type"/>
                  </xsl:attribute>
               </xsl:if>
               <!--begin choose that decides whether to add a child 'body'
                                element to floatingText --><xsl:choose>
                  <xsl:when test="child::body">
                     <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:otherwise>
                     <body>
                        <xsl:apply-templates/>
                     </body>
                  </xsl:otherwise>
               </xsl:choose>
               <!--end choose that decides whether to add a child 'body'
                                element to floatingText --></floatingText>
         </xsl:when>
         <xsl:when test="ancestor::text and not(ancestor::group)">
            <floatingText>
               <xsl:if test="@useAttributeForFloatingText">
                  <xsl:attribute name="type">
                     <xsl:value-of select="replace(@useAttributeForFloatingText,' ','_')"/>
                  </xsl:attribute>
               </xsl:if>
               <!--begin choose that decides whether to add a child 'body'
                                element to floatingText --><xsl:choose>
                  <xsl:when test="child::body">
                     <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:otherwise>
                     <body>
                        <xsl:apply-templates/>
                     </body>
                  </xsl:otherwise>
               </xsl:choose>
               <!--end choose that decides whether to add a child 'body'
                                element to floatingText --></floatingText>
         </xsl:when>
         <xsl:otherwise>
            <text>
               <xsl:apply-templates/>
            </text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--end template that converts 'text' element of quoted text to 'floatingText'
                in the output files--><!--begin empty templates that delete certain elements that are undesired in
                the output files--><xsl:template match="seriesStmt | seriesstmt" priority="1"/>
   <xsl:template match="revisionDesc | revisiondesc" priority="1"/>
   <xsl:template match="langUsage | langusage" priority="1"/>
   <!--end empty templates that delete certain elements that are undesired in the
                output files--><!--begin milestone handler--><xsl:template match="milestone" priority="1">
      <xsl:element name="milestone">
         <xsl:if test="@n">
            <xsl:attribute name="n">
               <xsl:value-of select="@n"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="@unit">
               <xsl:attribute name="unit">
                  <xsl:value-of select="@unit"/>
               </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
               <xsl:attribute name="unit">unknown</xsl:attribute>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   <!--end milestone handler--><xsl:template match="p">
      <p>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   <xsl:template match="foreign">
      <foreign>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </foreign>
   </xsl:template>
   <xsl:template match="emph">
      <emph>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </emph>
   </xsl:template>
   <xsl:template match="hi">
      <hi>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </hi>
   </xsl:template>
   <xsl:template match="said">
      <said>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='who'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='aloud'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='direct'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </said>
   </xsl:template>
   <xsl:template match="quote">
      <quote>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </quote>
   </xsl:template>
   <xsl:template match="q">
      <q>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='who'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </q>
   </xsl:template>
   <xsl:template match="cit">
      <cit>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </cit>
   </xsl:template>
   <xsl:template match="soCalled | socalled">
      <soCalled>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </soCalled>
   </xsl:template>
   <xsl:template match="term">
      <term>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='decls'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sortKey'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='target'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='cRef'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </term>
   </xsl:template>
   <xsl:template match="sic">
      <sic>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </sic>
   </xsl:template>
   <xsl:template match="corr">
      <corr>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='cert'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='resp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='evidence'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='source'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='unit'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='quantity'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='extent'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='atLeast'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='atMost'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='min'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='max'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='precision'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='scope'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </corr>
   </xsl:template>
   <xsl:template match="choice">
      <choice>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </choice>
   </xsl:template>
   <xsl:template match="reg">
      <reg>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='cert'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='resp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='evidence'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='source'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='unit'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='quantity'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='extent'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='atLeast'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='atMost'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='min'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='max'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='precision'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='scope'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </reg>
   </xsl:template>
   <xsl:template match="orig">
      <orig>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </orig>
   </xsl:template>
   <xsl:template match="gap">
      <gap>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='cert'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='resp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='evidence'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='source'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='unit'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='quantity'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='extent'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='atLeast'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='atMost'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='min'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='max'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='precision'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='scope'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='reason'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='hand'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='agent'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </gap>
   </xsl:template>
   <xsl:template match="add">
      <add>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='hand'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='status'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='seq'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='cert'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='resp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='evidence'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='source'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='unit'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='quantity'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='extent'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='atLeast'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='atMost'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='min'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='max'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='precision'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='scope'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='place'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </add>
   </xsl:template>
   <xsl:template match="unclear">
      <unclear>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='cert'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='resp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='evidence'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='source'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='unit'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='quantity'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='extent'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='atLeast'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='atMost'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='min'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='max'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='precision'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='scope'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='reason'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='hand'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='agent'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </unclear>
   </xsl:template>
   <xsl:template match="name">
      <name>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='nymRef'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='key'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ref'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </name>
   </xsl:template>
   <xsl:template match="rs">
      <rs>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='nymRef'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='key'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ref'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </rs>
   </xsl:template>
   <xsl:template match="email">
      <email>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </email>
   </xsl:template>
   <xsl:template match="address">
      <address>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </address>
   </xsl:template>
   <xsl:template match="addrLine | addrline">
      <addrLine>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </addrLine>
   </xsl:template>
   <xsl:template match="num">
      <num>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='value'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </num>
   </xsl:template>
   <xsl:template match="date">
      <date>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='period'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='when'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='notBefore'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='notAfter'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='from'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='to'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='cert'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='resp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='evidence'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='source'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='unit'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='quantity'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='extent'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='atLeast'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='atMost'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='min'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='max'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='precision'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='scope'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='calendar'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </date>
   </xsl:template>
   <xsl:template match="ptr">
      <ptr>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='evaluate'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='decls'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='target'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='cRef'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </ptr>
   </xsl:template>
   <xsl:template match="ref">
      <ref>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='evaluate'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='decls'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='target'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='cRef'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </ref>
   </xsl:template>
   <xsl:template match="list">
      <list>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </list>
   </xsl:template>
   <xsl:template match="item">
      <item>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </item>
   </xsl:template>
   <xsl:template match="label">
      <label>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </label>
   </xsl:template>
   <xsl:template match="head">
      <head>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </head>
   </xsl:template>
   <xsl:template match="note">
      <note>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='place'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='resp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='anchored'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='target'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='targetEnd'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </note>
   </xsl:template>
   <xsl:template match="milestone">
      <milestone>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ed'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='unit'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </milestone>
   </xsl:template>
   <xsl:template match="pb">
      <pb>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ed'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </pb>
   </xsl:template>
   <xsl:template match="lb">
      <lb>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ed'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </lb>
   </xsl:template>
   <xsl:template match="series">
      <series>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </series>
   </xsl:template>
   <xsl:template match="author">
      <author>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='key'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ref'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </author>
   </xsl:template>
   <xsl:template match="editor">
      <editor>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='role'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </editor>
   </xsl:template>
   <xsl:template match="respStmt | respstmt">
      <respStmt>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </respStmt>
   </xsl:template>
   <xsl:template match="resp">
      <resp>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='key'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ref'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </resp>
   </xsl:template>
   <xsl:template match="title">
      <title>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='key'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ref'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='level'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </title>
   </xsl:template>
   <xsl:template match="publisher">
      <publisher>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </publisher>
   </xsl:template>
   <xsl:template match="pubPlace | pubplace">
      <pubPlace>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='nymRef'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='key'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ref'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </pubPlace>
   </xsl:template>
   <xsl:template match="bibl">
      <bibl>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='default'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </bibl>
   </xsl:template>
   <xsl:template match="l">
      <l>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='part'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </l>
   </xsl:template>
   <xsl:template match="lg">
      <lg>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='org'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sample'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='part'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </lg>
   </xsl:template>
   <xsl:template match="sp">
      <sp>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='who'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </sp>
   </xsl:template>
   <xsl:template match="speaker">
      <speaker>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </speaker>
   </xsl:template>
   <xsl:template match="stage">
      <stage>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </stage>
   </xsl:template>
   <xsl:template match="teiCorpus | teicorpus">
      <teiCorpus>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='version'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </teiCorpus>
   </xsl:template>
   <xsl:template match="teiHeader | teiheader">
      <teiHeader>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </teiHeader>
   </xsl:template>
   <xsl:template match="fileDesc | filedesc">
      <fileDesc>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </fileDesc>
   </xsl:template>
   <xsl:template match="titleStmt | titlestmt">
      <titleStmt>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </titleStmt>
   </xsl:template>
   <xsl:template match="principal">
      <principal>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </principal>
   </xsl:template>
   <xsl:template match="editionStmt | editionstmt">
      <editionStmt>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </editionStmt>
   </xsl:template>
   <xsl:template match="edition">
      <edition>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </edition>
   </xsl:template>
   <xsl:template match="extent">
      <extent>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </extent>
   </xsl:template>
   <xsl:template match="publicationStmt | publicationstmt">
      <publicationStmt>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </publicationStmt>
   </xsl:template>
   <xsl:template match="idno">
      <idno>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </idno>
   </xsl:template>
   <xsl:template match="availability">
      <availability>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='default'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='status'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </availability>
   </xsl:template>
   <xsl:template match="notesStmt | notesstmt">
      <notesStmt>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </notesStmt>
   </xsl:template>
   <xsl:template match="sourceDesc | sourcedesc">
      <sourceDesc>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='default'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </sourceDesc>
   </xsl:template>
   <xsl:template match="biblFull | biblfull">
      <biblFull>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='default'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </biblFull>
   </xsl:template>
   <xsl:template match="encodingDesc | encodingdesc">
      <encodingDesc>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </encodingDesc>
   </xsl:template>
   <xsl:template match="projectDesc | projectdesc">
      <projectDesc>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='default'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </projectDesc>
   </xsl:template>
   <xsl:template match="editorialDecl | editorialdecl">
      <editorialDecl>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='default'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </editorialDecl>
   </xsl:template>
   <xsl:template match="taxonomy">
      <taxonomy>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </taxonomy>
   </xsl:template>
   <xsl:template match="profileDesc | profiledesc">
      <profileDesc>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </profileDesc>
   </xsl:template>
   <xsl:template match="langUsage | langusage">
      <langUsage>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='default'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </langUsage>
   </xsl:template>
   <xsl:template match="language">
      <language>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ident'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='usage'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </language>
   </xsl:template>
   <xsl:template match="textClass | textclass">
      <textClass>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='default'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </textClass>
   </xsl:template>
   <xsl:template match="keywords">
      <keywords>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='scheme'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </keywords>
   </xsl:template>
   <xsl:template match="revisionDesc | revisiondesc">
      <revisionDesc>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </revisionDesc>
   </xsl:template>
   <xsl:template match="change">
      <change>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='who'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='when'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </change>
   </xsl:template>
   <xsl:template match="*[not(parent::*)]">
      <xsl:processing-instruction name="oxygen"><xsl:attribute name="att">RNGSchema="http://segonku.unl.edu/teianalytics/TEIAnalytics.rng" type="xml"</xsl:attribute></xsl:processing-instruction><TEI xmlns="http://www.tei-c.org/ns/1.0" n="{$file}">
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='version'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </TEI>
   </xsl:template>
   <xsl:template match="text">
      <text>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='decls'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </text>
   </xsl:template>
   <xsl:template match="body">
      <body>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='decls'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </body>
   </xsl:template>
   <xsl:template match="group">
      <group>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='decls'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </group>
   </xsl:template>
   <xsl:template match="floatingText | floatingtext">
      <floatingText>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='decls'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </floatingText>
   </xsl:template>
   <xsl:template match="div | div0 | div1 | div2 | div3 | div4 | div5 | div6 | div7">
      <div>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='org'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sample'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='part'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='decls'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template match="trailer">
      <trailer>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </trailer>
   </xsl:template>
   <xsl:template match="byline">
      <byline>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </byline>
   </xsl:template>
   <xsl:template match="dateline">
      <dateline>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </dateline>
   </xsl:template>
   <xsl:template match="argument">
      <argument>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </argument>
   </xsl:template>
   <xsl:template match="epigraph">
      <epigraph>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </epigraph>
   </xsl:template>
   <xsl:template match="opener">
      <opener>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </opener>
   </xsl:template>
   <xsl:template match="closer">
      <closer>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </closer>
   </xsl:template>
   <xsl:template match="salute">
      <salute>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </salute>
   </xsl:template>
   <xsl:template match="signed">
      <signed>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </signed>
   </xsl:template>
   <xsl:template match="postscript">
      <postscript>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </postscript>
   </xsl:template>
   <xsl:template match="titlePage | titlepage">
      <titlePage>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </titlePage>
   </xsl:template>
   <xsl:template match="docTitle | doctitle">
      <docTitle>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='key'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ref'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </docTitle>
   </xsl:template>
   <xsl:template match="titlePart | titlepart">
      <titlePart>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </titlePart>
   </xsl:template>
   <xsl:template match="docAuthor | docauthor">
      <docAuthor>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='key'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ref'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </docAuthor>
   </xsl:template>
   <xsl:template match="imprimatur">
      <imprimatur>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </imprimatur>
   </xsl:template>
   <xsl:template match="docEdition | docedition">
      <docEdition>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </docEdition>
   </xsl:template>
   <xsl:template match="docImprint | docimprint">
      <docImprint>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </docImprint>
   </xsl:template>
   <xsl:template match="docDate | docdate">
      <docDate>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='when'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </docDate>
   </xsl:template>
   <xsl:template match="front">
      <front>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='decls'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </front>
   </xsl:template>
   <xsl:template match="back">
      <back>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='decls'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </back>
   </xsl:template>
   <xsl:template match="s">
      <s>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='function'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='part'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </s>
   </xsl:template>
   <xsl:template match="w">
      <w>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='eos'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='lem'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='pos'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='reg'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='spe'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='tok'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ord'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='part'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='lemma'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='lemmaRef'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </w>
   </xsl:template>
   <xsl:template match="c">
      <c>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='function'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='part'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </c>
   </xsl:template>
   <xsl:template match="table">
      <table>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rows'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='cols'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </table>
   </xsl:template>
   <xsl:template match="row">
      <row>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='role'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rows'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='cols'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </row>
   </xsl:template>
   <xsl:template match="cell">
      <cell>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='role'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rows'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='cols'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </cell>
   </xsl:template>
   <xsl:template match="figure">
      <figure>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='place'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </figure>
   </xsl:template>
   <xsl:template match="figDesc | figdesc">
      <figDesc>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </figDesc>
   </xsl:template>
   <xsl:template match="link">
      <link>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='evaluate'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='targets'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </link>
   </xsl:template>
   <xsl:template match="ab">
      <ab>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='part'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </ab>
   </xsl:template>
   <xsl:template match="seg">
      <seg>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='function'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='part'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='subtype'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </seg>
   </xsl:template>
   <xsl:template match="castList | castlist">
      <castList>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </castList>
   </xsl:template>
   <xsl:template match="castGroup | castgroup">
      <castGroup>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </castGroup>
   </xsl:template>
   <xsl:template match="castItem | castitem">
      <castItem>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='type'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </castItem>
   </xsl:template>
   <xsl:template match="role">
      <role>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </role>
   </xsl:template>
   <xsl:template match="roleDesc | roledesc">
      <roleDesc>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </roleDesc>
   </xsl:template>
   <xsl:template match="sb">
      <sb>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </sb>
   </xsl:template>
   <xsl:template match="sub">
      <sub>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </sub>
   </xsl:template>
   <xsl:template match="sup">
      <sup>
         <xsl:for-each select="./@*">
            <xsl:choose>
               <xsl:when test="name()='xmlid'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='n'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmllang'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rend'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='rendition'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='xmlbase'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='corresp'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='synch'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='sameAs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='copyOf'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='next'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='prev'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='exclude'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='select'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='ana'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:when test="name()='facs'">
                  <xsl:attribute name="{name()}">
                     <xsl:value-of select="."/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
         <xsl:apply-templates/>
      </sup>
   </xsl:template>
</xsl:stylesheet>