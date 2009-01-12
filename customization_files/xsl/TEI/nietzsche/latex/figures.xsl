<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  xmlns:xd="http://www.pnp-software.com/XSLTdoc"
  xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
  xmlns:edate="http://exslt.org/dates-and-times"
  xmlns:estr="http://exslt.org/strings"
  xmlns:exsl="http://exslt.org/common"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  extension-element-prefixes="exsl estr edate" 
  exclude-result-prefixes="xd exsl estr edate a rng tei teix" 
  version="1.0">
  
<xd:doc type="stylesheet">
    <xd:short>
    TEI stylesheet
    dealing  with elements from the
      figures module, making LaTeX output.
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
    <xd:cvsId>$Id: figures.xsl,v 1.1 2006/02/16 15:31:45 giacomi Exp $</xd:cvsId>
    <xd:copyright>2005, TEI Consortium</xd:copyright>
  </xd:doc>
  
<xd:doc>
    <xd:short>Process elements  cell</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="cell">
  <xsl:if test="preceding-sibling::cell">\tabcellsep </xsl:if>
  <xsl:choose>
    <xsl:when test="@role='label'">
      <xsl:text>\Panel{</xsl:text>
        <xsl:if test="starts-with(normalize-space(.),'[')"><xsl:text>{}</xsl:text></xsl:if><xsl:apply-templates/>
      <xsl:text>}{label}{</xsl:text>
      <xsl:choose>
	<xsl:when test="@cols"><xsl:value-of select="@cols"/>
	</xsl:when>
	<xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
      <xsl:text>}{</xsl:text>
      <xsl:choose>
	<xsl:when test="@align='right'">r</xsl:when>
	<xsl:when test="@align='centre'">c</xsl:when>
	<xsl:when test="@align='center'">c</xsl:when>
	<xsl:when test="@align='left'">l</xsl:when>
	<xsl:otherwise>l</xsl:otherwise>
      </xsl:choose>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:when test="@cols &gt; 1">
      <xsl:text>\multicolumn{</xsl:text>
      <xsl:value-of select="@cols"/>
      <xsl:text>}{c}{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
        <xsl:if test="starts-with(normalize-space(.),'[')"><xsl:text>{}</xsl:text></xsl:if>
	<xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  figDesc</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="figDesc"/>
  
<xd:doc>
    <xd:short>Process elements  figure</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="figure">
    <xsl:call-template name="makeFigureStart"/>
    <xsl:choose>
      <xsl:when test="@url or @entity">
	<xsl:call-template name="makePic"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="makeFigureEnd"/>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  graphic</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="graphic">
    <xsl:call-template name="makePic"/>
  </xsl:template>
  
<xd:doc>
    <xd:short>Process elements  row</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="row">
  <xsl:if test="@role='label'">\rowcolor{label}</xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::row">
    <xsl:text>\\</xsl:text>
    <xsl:if test="@role='label'">\hline </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  table</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="table" mode="xref">
<xsl:text>the table on p. \pageref{</xsl:text>
<xsl:value-of select="@id"/>
<xsl:text>}</xsl:text>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  table</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="table">
<xsl:if test="@id">\label{<xsl:value-of select="@id"/>}</xsl:if>
\par  
<xsl:choose>
<xsl:when test="ancestor::table">
\begin{tabular}
<xsl:call-template name="makeTable"/>
\end{tabular}
</xsl:when>
<xsl:otherwise>
\begin{longtable}
<xsl:call-template name="makeTable"/>
\end{longtable}
\par
</xsl:otherwise>
</xsl:choose>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  table[@type='display']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="table[@type='display']" mode="xref">
<xsl:text>Table </xsl:text>
<xsl:number level="any" count="table[@type='display']"/>
</xsl:template>
  
<xd:doc>
    <xd:short>Process elements  table[@type='display']</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template match="table[@type='display']">
  \begin{table}
  \caption{<xsl:apply-templates select="head" mode="ok"/>}
  <xsl:if test="@id">\hypertarget{<xsl:value-of select="@id"/>}{}</xsl:if>
  \begin{center}
  \begin{small}
  \begin{tabular}
  <xsl:call-template name="makeTable"/>
  \end{tabular}
  \end{small}
  \end{center}
  \end{table}
</xsl:template>
  
<xd:doc>
    <xd:short>[latex] Make figure (start)</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="makeFigureStart">
  <xsl:choose>
    <xsl:when test="@type='display' or head or p">
      <xsl:text>\begin{figure}[htbp]
      </xsl:text>
    </xsl:when>
    <xsl:when test="@rend='centre'">
      <xsl:text>\par\centerline{</xsl:text>
    </xsl:when>
    <xsl:otherwise>\noindent</xsl:otherwise>
  </xsl:choose>
  </xsl:template>

<xd:doc>
    <xd:short>[latex] Make figure (end)</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="makeFigureEnd">
  <xsl:choose>
    <xsl:when test="@type='display' or head or p">
      <xsl:text>
	\caption{</xsl:text><xsl:value-of select="head"/>
      <xsl:text>}</xsl:text>
      <xsl:if test="@id">\hypertarget{<xsl:value-of select="@id"/>}{}</xsl:if>
      <xsl:text>\end{figure}
      </xsl:text>
    </xsl:when>
    <xsl:when test="@rend='centre'">
      <xsl:text>}\par</xsl:text>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xd:doc>
    <xd:short>[latex] Make picture</xd:short>
    <xd:detail>&#160;</xd:detail>
  </xd:doc>
  <xsl:template name="makePic">
  <xsl:if test="@id">\hypertarget{<xsl:value-of select="@id"/>}{}</xsl:if>
  <xsl:if test="@rend='centre'">
    <xsl:text>\centerline{</xsl:text>
  </xsl:if>
  <xsl:text>\includegraphics[</xsl:text>
  <xsl:call-template name="graphicsAttributes">
    <xsl:with-param name="mode">latex</xsl:with-param>
  </xsl:call-template>
  <xsl:text>]{</xsl:text>
  <xsl:choose>
    <xsl:when test="$realFigures='true'">
      <xsl:choose>
	<xsl:when test="@url">
	  <xsl:value-of select="@url"/>
	</xsl:when>
	<xsl:when test="@entity">
	  <xsl:value-of select="unparsed-entity-uri(@entity)"/>
	</xsl:when>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="c">
	<xsl:for-each select="ancestor-or-self::figure[1]">
	  <xsl:number level="any"/>
	</xsl:for-each>
      </xsl:variable>
      <xsl:text>FIG</xsl:text>
      <xsl:value-of select="$c+1000"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>}</xsl:text>
  <xsl:if test="@rend='centre'">
    <xsl:text>}</xsl:text>
  </xsl:if>
</xsl:template>



<xd:doc>
    <xd:short>[latex] </xd:short>
    <xd:detail>&#160;</xd:detail>
</xd:doc>
<xsl:template name="makeTable">
  <xsl:variable name="r">
    <xsl:value-of select="@rend"/>
  </xsl:variable>
  <xsl:text>{</xsl:text>
  <xsl:if test="$r='rules'">|</xsl:if>
  <xsl:choose>
    <xsl:when test="@preamble">
      <xsl:value-of select="@preamble"/>
    </xsl:when>
    <xsl:when test="function-available('exsl:node-set')">
      <xsl:call-template name="makePreamble-complex">
	<xsl:with-param name="r" select="$r"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="makePreamble-simple">
	<xsl:with-param name="r" select="$r"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>}&#10;</xsl:text>
  <xsl:if test="not(ancestor::table or @type='display')">\hline\endfoot\hline\endlastfoot </xsl:if>
  <xsl:choose>
    <xsl:when test="head and not(@type='display')">
      <xsl:if test="not(ancestor::table)">
	<xsl:text>\endfirsthead </xsl:text>
	<xsl:text>\multicolumn{</xsl:text>
	<xsl:value-of select="count(row[1]/cell)"/>
	<xsl:text>}{c}{</xsl:text>
	<xsl:apply-templates select="head" mode="ok"/>
	<xsl:text>(cont.)}\\\hline \endhead </xsl:text>
      </xsl:if>
      <xsl:text>\caption{</xsl:text>
      <xsl:apply-templates select="head" mode="ok"/>
      <xsl:text>}\\ </xsl:text>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="$r='rules'">\hline </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="$r='rules'">
    <xsl:text>\\ \hline </xsl:text>
  </xsl:if>
</xsl:template>

<xd:doc>
    <xd:short>[latex] </xd:short>
    <xd:detail>&#160;</xd:detail>
</xd:doc>
<xsl:template name="makePreamble-complex">
<xsl:param name="r"/>
  <xsl:variable name="tds">
    <xsl:for-each select=".//cell">
      <xsl:variable name="stuff">
	<xsl:apply-templates/>
      </xsl:variable>
      <cell>
	<xsl:attribute name="col"><xsl:number/></xsl:attribute>
	<xsl:value-of select="string-length($stuff)"/>
      </cell>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="total">
    <xsl:value-of select="sum(exsl:node-set($tds)/cell)"/>
  </xsl:variable>
  <xsl:for-each select="exsl:node-set($tds)/cell">
    <xsl:sort select="@col" data-type="number"/>
    <xsl:variable name="c" select="@col"/>
    <xsl:if test="not(preceding-sibling::cell[$c=@col])">
      <xsl:variable name="len">
	<xsl:value-of select="sum(following-sibling::cell[$c=@col]) + current()"/>
      </xsl:variable>
      <xsl:text>P{</xsl:text>
 <xsl:value-of select="($len div $total) * 0.95"/>
 <xsl:text>\textwidth}</xsl:text>
 <xsl:if test="$r='rules'">|</xsl:if>
    </xsl:if>
  </xsl:for-each>
</xsl:template>


<xd:doc>
    <xd:short>[latex] </xd:short>
    <xd:detail>&#160;</xd:detail>
</xd:doc>
<xsl:template name="makePreamble-simple">
<xsl:param name="r"/>
  <xsl:for-each select="row[1]/cell">
    <xsl:text>l</xsl:text>
    <xsl:if test="$r='rules'">|</xsl:if>
  </xsl:for-each>
</xsl:template>



</xsl:stylesheet>