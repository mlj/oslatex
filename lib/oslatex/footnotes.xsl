<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- Ignore these -->
  <xsl:template match="w:footnote[@w:type='separator']"/>
  <xsl:template match="w:footnote[@w:type='continuationSeparator']"/>
  <xsl:template match="w:footnoteRef"/>

  <!-- Pass everything through these -->
  <xsl:template match="w:smartTag">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Match top-level collection element -->
  <xsl:template match="w:footnotes">
    <footnotes>
      <xsl:apply-templates/>
    </footnotes>
  </xsl:template>

  <!-- Match a real footnote -->
  <xsl:template match="w:footnote">
    <footnote id="{@w:id}">
      <xsl:apply-templates/>
    </footnote>
  </xsl:template>

  <!-- Import shared templates -->
  <xsl:include href="shared.xsl"/>
</xsl:stylesheet>

