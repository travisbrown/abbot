<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:wxsl="http://www.w3.org/1999/XSL/Transform2"
    version="2.0" exclude-result-prefixes="#all">
    
    <xsl:strip-space elements="*"/>
    
    <xsl:namespace-alias stylesheet-prefix="wxsl" result-prefix="xsl"/>
    
    <xsl:param name="listOfAllElementsInSchema">
        <list>
            <xsl:for-each select="descendant::xs:element/@name">
                <xsl:sort select="." order="ascending"/>
                <item>
                    <xsl:value-of select="."/>
                </item>
            </xsl:for-each>
        </list>
    </xsl:param>
    
    <xsl:param name="TEIsimpleListOfAllowableElements">
        <list>
        <item>c</item>
        <item>s</item>
        <item>w</item>
        <item>corr</item>
        <item>abbr</item>
        <item>add</item>
        <item>addrLine</item>
        <item>author</item>
        <item>bibl</item>
        <item>choice</item>
        <item>cit</item>
        <item>date</item>
        <item>editor</item>
        <item>email</item>
        <item>emph</item>
        <item>foreign</item>
        <item>gap</item>
        <item>head</item>
        <item>hi</item>
        <item>item</item>
        <item>l</item>
        <item>label</item>
        <item>lb</item>
        <item>lg</item>
        <item>list</item>
        <item>milestone</item>
        <item>name</item>
        <item>note</item>
        <item>num</item>
        <item>orig</item>
        <item>p</item>
        <item>pb</item>
        <item>publisher</item>
        <item>pubPlace</item>
        <item>q</item>
        <item>quote</item>
        <item>ref</item>
        <item>reg</item>
        <item>resp</item>
        <item>respStmt</item>
        <item>rs</item>
        <item>said</item>
        <item>series</item>
        <item>soCalled</item>
        <item>sp</item>
        <item>speaker</item>
        <item>stage</item>
        <item>teiCorpus</item>
        <item>term</item>
        <item>title</item>
        <item>unclear</item>
        <item>sic</item>
        <item>address</item>
        <item>castGroup</item>
        <item>castItem</item>
        <item>castList</item>
        <item>epilogue</item>
        <item>role</item>
        <item>roleDesc</item>
        <item>cell</item>
        <item>figDesc</item>
        <item>figure</item>
        <item>formula</item>
        <item>row</item>
        <item>table</item>
        <item>availability</item>
        <item>biblFull</item>
        <item>change</item>
        <item>edition</item>
        <item>editionStmt</item>
        <item>editorialDecl</item>
        <item>encodingDesc</item>
        <item>extent</item>
        <item>fileDesc</item>
        <item>idno</item>
        <item>keywords</item>
        <item>language</item>
        <item>langUsage</item>
        <item>notesStmt</item>
        <item>principal</item>
        <item>profileDec</item>
        <item>publicationStmt</item>
        <item>revisionDesc</item>
        <item>taxonomy</item>
        <item>textClass</item>
        <item>titleStmt</item>
        <item>sourceDesc</item>
        <item>ab</item>
        <item>link</item>
        <item>ptr</item>
        <item>seg</item>
        <item>sub</item>
        <item>sup</item>
        <item>sb</item>
        <item>argument</item>
        <item>back</item>
        <item>body</item>
        <item>byline</item>
        <item>closer</item>
        <item>dateline</item>
        <item>div</item>
        <item>docAuthor</item>
        <item>docDate</item>
        <item>docEdition</item>
        <item>docImprint</item>
        <item>docTitle</item>
        <item>epigraph</item>
        <item>floatingText</item>
        <item>front</item>
        <item>group</item>
        <item>imprimatur</item>
        <item>opener</item>
        <item>salute</item>
        <item>signed</item>
        <item>text</item>
        <item>titlePage</item>
        <item>titlePart</item>
        <item>trailer</item>
        <item>TEI</item>
        <item>projectDesc</item>
        <item>teiHeader</item>
        <item>postscript</item>
</list>
    </xsl:param>
    
    <xsl:output method="xml" indent="yes" encoding="utf-8"/>
    
    <xsl:template match="/">
       
        <teiCorpus.2>
            <teiHeader/>
            <TEI.2 id="listOfAllElementsInSchema">
                <body>
                    <xsl:copy-of select="$listOfAllElementsInSchema"/>
                </body>
            </TEI.2> 
            <TEI.2 id="TEIsimpleListOfAllowableElements">
                <body>
                    <list>
                    <xsl:for-each select="$TEIsimpleListOfAllowableElements//item">
                        
                        <xsl:sort select="." order="ascending"/>
                        
                        <xsl:copy-of select="."/>
                        
                    </xsl:for-each>
                </list>
                </body>
            </TEI.2>
            </teiCorpus.2>
       
    </xsl:template>
    
</xsl:stylesheet>
