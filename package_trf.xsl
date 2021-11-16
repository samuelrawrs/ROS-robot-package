<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>

<!-- identity transform -->
<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="/package">
    <xsl:copy>
       <xsl:apply-templates select="name"/>
       <xsl:apply-templates select="version"/>
       <xsl:apply-templates select="description"/>
       <xsl:apply-templates select="license"/>
       <xsl:apply-templates select="author"/>
       <xsl:apply-templates select="url"/>
       <xsl:apply-templates select="buildtool_depend"/>
       <xsl:apply-templates select="depend"/>
       <xsl:apply-templates select="exec_depend"/>
       <xsl:apply-templates select="export"/>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>