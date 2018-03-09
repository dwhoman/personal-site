<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:x="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="x">
  <xsl:output method="html" media-type="text/xml" doctype-public="html" encoding="utf-8" />
  
  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="head">
    <head>
      <xsl:apply-templates select="*" />
    </head>
  </xsl:template>
  
  <xsl:template match="div[@class = 'category']">
    <xsl:variable name="name-sort-tip">
      Sort by title.
    </xsl:variable>
    <xsl:variable name="publish-sort-tip">
      Sort by publication date.
    </xsl:variable>
    <xsl:variable name="update-sort-tip">
      Sort by last update date.
    </xsl:variable>
    <xsl:variable name="id" select="preceding-sibling::h2[1]/@id" />
    <div>
      <xsl:copy-of select="@*" />
      <xsl:if test="count(table/tbody) &gt; 1">
	<xsl:attribute name="class">
	  <xsl:text>multiple </xsl:text><xsl:value-of select="@class" />
	</xsl:attribute>
      </xsl:if>
      <input title="{$name-sort-tip}" id="{$id}-name-sort" class="name-sort category-sort" name="{$id}-sort" type="radio" checked="checked" />
      <label title="{$name-sort-tip}" for="{$id}-name-sort" class="name-sort category-sort">Article</label>
      <input title="{$publish-sort-tip}" id="{$id}-publish-sort" class="publish-sort category-sort" name="{$id}-sort" type="radio" />
      <label title="{$publish-sort-tip}" for="{$id}-publish-sort" class="publish-sort category-sort">Published</label>
      <input title="{$update-sort-tip}" id="{$id}-update-sort" class="update-sort category-sort" name="{$id}-sort" type="radio" />
      <label title="{$update-sort-tip}" for="{$id}-update-sort" class="update-sort category-sort">Updated</label>
      <xsl:apply-templates select="table" mode="new" />
    </div>
  </xsl:template>
  
  <xsl:template match="table" mode="new">
    <table class='index'>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="*" />
      
      <xsl:for-each select="tbody">
	<xsl:sort select="tr[1]/td[2]/time/@data-unix" order="descending" />
	<xsl:apply-templates select="." mode="new">
	  <xsl:with-param name="tbody">publish-sort</xsl:with-param>
	</xsl:apply-templates>
      </xsl:for-each>
      
      <xsl:for-each select="tbody">
	<xsl:sort select="tr[1]/td[3]/time/@data-unix" order="descending" />
	<xsl:apply-templates select="." mode="new">
	  <xsl:with-param name="tbody">update-sort</xsl:with-param>
	</xsl:apply-templates>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="tbody" mode="new">
    <xsl:param name="tbody" />
    <tbody class="{$tbody}">
      <xsl:apply-templates select="*" />
    </tbody>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
