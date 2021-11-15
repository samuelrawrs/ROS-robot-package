<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <package>
            <!-- The variable format can be used for further processing.  -->
            <export>
                <metapackage>
                    <xsl:value-of select="/package/export/metapackage"/>
                </metapackage>
            </export>
            <xsl:for-each select=".">
                <exec_depend>
                    <xsl:value-of select="'turtlebot3_bringup'"/>
                </exec_depend>
            </xsl:for-each>
            <buildtool_depend>
                <xsl:value-of select="/package/buildtool_depend"/>
            </buildtool_depend>
            <xsl:for-each select=".">
                <url>
                    <xsl:attribute name="type">

                        <xsl:value-of select="'website'"/>
                    </xsl:attribute>
                    <xsl:value-of select="'http://wiki.ros.org/turtlebot3'"/>
                </url>
            </xsl:for-each>
            <maintainer>
                <!-- The variable email can be used for further processing.  -->
                <xsl:attribute name="email">
                    <xsl:value-of select="email"/>
                </xsl:attribute>
                <xsl:variable
                    name="email" select="/package/maintainer/@email"/>
                <xsl:value-of select="/package/maintainer"/>
            </maintainer>
            <xsl:for-each select=".">
                <author>
                    <xsl:attribute name="email">

                        <xsl:value-of select="./package/maintainer/@email"/>
                    </xsl:attribute>
                    <xsl:value-of select="'Pyo'"/>
                </author>
            </xsl:for-each>
            <xsl:for-each select="/package/license">
                <license>
                    <xsl:value-of select="."/>
                </license>
            </xsl:for-each>
            <description>
                <xsl:value-of select="/package/description"/>
            </description>
            <version>
                <xsl:value-of select="/package/version"/>
            </version>
            <name>
                <xsl:value-of select="/package/name"/>
            </name>

            <xsl:variable
                name="format" select="/package/@format"/>
        </package>
    </xsl:template>
</xsl:stylesheet>