<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- Match top-level element -->
  <xsl:template match="w:document"><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.document.aspx -->
    <document>
      <xsl:apply-templates/>
    </document>
  </xsl:template>

  <!-- Document body -->
  <xsl:template match="w:document/w:body"><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.body.aspx -->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Document background -->
  <xsl:template match="w:document/w:background"/><!-- https://msdn.microsoft.com/en-us/library/documentformat.openxml.wordprocessing.documentbackground.aspx -->

  <!-- Import shared templates -->
  <xsl:include href="shared.xsl"/>
</xsl:stylesheet>

