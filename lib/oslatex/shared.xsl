<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
  version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:preserve-space elements="w:t"/>

  <!-- Text run -->
  <xsl:template match="w:r">
    <r>
      <xsl:apply-templates/>
    </r>
  </xsl:template>

  <!-- Text run properties -->
  <xsl:template match="w:rPr">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="w:rPr/w:rStyle">
    <style value="{@w:val}"/>
  </xsl:template>

  <xsl:template match="w:i|w:iCs">
    <style value="italics"/>
  </xsl:template>

  <xsl:template match="w:u">
    <style value="underline"/>
  </xsl:template>

  <xsl:template match="w:strike">
    <style value="strikethrough"/>
  </xsl:template>

  <xsl:template match="w:b|w:bCs">
    <style value="bold"/>
  </xsl:template>

  <xsl:template match="w:rPr/w:caps">
    <!-- TODO -->
  </xsl:template>

  <xsl:template match="w:rPr/w:smallCaps">
    <style value="smallcaps"/>
  </xsl:template>

  <xsl:template match="w:rPr/w:color">
    <style value="color-{@w:val}"/>
  </xsl:template>

  <xsl:template match="w:rPr/w:highlight">
    <style value="highlight-{@w:val}"/>
  </xsl:template>

  <xsl:template match="w:rPr/w:vertAlign">
    <xsl:choose>
      <xsl:when test="@w:val='superscript'">
        <style value="superscript"/>
      </xsl:when>
      <xsl:when test="@w:val='subscript'">
        <style value="subscript"/>
      </xsl:when>
      <!-- Otherwise ignored -->
    </xsl:choose>
  </xsl:template>

  <!-- Ignored -->
  <xsl:template match="w:rPr/w:bdr"/>
  <xsl:template match="w:rPr/w:kern"/>
  <xsl:template match="w:rPr/w:lang"/>
  <xsl:template match="w:rPr/w:noProof"/>
  <xsl:template match="w:rPr/w:rFonts"/>
  <xsl:template match="w:rPr/w:rPrChange"/>
  <xsl:template match="w:rPr/w:spacing"/>
  <xsl:template match="w:rPr/w:sz"/>
  <xsl:template match="w:rPr/w:szCs"/>

  <!-- Footnotes, endnotes -->
  <xsl:template match="w:r/w:footnoteReference">
    <footnote n="{@w:id}"/>
  </xsl:template>

  <xsl:template match="w:r/w:endnoteReference">
    <endnote n="{@w:id}"/>
  </xsl:template>

  <!-- Text -->
  <xsl:template match="w:r/w:t">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Tab: replace by a single space so that we don't miss any whitespace -->
  <xsl:template match="w:r/w:tab">
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- Complex fields -->
  <xsl:template match="w:fldSimple|w:fldChar|w:instrText"/><!-- TODO -->

  <!-- Ignored -->
  <xsl:template match="w:r/w:br"/><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.break.aspx -->
  <xsl:template match="w:r/w:ruby"/>
  <xsl:template match="w:r/w:softHyphen"/><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.softhyphen.aspx -->

  <!-- Paragraph -->
  <xsl:template match="w:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- Paragraph properties -->
  <xsl:template match="w:pPr">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="w:pPr/w:pStyle">
    <style value="{@w:val}"/>
  </xsl:template>

  <!-- Ignored -->
  <xsl:template match="w:pPr/w:adjustRightInd"/>
  <xsl:template match="w:pPr/w:autoSpaceDE"/>
  <xsl:template match="w:pPr/w:autoSpaceDN"/>
  <xsl:template match="w:pPr/w:contextualSpacing"/><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.contextualspacing.aspx -->
  <xsl:template match="w:pPr/w:keepNext"/>
  <xsl:template match="w:pPr/w:outlineLvl"/>
  <xsl:template match="w:pPr/w:overflowPunct"/>
  <xsl:template match="w:pPr/w:pBdr"/>
  <xsl:template match="w:pPr/w:pPrChange"/>
  <xsl:template match="w:pPr/w:shd"/>
  <xsl:template match="w:pPr/w:spacing"/>
  <xsl:template match="w:pPr/w:suppressAutoHyphens"/>
  <xsl:template match="w:pPr/w:tabs"/>
  <xsl:template match="w:pPr/w:textAlignment"/>
  <xsl:template match="w:pPr/w:widowControl"/>
  <xsl:template match="w:pPr/w:keepLines"/>

  <!-- Insertions and deletions -->
  <xsl:template match="w:ins"><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.inserted.aspx -->
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="w:del"/><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.deleted.aspx -->

  <!-- Tables -->
  <xsl:template match="w:tbl">
    <table>
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="w:tbl/w:tblGrid"/><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.tablegrid.aspx -->
  <xsl:template match="w:tbl/w:tblPr"/><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.tableproperties.aspx -->

  <xsl:template match="w:tbl/w:tr"><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.tablerow.aspx -->
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="w:tbl/w:tr/w:trPr"><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.tablerowproperties.aspx -->
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="w:tbl/w:tr/w:tc"><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.tablecell.aspx -->
    <tc>
      <xsl:apply-templates/>
    </tc>
  </xsl:template>

  <xsl:template match="w:tbl/w:tr/w:tc/w:tcPr"><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.tablecellproperties.aspx -->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- TODO -->
  <xsl:template match="w:tbl/w:tr/w:tc/w:tcPr/w:vMerge"/><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.verticalmerge.aspx -->
  <xsl:template match="w:tbl/w:tr/w:tc/w:tcPr/w:gridSpan"/><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.gridspan.aspx -->
  <xsl:template match="w:wAfter"/>
  <xsl:template match="w:gridAfter"/>

  <!-- Symbols, hyperlinks -->
  <xsl:template match="w:sym"><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.symbolchar.aspx -->
    <symbol><xsl:apply-templates/></symbol>
  </xsl:template>

  <xsl:template match="w:hyperlink"><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.hyperlink.aspx -->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Drawings and pictures: insert placeholders for these -->
  <xsl:template match="w:drawing">
    <drawing/>
  </xsl:template>

  <xsl:template match="w:pict">
    <picture/>
  </xsl:template>

  <xsl:template match="mc:AlternateContent">
    <picture/>
  </xsl:template>

  <!-- Ignored -->
  <xsl:template match="w:hideMark"/>
  <xsl:template match="w:cantSplit"/>
  <xsl:template match="w:divId"/>
  <xsl:template match="w:noWrap"/>
  <xsl:template match="w:shd"/>
  <xsl:template match="w:jc"/>
  <xsl:template match="w:tblCellSpacing"/>
  <xsl:template match="w:tblHeader"/>
  <xsl:template match="w:tcBorders"/>
  <xsl:template match="w:tcW"/>
  <xsl:template match="w:trHeight"/>
  <xsl:template match="w:vAlign"/>
  <xsl:template match="w:cnfStyle"/>

  <!-- TODO -->
  <xsl:template match="w:commentRangeStart|w:commentRangeEnd|w:commentReference"/>
  <xsl:template match="w:ind|w:numPr"/>
  <xsl:template match="w:lastRenderedPageBreak"/>
  <xsl:template match="w:sectPr"/>
  <xsl:template match="w:proofErr"/>
  <xsl:template match="w:bookmarkStart|w:bookmarkEnd"/>

  <!-- Trap unknown stuff -->
  <xsl:template match="*">
    <xsl:message terminate="no">Warning: Unknown element <xsl:value-of select="name()"/></xsl:message>
  </xsl:template>
</xsl:stylesheet>
