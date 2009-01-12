<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:edate="http://exslt.org/dates-and-times"
    xmlns:estr="http://exslt.org/strings"
    xmlns:exsl="http://exslt.org/common"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:local="http://www.pantor.com/ns/local"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    extension-element-prefixes="exsl estr edate" 
    exclude-result-prefixes="exsl estr edate a fo local rng tei teix xd" 
    version="1.0">
  
<xd:doc type="stylesheet">
    <xd:short>
    TEI stylesheet dealing  with elements from the
      tagdocs module, making HTML output.
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
    <xd:cvsId>$Id: tagdocs.xsl,v 1.1 2006/02/16 15:31:45 giacomi Exp $</xd:cvsId>
    <xd:copyright>2005, TEI Consortium</xd:copyright>
  </xd:doc>
  
<xd:doc>
    <xd:short>Process elements  attDef</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="attDef" mode="summary">
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="altIdent">
          <xsl:value-of select="altIdent"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@ident"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr>
      <td valign="top">
        <tt>
          <b>
            <xsl:value-of select="$name"/>
          </b>
        </tt>
      </td>
      <td colspan="2">
        <xsl:apply-templates select="desc" mode="show"/>
      </td>
    </tr>
    <xsl:apply-templates select="valList"/>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  attDef</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="attDef">
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="altIdent">
          <xsl:value-of select="altIdent"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@ident"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr>
      <td valign="top">
        <tt>
          <b>
            <xsl:value-of select="$name"/>
          </b>
        </tt>
      </td>
      <td colspan="2">
        <xsl:apply-templates select="desc" mode="show"/>
      </td>
    </tr>
    <tr>
      <td/>
      <td>
	<span class="label">
	  <xsl:call-template name="i18n">
	    <xsl:with-param name="word">Status</xsl:with-param>
	  </xsl:call-template>
	  <xsl:text>: </xsl:text>
	</span>
	<xsl:choose>
	  <xsl:when test="@usage='mwa'">
	    <xsl:call-template name="i18n">
	      <xsl:with-param name="word">Mandatory when applicable</xsl:with-param>
	    </xsl:call-template>
	  </xsl:when>
	  <xsl:when test="@usage='opt'">
	    <xsl:call-template name="i18n">
	      <xsl:with-param name="word">Optional</xsl:with-param>
	    </xsl:call-template>
	  </xsl:when>
	  <xsl:when test="@usage='rec'">
	    <xsl:call-template name="i18n">
	      <xsl:with-param name="word">Recommended</xsl:with-param>
	    </xsl:call-template> 
	  </xsl:when>
	  <xsl:when test="@usage='req'">
	    <hi>
	      <xsl:call-template name="i18n">
		<xsl:with-param name="word">Required</xsl:with-param>
	      </xsl:call-template>
	    </hi>
	  </xsl:when>
	  <xsl:when test="@usage='rwa'">
	    <xsl:call-template  name="i18n">
	      <xsl:with-param name="word">Required when applicable</xsl:with-param>
	    </xsl:call-template>
	  </xsl:when>
	</xsl:choose>
      </td>
    </tr>
    <xsl:apply-templates/>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  attDef/datatype</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="attDef/datatype">
    <tr>
      <td/>
      <td colspan="2" valign="top">
        <span class="label">
	<xsl:call-template name="i18n">
	  <xsl:with-param name="word">Datatype</xsl:with-param>
	</xsl:call-template>
	<xsl:text>: </xsl:text>
	</span>
        <xsl:call-template name="bitOut">
          <xsl:with-param name="grammar"/>
          <xsl:with-param name="content">
            <Wrapper>
              <xsl:copy-of select="rng:*"/>
            </Wrapper>
          </xsl:with-param>
          <xsl:with-param name="element">code</xsl:with-param>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  attDef/exemplum</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="attDef/exemplum">
    <tr>
      <td/>
      <td valign="top" colspan="2">
        <span class="label">
	<xsl:call-template name="i18n">
	<xsl:with-param name="word">Example</xsl:with-param>
	</xsl:call-template>
	<xsl:text>: </xsl:text>
	</span>
        <xsl:call-template name="verbatim">
          <xsl:with-param name="text">
            <xsl:apply-templates/>
          </xsl:with-param>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  attDef/remarks</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="attDef/remarks">
    <tr>
      <td/>
      <td>
        <xsl:apply-templates/>
      </td>
    </tr>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  attList</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="attList" mode="show">
    <xsl:call-template name="displayAttList">
      <xsl:with-param name="mode">summary</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  attList</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="attList" mode="weave">
    <tr>
      <td valign="top">
        <span class="label">
	<xsl:call-template name="i18n">
	<xsl:with-param name="word">Attributes</xsl:with-param>
	</xsl:call-template> 
	</span>
	<xsl:text> </xsl:text>
      </td>
      <td>
        <xsl:call-template name="displayAttList">
          <xsl:with-param name="mode">all</xsl:with-param>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  classSpec</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="classSpec">
    <xsl:if test="parent::specGrp">
      <dt>
	<span class="label">
	  <xsl:call-template name="i18n">
	    <xsl:with-param  name="word">Class</xsl:with-param>
	  </xsl:call-template>
	  </span>:
      <xsl:value-of select="@ident"/></dt>
      <dd>
        <xsl:apply-templates select="." mode="tangle"/>
      </dd>
    </xsl:if>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  classSpec</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="classSpec" mode="weavebody">
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="altIdent">
          <xsl:value-of select="altIdent"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@ident"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr>
      <td valign="top">
        <tt>
          <b>
            <xsl:value-of select="$name"/>
          </b>
        </tt>
      </td>
      <td colspan="2">
        <xsl:apply-templates select="desc" mode="show"/>
      </td>
    </tr>
    <xsl:apply-templates mode="weave"/>
<!--
  <tr>
    <td valign="top">Member of classes</td>
    <td colspan="2">
      <xsl:call-template name="generateClassParents"/>
      &#160;
    </td>
  </tr>
-->
    <tr>
      <td valign="top">
        <span class="label">
	<xsl:call-template name="i18n">
	  <xsl:with-param name="word">Members</xsl:with-param>
	</xsl:call-template></span>
      </td>
      <td colspan="2">
        <xsl:call-template name="generateMembers"/>
      </td>
    </tr>
    <xsl:if test="@module">
      <xsl:call-template name="HTMLmakeTagsetInfo"/>
    </xsl:if>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  classes</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="classes" mode="weave">
    <xsl:if test="memberOf">
      <tr>
        <td valign="top">
          <span class="label">
	  <xsl:call-template name="i18n">
	    <xsl:with-param name="word">Class</xsl:with-param>
	  </xsl:call-template></span>
        </td>
        <td colspan="2">
          <xsl:for-each select="memberOf">
            <xsl:choose>
              <xsl:when test="key('IDENTS',@key)">
                <xsl:variable name="Key">
                  <xsl:value-of select="@key"/>
                </xsl:variable>
                <xsl:for-each select="key('IDENTS',@key)">
                  <xsl:if test="not(generate-id(.)=generate-id(key('IDENTS',$Key)[1]))">
                    <xsl:text> |  </xsl:text>
                  </xsl:if>
                  <xsl:call-template name="linkTogether">
                    <xsl:with-param name="name" select="@ident"/>
                  </xsl:call-template>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="linkTogether">
                  <xsl:with-param name="name" select="@key"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  defaultVal</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="defaultVal">
    <tr>
      <td/>
      <td valign="top" colspan="2">
        <span class="label">
	<xsl:call-template name="i18n">
	  <xsl:with-param  name="word">Default</xsl:with-param>
	</xsl:call-template>
	</span>
	<xsl:text>: </xsl:text>
        <xsl:apply-templates/>
      </td>
    </tr>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  desc</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="desc" mode="weave"/>
  
<xd:doc>
    <xd:short>Process elements  eg</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="eg">
    <xsl:call-template name="verbatim">
      <xsl:with-param name="autowrap">false</xsl:with-param>
      <xsl:with-param name="startnewline">
        <xsl:if test="parent::exemplum">true</xsl:if>
      </xsl:with-param>
      <xsl:with-param name="text">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  elementSpec</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="elementSpec">
    <xsl:if test="parent::specGrp">
      <dt>
      <xsl:call-template name="i18n">
	<xsl:with-param name="word">Element</xsl:with-param>
      </xsl:call-template> 
      <xsl:text> </xsl:text>
      <xsl:value-of select="@ident"/></dt>
      <dd>
        <xsl:apply-templates select="." mode="tangle"/>
      </dd>
    </xsl:if>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  elementSpec</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="elementSpec" mode="weavebody">
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="altIdent">
          <xsl:value-of select="altIdent"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@ident"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr>
      <td valign="top">
        <tt>
          <b>
            <xsl:value-of select="$name"/>
          </b>
        </tt>
      </td>
      <td colspan="2">
        <xsl:apply-templates select="desc" mode="show"/>
      </td>
    </tr>
    <xsl:if test="not(attList)">
      <tr>
        <td valign="top">
          <span class="label">
	  <xsl:call-template name="i18n"><xsl:with-param name="word">Attributes</xsl:with-param></xsl:call-template>: </span>
        </td>
        <td>
          <xsl:choose>
            <xsl:when test="count(classes/memberOf)&gt;0">
	      <xsl:call-template name="i18n">
	      <xsl:with-param name="word">Global attributes and those  inherited from</xsl:with-param>
	      </xsl:call-template>
              <xsl:text> </xsl:text>
              <xsl:for-each select="..">
                <xsl:call-template name="showAttClasses"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
	  
	      <xsl:call-template name="i18n"><xsl:with-param name="word">Global attributes only</xsl:with-param></xsl:call-template>
	</xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </xsl:if>
    <xsl:apply-templates mode="weave"/>
    <xsl:if test="@module">
      <xsl:call-template name="HTMLmakeTagsetInfo"/>
    </xsl:if>

  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  elementSpec/content</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="elementSpec/content" mode="weave">
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="../altIdent">
          <xsl:value-of select="../altIdent"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="../@ident"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr>
      <td valign="top">
        <span class="label">
	<xsl:call-template name="i18n">
	  <xsl:with-param name="word">Declaration</xsl:with-param>
	</xsl:call-template>
	</span>
      </td>
      <td colspan="2">
        <xsl:call-template name="bitOut">
          <xsl:with-param name="grammar"/>
          <xsl:with-param name="content">
            <Wrapper>
              <rng:element name="{$name}">
		<xsl:if test="not(ancestor::schemaSpec)">
		  <rng:ref name="att.global.attributes"/>
		  <xsl:for-each select="../classes/memberOf">
		    <xsl:for-each select="key('IDENTS',@key)">
		      <xsl:if test="attList">
			<rng:ref name="{@ident}.attributes"/>
		      </xsl:if>
		    </xsl:for-each>
		  </xsl:for-each>
		</xsl:if>
                <xsl:apply-templates select="../attList" mode="tangle"/>
                <xsl:copy-of select="rng:*"/>
              </rng:element>
            </Wrapper>
          </xsl:with-param>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process the specification elements  elements, classes
    and macros</xd:short>
    <xd:param name="atts">attributes we have been asked to display</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="elementSpec|classSpec|macroSpec" mode="show">
    <xsl:param name="atts"/>
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="altIdent">
          <xsl:value-of select="altIdent"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@ident"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <b>&lt;<a>
      <xsl:attribute name="href">
	<xsl:choose>
	  <xsl:when test="$splitLevel=-1">
	    <xsl:text>#</xsl:text>
	    <xsl:value-of select="$name"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>ref-</xsl:text>
	    <xsl:value-of select="$name"/>
	    <xsl:text>.html</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="$name"/>
    </a>&gt; </b>
    <xsl:value-of select="desc"/>
    <xsl:choose>
      <xsl:when test="not($atts='')">
	<table class="attList">
	  <xsl:variable name="HERE" select="."/>
	  <xsl:for-each select="estr:tokenize(concat(' ',$atts,' '))">
	    <xsl:variable name="TOKEN" select="."/>
	    <xsl:choose>
	      <xsl:when test="$HERE/attList//attDef[@ident=$TOKEN]">
		<xsl:for-each
		    select="$HERE/attList//attDef[@ident=$TOKEN]">
		  <xsl:call-template name="showAnAttribute"/>
		</xsl:for-each>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:for-each select="$HERE/classes/memberOf">
		  <xsl:for-each select="key('IDENTS',@key)/attList//attDef[@ident=$TOKEN]">
		    <xsl:call-template name="showAnAttribute"/>
		  </xsl:for-each>
		</xsl:for-each>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:for-each>
	</table>
      </xsl:when>
      <xsl:when test="attList//attDef">
	<table class="attList">
	  <xsl:apply-templates select="attList" mode="summary"/>
	</table>
	<xsl:if test="classes/memberOf">
	  <xsl:call-template name="showAttClasses"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="classes/memberOf">
	<xsl:call-template name="showAttClasses"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  

<xd:doc>
    <xd:short>Display of an attribute</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
<xsl:template name="showAnAttribute">
  <tr>
    <td valign="top">
      <b>
	<xsl:choose>
	  <xsl:when test="altIdent">
	    <xsl:value-of select="altIdent"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="@ident"/>
	  </xsl:otherwise>
	</xsl:choose>
      </b>
    </td>
    <td colspan="2">
      <xsl:apply-templates select="desc" mode="show"/>
    </td>
  </tr>
</xsl:template>

<xd:doc>
    <xd:short>Process elements  exemplum</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="exemplum" mode="weave">
    <tr>
      <td valign="top">
        <span class="label">
	  <xsl:call-template name="i18n">
	    <xsl:with-param name="word">Example</xsl:with-param>
	  </xsl:call-template>
	</span>
      </td>
      <td colspan="2">
        <xsl:apply-templates/>
      </td>
    </tr>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  gloss</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="gloss" mode="weave"/>
  
<xd:doc>
    <xd:short>Process elements  gloss</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="gloss"/>
  
<xd:doc>
    <xd:short>Process elements  item</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="item">
    <xsl:choose>
      <xsl:when test="parent::list[@type='gloss']"> 
     	<xsl:apply-templates/>
   </xsl:when>
      <xsl:when test="parent::list[@type='elementlist']"> 
     	<xsl:apply-templates/>
   </xsl:when>
      <xsl:otherwise>
        <li>
          <xsl:apply-templates/>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  macroSpec</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="macroSpec">
    <xsl:if test="parent::specGrp">
      <dt><xsl:value-of select="@ident"/></dt>
      <dd>
        <xsl:apply-templates select="." mode="tangle"/>
      </dd>
    </xsl:if>
  </xsl:template>
  

<xd:doc>
    <xd:short>Process elements  macroSpec in weavebody mode</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="macroSpec" mode="weavebody">
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="altIdent">
          <xsl:value-of select="altIdent"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@ident"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr>
      <td valign="top">
        <tt>
          <b>
            <xsl:value-of select="$name"/>
          </b>
        </tt>
      </td>
      <td colspan="2">
        <xsl:apply-templates select="desc" mode="show"/>
      </td>
    </tr>
    <xsl:apply-templates mode="weave"/>
    <xsl:if test="@module">
      <xsl:call-template name="HTMLmakeTagsetInfo"/>
    </xsl:if>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  macroSpec/content</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="macroSpec/content" mode="weave">
    <tr>
      <td valign="top">
        <span class="label">
	  <xsl:call-template name="i18n">
	    <xsl:with-param name="word">Declaration</xsl:with-param>
	  </xsl:call-template>
	</span>
      </td>
      <td colspan="2">
        <xsl:call-template name="bitOut">
          <xsl:with-param name="grammar">true</xsl:with-param>
          <xsl:with-param name="content">
            <Wrapper>
              <xsl:variable name="entCont">
                <Stuff>
                  <xsl:apply-templates select="rng:*"/>
                </Stuff>
              </xsl:variable>
              <xsl:variable name="entCount">
                <xsl:for-each select="exsl:node-set($entCont)/Stuff">
                  <xsl:value-of select="count(*)"/>
                </xsl:for-each>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test=".=&quot;TEI.singleBase&quot;"/>
                <xsl:otherwise>
                  <rng:define name="{../@ident}">
                    <xsl:if test="starts-with(.,'component')">
                      <xsl:attribute name="combine">choice</xsl:attribute>
                    </xsl:if>
                    <xsl:copy-of select="rng:*"/>
                  </rng:define>
                </xsl:otherwise>
              </xsl:choose>
            </Wrapper>
          </xsl:with-param>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  moduleSpec</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="moduleSpec">
    <hr/>
    <p>
      <strong>
	<xsl:call-template name="i18n">
	  <xsl:with-param name="word">Module</xsl:with-param>
	</xsl:call-template>
      </strong>
      <xsl:text> </xsl:text>
      <em><xsl:value-of select="@ident"/></em>:
      <xsl:apply-templates select="desc" mode="show"/>
      <ul>
	<li>
	  <xsl:call-template name="i18n">
	    <xsl:with-param name="word">Elements defined</xsl:with-param>
	  </xsl:call-template>:
	  <xsl:for-each select="key('ElementModule',@ident)">
	    <xsl:call-template name="linkTogether">
	      <xsl:with-param name="name" select="@ident"/>
	    </xsl:call-template>
	    <xsl:text> </xsl:text>
	  </xsl:for-each>
	</li>
	<li>
	  <xsl:call-template name="i18n">
	    <xsl:with-param name="word">Classes defined</xsl:with-param>
	    </xsl:call-template>:
	  <xsl:for-each select="key('ClassModule',@ident)">
	    <xsl:call-template name="linkTogether">
	      <xsl:with-param name="name" select="@ident"/>
	    </xsl:call-template>
	    <xsl:text> </xsl:text>
	  </xsl:for-each>
      </li>
      <li>
	<xsl:call-template name="i18n">
	  <xsl:with-param name="word">Macros defined</xsl:with-param>
	  </xsl:call-template>:
	  <xsl:for-each select="key('MacroModule',@ident)">
	  <xsl:call-template name="linkTogether">
	    <xsl:with-param name="name" select="@ident"/>
	  </xsl:call-template>
	  <xsl:text> </xsl:text>
	</xsl:for-each>
      </li>
      </ul>
      <hr/>
    </p>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  remarks</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="remarks" mode="weave">
    <xsl:if test="*//text()">
      <tr>
        <td valign="top">
          <span class="label">
	  <xsl:call-template name="i18n">
	    <xsl:with-param name="word">Note</xsl:with-param>
	  </xsl:call-template>
	  </span>
	</td>
        <td colspan="2">
          <xsl:apply-templates/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  specDesc</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="specDesc">
    <li>
      <xsl:call-template name="processSpecDesc"/>
    </li>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  specGrp</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="specGrp">
    <div class="specgrp">
      <p><b>Specification group <xsl:number level="any"/>
      <xsl:if test="@n"><xsl:text>: </xsl:text><xsl:value-of select="@n"/></xsl:if>
    </b>
    <a name="{@id}"/>
      </p>
      <dl>
	<xsl:apply-templates/>
      </dl>
    </div>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  specGrp/p</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="specGrp/p">
    <dt/>
    <dd>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  specGrpRef</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="specGrpRef">
    <xsl:choose>
      <xsl:when test="parent::specGrp">
        <dt/>
        <dd>
	  <xsl:text>« </xsl:text>
          <a href="{@target}">
	    <span class="label">
	      <xsl:call-template name="i18n"><xsl:with-param name="word">include</xsl:with-param></xsl:call-template> 
	      <xsl:text> </xsl:text>
	    <xsl:choose>
	      <xsl:when test="starts-with(@target,'#')">
		<xsl:for-each select="key('IDS',substring-after(@target,'#'))">
		  <xsl:number level="any"/>
		  <xsl:if test="@n">
		    <xsl:text>: </xsl:text><xsl:value-of select="@n"/>
		  </xsl:if>
		</xsl:for-each>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="@target"/>
	      </xsl:otherwise>
	    </xsl:choose>
	    </span>
	  </a>
	  <xsl:text> » </xsl:text>
	</dd>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <a href="{@target}">
	    <xsl:text>« </xsl:text>
	    <span class="label">
	      <xsl:call-template name="i18n">
		<xsl:with-param  name="word">include</xsl:with-param>
	      </xsl:call-template>
	      <xsl:text> </xsl:text>
	      <xsl:choose>
		<xsl:when test="starts-with(@target,'#')">
		  <xsl:for-each select="key('IDS',substring-after(@target,'#'))">
		    <xsl:number level="any"/>
		  <xsl:if test="@n">
		    <xsl:text>: </xsl:text><xsl:value-of select="@n"/>
		  </xsl:if>
		  </xsl:for-each>
		</xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="@target"/>
	      </xsl:otherwise>
	      </xsl:choose>
	    </span>
	  </a>
	  <xsl:text> » </xsl:text>
	</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  specList</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="specList">
    <ul class="specList">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  valDesc</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="valDesc">
    <tr>
      <td/>
      <td>
        <span class="label">
	  <xsl:call-template name="i18n">
	    <xsl:with-param name="word">Values</xsl:with-param>
	  </xsl:call-template>
	  <xsl:text>: </xsl:text>
	</span>
	<xsl:apply-templates/>
      </td>
    </tr>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  valList</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="valList" mode="contents">
    <xsl:choose>
      <xsl:when test="@type='semi'">
      <xsl:call-template name="i18n">
	<xsl:with-param name="word">Suggested values include</xsl:with-param>
      </xsl:call-template>:</xsl:when>
      <xsl:when test="@type='open'">
      <xsl:call-template name="i18n">
	<xsl:with-param name="word">Sample values include</xsl:with-param>
      </xsl:call-template>:</xsl:when>
      <xsl:when test="@type='closed'">
      <xsl:call-template name="i18n">
	<xsl:with-param name="word">Legal values are</xsl:with-param>
      </xsl:call-template>:</xsl:when>
      <xsl:otherwise>Values are:</xsl:otherwise>
    </xsl:choose>
    <table class="valList">
      <xsl:for-each select="valItem">
        <xsl:variable name="name">
          <xsl:choose>
            <xsl:when test="altIdent">
              <xsl:value-of select="altIdent"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@ident"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <tr>
          <td valign="top">
            <b>
              <xsl:value-of select="$name"/>
            </b>
          </td>
          <td valign="top">
            <xsl:value-of select="gloss"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  valList</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="valList">
    <xsl:choose>
      <xsl:when test="ancestor::elementSpec or ancestor::classSpec or ancestor::macroSpec">
        <tr>
          <td/>
          <td valign="top">
            <xsl:apply-templates select="." mode="contents"/>
          </td>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="contents"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  teix:egXML</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="teix:egXML">
    <pre>
      <xsl:apply-templates mode="verbatim"/>
    </pre>
  </xsl:template>
  
<xd:doc>
    <xd:short>[html] </xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="HTMLmakeTagsetInfo">
    <tr>
      <td valign="top">
        <span class="label">
	  <xsl:call-template name="i18n">
	    <xsl:with-param name="word">Module</xsl:with-param>
	  </xsl:call-template>
	</span>
      </td>
      <td colspan="2">
        <xsl:call-template name="makeTagsetInfo"/>
      </td>
    </tr>
  </xsl:template>
  
<xd:doc>
    <xd:short>[html] </xd:short>
    <xd:param name="grammar">grammar</xd:param>
    <xd:param name="content">content</xd:param>
    <xd:param name="element">element</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="bitOut">
    <xsl:param name="grammar"/>
    <xsl:param name="content"/>
    <xsl:param name="element">pre</xsl:param>
    <xsl:element name="{$element}">
      <xsl:attribute name="class">eg</xsl:attribute>
      <xsl:choose>
        <xsl:when test="$displayMode='rng'">
          <xsl:apply-templates select="exsl:node-set($content)/Wrapper/*" mode="verbatim"/>
        </xsl:when>
        <xsl:when test="$displayMode='rnc'">
          <xsl:call-template name="make-body-from-r-t-f">
            <xsl:with-param name="schema">
              <xsl:for-each select="exsl:node-set($content)/Wrapper">
                <xsl:call-template name="make-compact-schema"/>
              </xsl:for-each>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="exsl:node-set($content)/Wrapper">
            <xsl:apply-templates mode="literal"/>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  
<xd:doc>
    <xd:short>[html] </xd:short>
    <xd:param name="mode">mode</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="displayAttList">
    <xsl:param name="mode"/>
    <table class="attList">
      <tr>
        <td>
          <xsl:choose>
            <xsl:when test=".//attDef">
              <xsl:choose>
                <xsl:when test="count(../classes/memberOf)&gt;0">
                  <xsl:text>(</xsl:text>
		  <xsl:call-template name="i18n">
		    <xsl:with-param name="word">In addition to global  attributes and those inherited
		    from</xsl:with-param>
		  </xsl:call-template>
		  <xsl:text> </xsl:text>
                  <xsl:for-each select="..">
                    <xsl:call-template name="showAttClasses"/>
                  </xsl:for-each>
                  <xsl:text>)</xsl:text>
                </xsl:when>
                <xsl:otherwise>
		<xsl:text> (</xsl:text>
		<xsl:call-template name="i18n">
		    <xsl:with-param name="word">In addition to global attributes</xsl:with-param></xsl:call-template>
		<xsl:text>)</xsl:text>
	      </xsl:otherwise>
              </xsl:choose>
              <table>
                <xsl:choose>
                  <xsl:when test="$mode='all'">
                    <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates mode="summary"/>
                  </xsl:otherwise>
                </xsl:choose>
              </table>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="count(../classes/memberOf)&gt;0">
                  <xsl:call-template name="i18n">
		    <xsl:with-param name="word">Global attributes and those inherited from</xsl:with-param>
		  </xsl:call-template>
		  <xsl:text> </xsl:text>
                  <xsl:for-each select="..">
                    <xsl:call-template name="showAttClasses"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
		  <xsl:call-template name="i18n"><xsl:with-param name="word">Global attributes only</xsl:with-param></xsl:call-template>
	      </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </xsl:template>
  
<xd:doc>
    <xd:short>[html] </xd:short>
    <xd:param name="text">text</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="embolden">
    <xsl:param name="text"/>
    <b>
      <xsl:copy-of select="$text"/>
    </b>
  </xsl:template>
  
<xd:doc>
    <xd:short>[html] </xd:short>
    <xd:param name="text">text</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="italicize">
    <xsl:param name="text"/>
    <em>
      <xsl:copy-of select="$text"/>
    </em>
  </xsl:template>
  
<xd:doc>
    <xd:short>[html] make a link</xd:short>
    <xd:param name="class">class</xd:param>
    <xd:param name="id">id</xd:param>
    <xd:param name="name">name</xd:param>
    <xd:param name="text">text</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="makeLink">
    <xsl:param name="class"/>
    <xsl:param name="name"/>
    <xsl:param name="text"/>
    <a class="{$class}">
      <xsl:attribute name="href">
	<xsl:choose>
	  <xsl:when test="$splitLevel=-1">
	    <xsl:text>#</xsl:text>
	    <xsl:value-of select="$name"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>ref-</xsl:text>
	    <xsl:value-of select="$name"/>
	    <xsl:text>.html</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <xsl:copy-of select="$text"/>
    </a>
  </xsl:template>
  
<xd:doc>
    <xd:short>[html] Document an element, macro, or class</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="refdoc">
  <xsl:if test="$verbose='true'">
    <xsl:message>   refdoc for <xsl:value-of select="name(.)"/> -  <xsl:value-of select="@ident"/>     </xsl:message>
  </xsl:if>
  <xsl:variable name="objectname">
    <xsl:choose>
      <xsl:when test="altIdent">
	<xsl:value-of select="altIdent"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@ident"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="local-name(.)='elementSpec'">
	<xsl:text>&lt;</xsl:text>
	<xsl:value-of select="$objectname"/>
	<xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$objectname"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$splitLevel=-1">
	<h2><a name="{@ident}"/><xsl:value-of select="$name"/></h2>
         <table class="wovenodd" border="1">
	  <xsl:apply-templates select="." mode="weavebody"/>
	</table>

    </xsl:when>
    <xsl:otherwise>
      [<a href="ref-{@ident}.html">
      <xsl:value-of select="$name"/></a>]
      <xsl:variable name="BaseFile">
	<xsl:value-of select="$masterFile"/>
	<xsl:if test="ancestor::teiCorpus.2">
	<xsl:text>-</xsl:text>
	<xsl:choose>
	  <xsl:when test="@id">
	    <xsl:value-of select="@id"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:number/>
	  </xsl:otherwise>
	</xsl:choose>
	</xsl:if>
      </xsl:variable>
      <xsl:call-template name="outputChunk">
	<xsl:with-param name="ident">
	  <xsl:text>ref-</xsl:text>
	  <xsl:value-of select="@ident"/>
	</xsl:with-param>
	<xsl:with-param name="content">
	  <html>
	    <xsl:comment>THIS IS A GENERATED FILE. DO NOT EDIT (7) </xsl:comment>
	    <head>
	      <title>
	      <xsl:value-of select="$name"/>
	      </title>
	      <xsl:if test="not($cssFile = '')">
		<link rel="stylesheet" type="text/css" href="{$cssFile}"/>
	      </xsl:if>
	    </head>
	    <body>
	      <xsl:call-template name="bodyHook"/>
	      <a name="TOP"/>
	      <div id="hdr">
		<xsl:call-template name="stdheader">
		  <xsl:with-param name="title">
		    <xsl:value-of select="$name"/>
		  </xsl:with-param>
		</xsl:call-template>
	      </div>
	      <p>
		<a name="{@ident}"/>
		<table class="wovenodd" border="1">
		  <xsl:apply-templates select="." mode="weavebody"/>
		</table>
	      </p>
	    </body>
	  </html>
	</xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
<xd:doc>
    <xd:short>[html] </xd:short>
    <xd:param name="text">text</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="ttembolden">
    <xsl:param name="text"/>
    <b>
      <tt>
        <xsl:copy-of select="$text"/>
      </tt>
    </b>
  </xsl:template>
  
<xd:doc>
    <xd:short>[html] </xd:short>
    <xd:param name="text">text</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="typewriter">
    <xsl:param name="text"/>
    <tt>
      <xsl:copy-of select="$text"/>
    </tt>
  </xsl:template>
  
<xd:doc>
    <xd:short>[html] </xd:short>
    <xd:param name="text">text</xd:param>
    <xd:param name="startnewline">startnewline</xd:param>
    <xd:param name="autowrap">autowrap</xd:param>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="verbatim">
    <xsl:param name="text"/>
    <xsl:param name="startnewline">false</xsl:param>
    <xsl:param name="autowrap">true</xsl:param>
    <pre class="eg">
      <xsl:if test="$startnewline='true'">
        <xsl:text>&#10;</xsl:text>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$autowrap='false'">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
	  <xsl:call-template name="nextLine">
	    <xsl:with-param name="text">
	    <xsl:value-of select="$text"/>
	    </xsl:with-param>
	  </xsl:call-template>
<!--          <xsl:variable name="lines" select="estr:tokenize($text,'&#10;')"/>
          <xsl:apply-templates select="$lines[1]" mode="normalline"/>
-->
        </xsl:otherwise>
      </xsl:choose>
    </pre>
  </xsl:template>

  <xsl:template name="nextLine">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text,'&#10;')">
	<xsl:value-of select="substring-before($text,'&#10;')"/>
	<xsl:call-template name="nextLine">
	  <xsl:with-param name="text">
	    <xsl:value-of select="substring-after($text,'&#10;')"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>