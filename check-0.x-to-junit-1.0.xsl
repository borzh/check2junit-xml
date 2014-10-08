<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:x="http://check.sourceforge.net/ns"
    exclude-result-prefixes="x" >

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="x:testsuites">
        <xsl:element name="resource">
            <xsl:attribute name="name">Test suites</xsl:attribute>
            <xsl:apply-templates select="x:suite"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="x:suite">
        <xsl:element name="testsuite">
            <xsl:apply-templates select="./*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="x:title">
        <xsl:attribute name="name">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="x:test">
<!--        <xsl:variable name="test_name" select="./x:id/text()"/>
        <xsl:variable name="file" select="./x:fn/text()"/>
        <xsl:variable name="line" select="./x:fn/text()"/> -->
        <xsl:element name="testcase">
            <xsl:apply-templates select="./x:id"/>
            <xsl:apply-templates select="./x:fn"/>
            <xsl:apply-templates select="./x:duration"/>
            <xsl:apply-templates select="@result"/>
            <xsl:apply-templates select="./x:description"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="x:id">
        <xsl:attribute name="name">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="x:fn">
        <xsl:attribute name="classname">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="x:duration">
        <xsl:attribute name="time">
            <xsl:choose>
                <xsl:when test=". &lt; '0'">
                    <xsl:text>0</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

<!--
replace(., "\$\d+\.\d{2}","\$xx.xx")
-->

    <xsl:template match="@result">
        <xsl:choose>
            <xsl:when test=". = 'failure'">
                <xsl:element name="failure">
                    <xsl:attribute name="message">
                        <xsl:value-of select="../x:message"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:when test=". = 'error'">
                <xsl:element name="error">
                    <xsl:attribute name="message">
                        <xsl:value-of select="../x:message"/>
                    </xsl:attribute>
<!--                    <xsl:text>Traceback (most recent call last):
  File "</xsl:text><xsl:value-of select="../x:fn/text()"/>
  <xsl:text>, line </xsl:text><xsl:value-of select="$line"/>
  <xsl:text></xsl:text>-->
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="x:description">
        <!--xsl:copy/-->
        <xsl:element name="description">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
