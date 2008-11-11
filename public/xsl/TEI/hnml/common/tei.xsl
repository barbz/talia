<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  xmlns:xd="http://www.pnp-software.com/XSLTdoc"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:fotex="http://www.tug.org/fotex"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  exclude-result-prefixes="xd tei fotex fo" 
  version="1.0">


  <xsl:import href="tei-param.xsl"/>

<xd:doc type="stylesheet">
    <xd:short>
    TEI stylesheet definitions common for all of HTML, FO and LaTeX outputs
      </xd:short>
    <xd:detail>
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

   
   
      </xd:detail>
    <xd:author>Sebastian Rahtz sebastian.rahtz@oucs.ox.ac.uk</xd:author>
    <xd:cvsId>$Id: tei.xsl,v 1.1 2006/02/16 15:31:44 giacomi Exp $</xd:cvsId>
    <xd:copyright>2005, TEI Consortium</xd:copyright>
  </xd:doc>

  <xsl:include href="core.xsl"/>
  <xsl:include href="textstructure.xsl"/>
  <xsl:include href="header.xsl"/>
  <xsl:include href="linking.xsl"/>
  <xsl:include href="figures.xsl"/>

<xsl:key name="KEYS" use="key" match="entry"/>
<xsl:param name="lang">en</xsl:param>

<xd:doc type="string">
Uppercase letters.
</xd:doc>
<xsl:variable name="uc">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  
<xd:doc type="string">
Lowercase letters.
</xd:doc>
<xsl:variable name="lc">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  
<xd:doc type="string">
Name of XSLT processor.
</xd:doc>
<xsl:variable name="processor">
   <xsl:value-of select="system-property('xsl:vendor')"/>
</xsl:variable>
  
  <xd:doc>
    <xd:short>[common] turn names into quote characters</xd:short>
    <xd:param name="quote">quote</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="getQuote">
    <xsl:param name="quote"/>
    <xsl:choose>
      <xsl:when test="$quote='laquo'">«</xsl:when>
      <xsl:when test="$quote='ldquo'">“</xsl:when>
      <xsl:when test="$quote='ldquor'">„</xsl:when>
      <xsl:when test="$quote='lsaquo'">‹</xsl:when>
      <xsl:when test="$quote='lsquo'">‘</xsl:when>
      <xsl:when test="$quote='lsquor'">‚</xsl:when>
      <xsl:when test="$quote='mdash'">—</xsl:when>
      <xsl:when test="$quote='raquo'">»</xsl:when>
      <xsl:when test="$quote='rdquo'">”</xsl:when>
      <xsl:when test="$quote='rdquor'">‟</xsl:when>
      <xsl:when test="$quote='rsaquo'">›</xsl:when>
      <xsl:when test="$quote='rsquo'">’</xsl:when>
      <xsl:when test="$quote='rsquor'">‛</xsl:when>
      <xsl:otherwise>?</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xd:doc>
    <xd:short>[common] give language-specific version of a word of phrase</xd:short>
    <xd:param name="word">the word(s) to translate</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
<xsl:template name="i18n">
  <xsl:param name="word"/>
<xsl:choose>
<xsl:when test="$word='appendixWords' and not($appendixWords='')">
  <xsl:value-of select="$appendixWords"/>
</xsl:when>
<xsl:when test="$word='authorWord' and not($authorWord='')">
  <xsl:value-of select="$authorWord"/>
</xsl:when>
<xsl:when test="$word='biblioWords' and not($biblioWords='')">
  <xsl:value-of select="$biblioWords"/>
</xsl:when>
<xsl:when test="$word='dateWord' and not($dateWord='')">
  <xsl:value-of select="$dateWord"/>
</xsl:when>
<xsl:when test="$word='figureWord' and not($figureWord='')">
  <xsl:value-of select="$figureWord"/>
</xsl:when>
<xsl:when test="$word='figureWords' and not($figureWords='')">
  <xsl:value-of select="$figureWords"/>
</xsl:when>
<xsl:when test="$word='nextWord' and not($nextWord='')">
  <xsl:value-of select="$nextWord"/>
</xsl:when>
<xsl:when test="$word='noteHeading' and not($noteHeading='')">
  <xsl:value-of select="$noteHeading"/>
</xsl:when>
<xsl:when test="$word='previousWord' and not($previousWord='')">
  <xsl:value-of select="$previousWord"/>
</xsl:when>
<xsl:when test="$word='revisedWord' and not($revisedWord='')">
  <xsl:value-of select="$revisedWord"/>
</xsl:when>
<xsl:when test="$word='tableWord' and not($tableWord='')">
  <xsl:value-of select="$tableWord"/>
</xsl:when>
<xsl:when test="$word='tableWords' and not($tableWords='')">
  <xsl:value-of select="$tableWords"/>
</xsl:when>
<xsl:when test="$word='tocWords' and not($tocWords='')">
  <xsl:value-of select="$tocWords"/>
</xsl:when>
<xsl:when test="$word='upWord' and not($upWord='')">
  <xsl:value-of select="$upWord"/>
</xsl:when>
<xsl:otherwise>
  <xsl:for-each select="document('../i18n.xml',document(''))">
    <xsl:choose>
    <xsl:when test="key('KEYS',normalize-space($word))/text[@xml:lang=$lang]">
	<xsl:value-of select="key('KEYS',normalize-space($word))/text[@xml:lang=$lang]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$word"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
  
</xsl:stylesheet>