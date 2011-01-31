<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:wxsl="http://www.w3.org/1999/XSL/Transform2"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:strip-space elements="*"/>

    <xsl:namespace-alias stylesheet-prefix="wxsl" result-prefix="xsl"/>

    <xsl:variable name="apostrophe">'</xsl:variable>
    <xsl:variable name="attributeNameParam">{name()}</xsl:variable>
    <xsl:variable name="leftOfVariable">{$</xsl:variable>
    <xsl:variable name="rightOfVariable">}</xsl:variable>

    <xsl:param name="listOfValidElementsInMonkSchema">
        <list>
            <xsl:for-each select="descendant::xs:element/@name">
                <xsl:sort select="." order="ascending"/>
                <item>
                    <xsl:value-of select="."/>
                </item>
            </xsl:for-each>
        </list>
    </xsl:param>

    <xsl:param name="listOfElementsRequiringAdditionalAttributes">
        <node newAttribute="unit" value="break">milestone</node>
    </xsl:param>

    <xsl:param name="listOfAllowableElements">
        <node>c</node>
        <node>s</node>
        <node>w</node>
        <node>corr</node>
        <node>abbr</node>
        <node>add</node>
        <node>addrLine</node>
        <node>author</node>
        <node>bibl</node>
        <node>choice</node>
        <node>cit</node>
        <node>date</node>
        <node>editor</node>
        <node>email</node>
        <node>emph</node>
        <node>foreign</node>
        <node>gap</node>
        <node>head</node>
        <node>hi</node>
        <node>item</node>
        <node>l</node>
        <node>label</node>
        <node>lb</node>
        <node>lg</node>
        <node>list</node>
        <node>milestone</node>
        <node>name</node>
        <node>note</node>
        <node>num</node>
        <node>orig</node>
        <node>p</node>
        <node>pb</node>
        <node>publisher</node>
        <node>pubPlace</node>
        <node>q</node>
        <node>quote</node>
        <node>ref</node>
        <node>reg</node>
        <node>resp</node>
        <node>respStmt</node>
        <node>rs</node>
        <node>said</node>
        <node>series</node>
        <node>soCalled</node>
        <node>sp</node>
        <node>speaker</node>
        <node>stage</node>
        <node>teiCorpus</node>
        <node>term</node>
        <node>title</node>
        <node>unclear</node>
        <node>sic</node>
        <node>address</node>
        <node>castGroup</node>
        <node>castItem</node>
        <node>castList</node>
        <node>epilogue</node>
        <node>role</node>
        <node>roleDesc</node>
        <node>cell</node>
        <node>figDesc</node>
        <node>figure</node>
        <node>formula</node>
        <node>row</node>
        <node>table</node>
        <node>availability</node>
        <node>biblFull</node>
        <node>change</node>
        <node>edition</node>
        <node>editionStmt</node>
        <node>editorialDecl</node>
        <node>encodingDesc</node>
        <node>extent</node>
        <node>fileDesc</node>
        <node>idno</node>
        <node>keywords</node>
        <node>language</node>
        <node>langUsage</node>
        <node>notesStmt</node>
        <node>principal</node>
        <node>profileDesc</node>
        <node>publicationStmt</node>
        <node>revisionDesc</node>
        <node>taxonomy</node>
        <node>textClass</node>
        <node>titleStmt</node>
        <node>sourceDesc</node>
        <node>ab</node>
        <node>link</node>
        <node>ptr</node>
        <node>seg</node>
        <node>sub</node>
        <node>sup</node>
        <node>sb</node>
        <node>argument</node>
        <node>back</node>
        <node>body</node>
        <node>byline</node>
        <node>closer</node>
        <node>dateline</node>
        <node>div</node>
        <node>docAuthor</node>
        <node>docDate</node>
        <node>docEdition</node>
        <node>docImprint</node>
        <node>docTitle</node>
        <node>epigraph</node>
        <node>floatingText</node>
        <node>front</node>
        <node>group</node>
        <node>imprimatur</node>
        <node>opener</node>
        <node>salute</node>
        <node>signed</node>
        <node>text</node>
        <node>titlePage</node>
        <node>titlePart</node>
        <node>trailer</node>
        <node>TEI</node>
        <node>projectDesc</node>
        <node>teiHeader</node>
        <node>postscript</node>
    </xsl:param>

    <xsl:output method="xml" indent="yes" encoding="utf-8"/>

    <xsl:template match="xs:schema">
        <wxsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:xs="http://www.w3.org/2001/XMLSchema">

            <wxsl:strip-space elements="*"/>

            <wxsl:output method="xml" indent="yes" encoding="utf-8"/>

            <wxsl:param name="file"/>

            <xsl:comment>XSLT processor used to create this stylesheet: <xsl:value-of
                    select="system-property('xsl:vendor')"/></xsl:comment>

            <wxsl:template match="*">

                <wxsl:variable name="elementName">
                    <wxsl:value-of select="lower-case(name())"/>
                </wxsl:variable>

                <wxsl:choose>
                    <!-- hides 'idg' structure -->
                    <wxsl:when test="lower-case(name())='idg'"/>

                    <!-- replaces letter element with floatingText @type='letter' -->
                    <wxsl:when test="lower-case(name())='letter'">
                        <floatingText type="letter">
                            <body>
                                <wxsl:apply-templates/>
                            </body>
                        </floatingText>
                    </wxsl:when>

                    <wxsl:when
                        test="(lower-case(name())='p' or lower-case(name())='q') and child::text/body/div1">
                        <wxsl:for-each select="descendant::div1[parent::body]">

                            <wxsl:variable name="divType">
                                <wxsl:value-of select="@type"/>
                            </wxsl:variable>

                            <!-- <wxsl:element name="{$elementName}"> -->
                            <wxsl:element
                                name="{concat($leftOfVariable,'elementName',$rightOfVariable)}">
                                <text>

                                    <wxsl:attribute name="useAttributeForFloatingText">
                                        <!-- Abbot uses this attribute to add it to the floatingText element, where appropriate -->
                                        <wxsl:value-of select="$divType"/>
                                    </wxsl:attribute>

                                    <wxsl:apply-templates/>
                                </text>
                            </wxsl:element>
                        </wxsl:for-each>
                    </wxsl:when>

                    <wxsl:otherwise>
                        <wxsl:apply-templates select="*|@*|text()"/>
                    </wxsl:otherwise>
                </wxsl:choose>

            </wxsl:template>

            <xsl:comment>begin suppression of extra name[s]/resp[s] in respStmt</xsl:comment>
            <wxsl:template
                match="name[parent::respStmt][preceding-sibling::name] | resp[parent::respStmt][preceding-sibling::resp]"
                priority="1"/>
            <xsl:comment>end suppression of extra name[s]/resp[s] in respStmt</xsl:comment>

            <xsl:comment>begin suppression tagsDecl|refsDecl|classDecl|taxonomy|authority|funder</xsl:comment>
            <wxsl:template match="tagsDecl | refsDecl | classDecl | taxonomy | authority | funder" priority="1"/>
            <xsl:comment>end suppression tagsDecl|refsDecl|classDecl|taxonomy|authority|funder</xsl:comment>

            <xsl:comment>begin suppression lb within orig</xsl:comment>
            <wxsl:template match="lb[parent::orig]" priority="1"/>
            <xsl:comment>end suppression lb within orig</xsl:comment>

            <xsl:comment>begin special treatment of orig in EAF collection</xsl:comment>
            <wxsl:template match="orig" priority="1">

                <wxsl:variable name="currentRegValue">
                    <wxsl:value-of select="@reg"/>
                </wxsl:variable>

                <wxsl:variable name="followingOrigValue">
                    <wxsl:value-of select="following-sibling::orig[1][not(@reg)]"/>
                </wxsl:variable>

                <wxsl:choose>
                    <wxsl:when
                        test="ends-with($currentRegValue,$followingOrigValue) and @reg and not(string-length($followingOrigValue)=0)"/>

                    <wxsl:when test="not(@reg)">
                        <wxsl:value-of select="preceding-sibling::orig[1][@reg]/@reg"/>
                    </wxsl:when>

                    <wxsl:otherwise>
                        <wxsl:if test="child::lb">
                            <lb/>
                        </wxsl:if>
                        <wxsl:value-of select="@reg"/>
                    </wxsl:otherwise>
                </wxsl:choose>

            </wxsl:template>
            <xsl:comment>end special treatment of orig in EAF collection</xsl:comment>

            <xsl:comment>begin suppression of duplicate encodingDesc tags</xsl:comment>
            <wxsl:template
                match="encodingDesc[preceding::encodingDesc] | encodingdesc[preceding::encodingdesc]"
                priority="1"/>
            <xsl:comment>end suppression of duplicate encodingDesc tags</xsl:comment>

            <xsl:comment>begin suppression of tags where no element may occur</xsl:comment>
            <wxsl:template match="unclear" priority="1">
                <wxsl:value-of select="."/>
            </wxsl:template>
            <xsl:comment>end suppression of tags where no element may occur</xsl:comment>

            <xsl:comment>begin handling of foreign tags</xsl:comment>
            <wxsl:template match="foreign" priority="1">
                <wxsl:element name="foreign">
                    <wxsl:for-each select="@lang">
                        <wxsl:attribute name="xml:lang">
                            <wxsl:value-of select="."/>
                        </wxsl:attribute>
                    </wxsl:for-each>
                    <wxsl:value-of select="."/>
                </wxsl:element>
            </wxsl:template>
            <xsl:comment>end handling of foreign tags</xsl:comment>

            <xsl:comment>begin suppression of tags where no element may occur</xsl:comment>
            <wxsl:template match="sic" priority="1">
                <wxsl:value-of select="@corr"/>
            </wxsl:template>
            <xsl:comment>end suppression of tags where no element may occur</xsl:comment>

            <xsl:comment>begin suppression of textClass where it may not occur in TCP
                texts</xsl:comment>
            <wxsl:template
                match="profileDesc[ancestor::teiHeader] | profiledesc[ancestor::teiheader]"
                priority="1"/>
            <xsl:comment>end suppression of textClass where it may not occur in TCP
                texts</xsl:comment>

            <xsl:comment>begin suppression of title@type='245' where it may not occur in TCP
                texts</xsl:comment>
            <wxsl:template match="title[@type='245' or @type='246']" priority="1">
                <wxsl:element name="title">
                    <wxsl:value-of select="."/>
                </wxsl:element>
            </wxsl:template>
            <xsl:comment>end suppression of title@type='245' where it may not occur in TCP
                texts</xsl:comment>

            <xsl:comment>begin conversion of @ref attributes to @facs attribute in ECCO
                texts</xsl:comment>
            <wxsl:template match="pb" priority="1">
                <wxsl:element name="pb">
                    <wxsl:for-each select="@*">
                        <wxsl:choose>
                            <wxsl:when test="name()='ref'">
                                <wxsl:attribute name="facs">
                                    <wxsl:value-of select="."/>
                                </wxsl:attribute>
                            </wxsl:when>
                            <wxsl:when test="name()='n'">
                                <wxsl:attribute name="n">
                                    <wxsl:value-of select="."/>
                                </wxsl:attribute>
                            </wxsl:when>
                            <wxsl:otherwise>
                                <wxsl:copy-of select="@*"/>
                            </wxsl:otherwise>
                        </wxsl:choose>
                    </wxsl:for-each>
                    <wxsl:apply-templates/>
                </wxsl:element>
            </wxsl:template>
            <xsl:comment>end conversion of @ref attributes to @facs attribute in ECCO
                texts</xsl:comment>

            <xsl:comment>begin suppression of divX@type='title page' (with space in @type) where it
                may not occur in TCP texts</xsl:comment>
            <wxsl:template
                match="
            div[contains(@type,' ')] |
            div1[contains(@type,' ')] |
            div2[contains(@type,' ')] |
            div3[contains(@type,' ')] |
            div4[contains(@type,' ')] |
            div5[contains(@type,' ')] |
            div6[contains(@type,' ')] |
            div7[contains(@type,' ')] |
            div8[contains(@type,' ')] |
            div9[contains(@type,' ')]"
                priority="1">
                <wxsl:element name="div">
                    <wxsl:for-each select="@*">
                        <wxsl:choose>

                            <wxsl:when test="contains(.,&quot;{$apostrophe}s &quot;)">
                                <wxsl:attribute name="type">
                                    <wxsl:value-of
                                        select="replace(., &#34;{$apostrophe}s &#34;, '_')"
                                    />
                                </wxsl:attribute>
                            </wxsl:when>

                            <wxsl:when test="contains(.,' ')">
                                <wxsl:attribute name="type">
                                    <wxsl:value-of
                                        select="replace(replace(.,' ','_'),&#34;{$apostrophe}&#34;,'')"
                                    />
                                </wxsl:attribute>
                            </wxsl:when>

                            <wxsl:otherwise>
                                <wxsl:copy-of select="@*"/>
                            </wxsl:otherwise>
                        </wxsl:choose>
                    </wxsl:for-each>
                    <wxsl:apply-templates/>
                </wxsl:element>
            </wxsl:template>
            <xsl:comment>end suppression of title@type='245' where it may not occur in TCP
                texts</xsl:comment>

            <xsl:comment>begin suppression of list[parent::signed]where it may not occur in TCP
                texts</xsl:comment>
            <wxsl:template match="list[parent::signed]" priority="1">
                <wxsl:for-each select=".">
                    <wxsl:value-of select="."/>
                    <wxsl:text> </wxsl:text>
                </wxsl:for-each>
            </wxsl:template>
            <xsl:comment>begin suppression of list[parent::signed]where it may not occur in TCP
                texts</xsl:comment>

            <xsl:comment>begin addition of text parent for group elements that lack
                them</xsl:comment>
            <wxsl:template match="group[not(parent::text)]" priority="1">
                <text>
                    <group>
                        <wxsl:apply-templates/>
                    </group>
                </text>
            </wxsl:template>
            <xsl:comment>end addition of text parent for group elements that lack them</xsl:comment>

            <xsl:comment>begin replacement of head tags with label tags for children of headnotes
                and tailnotes in ECCO</xsl:comment>
            <wxsl:template match="head[parent::headnote or parent::tailnote]" priority="1">
                <label>
                    <wxsl:apply-templates/>
                </label>
            </wxsl:template>
            <xsl:comment>end replacement of head tags with label tags for children of headnotes and
                tailnotes in ECCO</xsl:comment>

            <xsl:comment>begin replacement of headnote|tailnote with note in ECCO
                collection</xsl:comment>
            <wxsl:template match="headnote|tailnote" priority="1">
                <note>

                    <wxsl:choose>
                        <wxsl:when test="name()='headnote'">
                            <wxsl:attribute name="type">head</wxsl:attribute>
                        </wxsl:when>
                        <wxsl:when test="name()='tailnote'">
                            <wxsl:attribute name="type">tail</wxsl:attribute>
                        </wxsl:when>
                    </wxsl:choose>

                    <wxsl:apply-templates/>
                </note>
            </wxsl:template>
            <xsl:comment>end replacement of headnote|tailnote with note in ECCO
                collection</xsl:comment>

            <xsl:comment>begin handling of header element in NCF and ECCO collection</xsl:comment>
            <wxsl:template match="header | temphead" priority="1">
                <teiHeader>
                    <wxsl:apply-templates/>
                </teiHeader>
            </wxsl:template>
            <xsl:comment>end handling of header element in NCF and ECCO collection</xsl:comment>

            <xsl:comment>begin substitution of hi@rend=sup with sup tags</xsl:comment>
            <wxsl:template match="hi[starts-with(@rend,'sup')]" priority="1">
                <sup>
                    <wxsl:apply-templates/>
                </sup>
            </wxsl:template>
            <xsl:comment>end substitution of hi@rend=sup with sup tags</xsl:comment>

            <xsl:comment>begin suppression of paragraph tags in several contexts </xsl:comment>
            <wxsl:template match="p" priority="1">
                <wxsl:choose>
                    <wxsl:when test="ancestor::cell">
                        <seg type="p">
                            <wxsl:apply-templates/>
                        </seg>
                    </wxsl:when>
                    <wxsl:when test="child::text">
                        <wxsl:apply-templates/>
                    </wxsl:when>

                    <wxsl:otherwise>
                        <p>

                            <wxsl:for-each select="/attribute::*">
                                <wxsl:choose>
                                    <wxsl:when test="@TEIform"/>
                                    <wxsl:otherwise>
                                        <wxsl:copy-of select="@*"/>
                                    </wxsl:otherwise>
                                </wxsl:choose>
                            </wxsl:for-each>

                            <wxsl:apply-templates/>
                        </p>
                    </wxsl:otherwise>
                </wxsl:choose>
            </wxsl:template>
            <xsl:comment>end suppression of paragraph tags in several contexts </xsl:comment>

            <xsl:comment>begin substitution of quote tag for q tag and suppression of q tags that
                surround quoted text </xsl:comment>
            <wxsl:template match="q | Q" priority="1">
                <wxsl:choose>
                    <wxsl:when test="child::text">
                        <wxsl:apply-templates/>
                    </wxsl:when>
                    <wxsl:otherwise>
                        <quote>
                            <wxsl:apply-templates/>
                        </quote>
                    </wxsl:otherwise>
                </wxsl:choose>
            </wxsl:template>
            <xsl:comment>end substitution of quote tag for q tag and suppression of q tags that
                surround quoted text </xsl:comment>

            <xsl:comment>begin gap processing and also collapse space in gap@extent='1 letter' (with
                space in @extent) where it may not occur in TCP texts</xsl:comment>
            <wxsl:template match="gap" priority="1">
                <wxsl:choose>
                    <wxsl:when test="contains(@extent,' ')">
                        <wxsl:element name="gap">
                            <wxsl:for-each select="@extent">
                                <wxsl:choose>
                                    <wxsl:when test="contains(.,' ')">
                                        <wxsl:attribute name="extent">
                                            <!-- <wxsl:value-of select="replace(.,' ','_')"/> -->
                                            <wxsl:value-of select="substring-before(.,' ')"/>
                                        </wxsl:attribute>
                                    </wxsl:when>
                                    <wxsl:otherwise>
                                        <wxsl:copy-of select="@*"/>
                                    </wxsl:otherwise>
                                </wxsl:choose>
                            </wxsl:for-each>
                            <wxsl:apply-templates/>
                        </wxsl:element>
                    </wxsl:when>
                    <wxsl:otherwise>
                        <wxsl:copy-of select="."/>
                    </wxsl:otherwise>
                </wxsl:choose>
            </wxsl:template>
            <xsl:comment>end gap processing and also collapse space in gap@extent='1 letter' (with
                space in @extent) where it may not occur in TCP texts</xsl:comment>

            <xsl:comment>begin template that converts 'text' element of quoted text to
                'floatingText' in the output files</xsl:comment>
            <wxsl:template match="text" priority="1">
                <wxsl:choose>
                    <wxsl:when test="ancestor::text and parent::q">
                        <floatingText>
                            <wxsl:if test="descendant::body/*[starts-with(name(),'div')]/@type">
                                <wxsl:attribute name="type">
                                    <wxsl:value-of
                                        select="descendant::body/*[starts-with(name(),'div')][1]/@type"
                                    />
                                </wxsl:attribute>
                            </wxsl:if>
                            <xsl:comment>begin choose that decides whether to add a child 'body'
                                element to floatingText </xsl:comment>
                            <wxsl:choose>
                                <wxsl:when test="child::body">
                                    <wxsl:apply-templates/>
                                </wxsl:when>
                                <wxsl:otherwise>
                                    <body>
                                        <wxsl:apply-templates/>
                                    </body>
                                </wxsl:otherwise>
                            </wxsl:choose>
                            <xsl:comment>end choose that decides whether to add a child 'body'
                                element to floatingText </xsl:comment>
                        </floatingText>
                    </wxsl:when>

                    <wxsl:when test="ancestor::text and not(ancestor::group)">
                        <floatingText>
                            <wxsl:if test="@useAttributeForFloatingText">
                                <!-- adds @type to floatingText where appropriate -->
                                <wxsl:attribute name="type">
                                    <wxsl:value-of
                                        select="replace(@useAttributeForFloatingText,' ','_')"/>
                                </wxsl:attribute>
                            </wxsl:if>
                            <xsl:comment>begin choose that decides whether to add a child 'body'
                                element to floatingText </xsl:comment>
                            <wxsl:choose>
                                <wxsl:when test="child::body">
                                    <wxsl:apply-templates/>
                                </wxsl:when>
                                <wxsl:otherwise>
                                    <body>
                                        <wxsl:apply-templates/>
                                    </body>
                                </wxsl:otherwise>
                            </wxsl:choose>
                            <xsl:comment>end choose that decides whether to add a child 'body'
                                element to floatingText </xsl:comment>
                        </floatingText>
                    </wxsl:when>
                    <wxsl:otherwise>
                        <text>
                            <wxsl:apply-templates/>
                        </text>
                    </wxsl:otherwise>
                </wxsl:choose>
            </wxsl:template>
            <xsl:comment>end template that converts 'text' element of quoted text to 'floatingText'
                in the output files</xsl:comment>

            <xsl:comment>begin empty templates that delete certain elements that are undesired in
                the output files</xsl:comment>
            <wxsl:template match="seriesStmt | seriesstmt" priority="1"/>
            <wxsl:template match="revisionDesc | revisiondesc" priority="1"/>
            <wxsl:template match="langUsage | langusage" priority="1"/>
            <xsl:comment>end empty templates that delete certain elements that are undesired in the
                output files</xsl:comment>

            <xsl:comment>begin milestone handler</xsl:comment>
            <wxsl:template match="milestone" priority="1">
                <wxsl:element name="milestone">
                    <wxsl:if test="@n">
                        <wxsl:attribute name="n">
                            <wxsl:value-of select="@n"/>
                        </wxsl:attribute>
                    </wxsl:if>
                    <wxsl:choose>
                        <wxsl:when test="@unit">
                            <wxsl:attribute name="unit">
                                <wxsl:value-of select="@unit"/>
                            </wxsl:attribute>
                        </wxsl:when>
                        <wxsl:otherwise>
                            <wxsl:attribute name="unit">unknown</wxsl:attribute>
                        </wxsl:otherwise>
                    </wxsl:choose>
                </wxsl:element>
            </wxsl:template>
            <xsl:comment>end milestone handler</xsl:comment>

            <xsl:apply-templates/>

        </wxsl:stylesheet>
    </xsl:template>

    <xsl:template match="xs:documentation"/>

    <xsl:template match="xs:element[@name=$listOfAllowableElements/*]">

        <xsl:variable name="attributeName">
            <xsl:value-of select="@name"/>
        </xsl:variable>

        <xsl:variable name="attributeNameLowercase">
            <xsl:value-of select="lower-case(@name)"/>
        </xsl:variable>

        <xsl:element name="xsl:template">
            <xsl:attribute name="match">
                <!-- begin writing of match value -->
                <xsl:choose>
                    <xsl:when test="$attributeName = $attributeNameLowercase">
                        <xsl:value-of select="@name"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(@name,' | ',lower-case(@name))"/>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- end writing of match value -->
            </xsl:attribute>

            <xsl:variable name="associatedAttributeList">
                <list>

                    <!-- begin attributes in the 'xs:attributeGroup' section -->
                    <xsl:for-each select="descendant::xs:attributeGroup">
                        <item>
                            <xsl:value-of select="substring-after(@ref,'attribute.')"/>
                        </item>
                    </xsl:for-each>
                    <!-- end attributes in the 'xs:attributeGroup' section -->

                    <!-- begin attributes in the 'xs:attribute' section -->
                    <xsl:for-each select="descendant::xs:attribute">
                        <item>
                            <xsl:value-of select="@name"/>
                        </item>
                    </xsl:for-each>
                    <!-- end attributes in the 'xs:attribute' section -->

                </list>
            </xsl:variable>

            <xsl:element name="{$attributeName}">
                <wxsl:for-each select="./@*">
                    <xsl:for-each select="$associatedAttributeList/list">
                        <wxsl:choose>
                            <xsl:for-each select="child::item[string-length(.) &gt; 0]">

                                <wxsl:when>
                                    <xsl:attribute name="test">
                                        <xsl:value-of
                                            select="concat('name()=',$apostrophe,.,$apostrophe)"/>
                                    </xsl:attribute>
                                    <wxsl:attribute name="{$attributeNameParam}">
                                        <wxsl:value-of select="."/>
                                    </wxsl:attribute>
                                </wxsl:when>

                            </xsl:for-each>
                            <wxsl:otherwise> </wxsl:otherwise>
                        </wxsl:choose>
                    </xsl:for-each>

                </wxsl:for-each>

                <wxsl:apply-templates/>

            </xsl:element>
        </xsl:element>

    </xsl:template>

</xsl:stylesheet>
