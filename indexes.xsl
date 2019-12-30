<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:r="http://www.christmas-baking.com/recipeml.dtd"
	xmlns:x="http://www.w3.org/1999/xhtml"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xdt="http://www.w3.org/2005/04/xpath-datatypes"
	exclude-result-prefixes="r x xs"
	xmlns="http://www.w3.org/1999/xhtml"
	version="2.0">
	<xsl:output method="xhtml"
	            indent="yes"
	            doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />

	<xsl:template match="/" >
	<xsl:apply-templates mode="category" />
	<xsl:apply-templates mode="region" />
	<xsl:apply-templates mode="diet" />
	<!-- Use variables for the types of node to find, and the filename & header
	-->
	</xsl:template>

	<!--
		Main Category grouping: breads, cakes, etc.
	 -->
	<xsl:template match="r:recipeml" mode="category">
	<xsl:result-document href="categories.html" >
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
		<xsl:call-template name="htmlHead" />
<body>
  <xsl:call-template name="header">
    <xsl:with-param name="category" select="'main'" as="xs:string" />
  </xsl:call-template>

	<main>
	<article class="container-fluid">
    <xsl:call-template name="categoryListing">
      <xsl:with-param name="category" select="'main'" as="xs:string" />
    </xsl:call-template>
	</article>
	</main>

	<xsl:call-template name="footer" />

</body>
</html>

	</xsl:result-document>
	</xsl:template>


	<!--
		Region grouping
	 -->
	<xsl:template match="r:recipeml" mode="region">
		<xsl:call-template name="indexPage">
      <xsl:with-param name="category" select="'region'" as="xs:string" />
    </xsl:call-template>
	</xsl:template>


	<!--
		Special diets: egg-free, dairy-free
	 -->
	<xsl:template match="r:recipeml" mode="diet">
		<xsl:call-template name="indexPage">
      <xsl:with-param name="category" select="'diet'" as="xs:string" />
    </xsl:call-template>
	</xsl:template>



	<!--
	Head section of the html file
	 -->
	<xsl:template name="htmlHead">
		<title>Christmas Baking with SusieJ: Recipes</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="initial-scale=1" />

    <!--[if IE]>
      <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    <link rel="stylesheet" href="/styles/advent.css" type="text/css" />

    <script src="/scripts/jquery.js"></script>
    <script src="/scripts/socialLinks.js"></script>

    <link rel="shortcut icon" href="/images/favicon.ico" />
    <link rel="apple-touch-icon" href="/images/apple-touch-icon.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="/images/apple-touch-icon-72x72.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="/images/apple-touch-icon-114x114.png" />
	</xsl:template>

<!--
   - Site-specific header.
   -
   - Header for every page on www.christmas-baking.com. CSS determines the
   - look and feel. This includes a page title and top-level site navigation.
   -
   - Some of the info is pulled from the meta tags. Unfortunately, the DTD
   - defines the meta tags for the file, but not for individual recipes.
   - I use both a source (who entered the info into the web form) and creator
   - (who came up with the recipe).
   -
   - I use the subtitle node as an alternate name, although this might be
   - better represented in meta tags.
  -->
	<xsl:template name="header">
    <xsl:param name="category" as="xs:string" required="no" />
    <header>
      <h1>Recipes
      <xsl:if test="$category != 'main'">
      by <xsl:value-of select="$category" />
      </xsl:if>
      <span class="subtitle">Christmas Baking with SusieJ</span></h1>
      <ul class="nav" role="navigation">
        <li><a href="/cgi-bin/advent.cgi">Advent calendar</a></li>
        <li><a href="/sources.html">Sources &amp; Resources</a></li>
        <li class="dropdown" id="baking101"><a class="dropdown-toggle" data-toggle="dropdown" href="/baking101/">Baking 101</a>
          <ul class="dropdown-menu">
            <li><a href="/baking101/hints.html">Beginning</a></li>
            <li><a href="/baking101/hints2.html">Intermediate</a></li>
            <li><a href="/baking101/allergies.html">Allergies</a></li>
            <li><a href="/baking101/bakingBig.html">Going big</a></li>
            <li><a href="/baking101/parchmentCircles.html">Parchment circles</a></li>
          </ul>
        </li>
        <li><a href="/guestbook.html">Disasters</a></li>
        <li><a href="/other.html">Christmas</a></li>
        <li><a href="/itsAllAboutTheFood/">Essays</a></li>
      </ul>
    </header>
	</xsl:template>

  <xsl:template name="indexPage">
    <xsl:param name="category" as="xs:string" required="yes" />
    <xsl:result-document href="{$category}s.html" >
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
		<xsl:call-template name="htmlHead" />
<body>
		<xsl:call-template name="header">
      <xsl:with-param name="category" select="$category" as="xs:string" />
    </xsl:call-template>

	<main>
	<article class="container-fluid">
    <xsl:call-template name="categoryListing">
        <xsl:with-param name="category" select="$category" as="xs:string" />
    </xsl:call-template>
	</article>
	</main>

	<xsl:call-template name="footer" />
</body>
</html>
	</xsl:result-document>
  </xsl:template>


    <xsl:template name="categoryListing">
        <xsl:param name="category" as="xs:string" required="yes" />
	    <xsl:variable name="oneYearAgo" select="current-date() - xdt:yearMonthDuration('P1Y1M')" />
        <xsl:for-each-group select="r:recipe" group-by="r:head/r:categories/r:cat[@class=$category]">
            <xsl:sort select="current-grouping-key()" />

            <h2><a name="{current-grouping-key()}"></a><xsl:value-of select="current-grouping-key()" /></h2>

            <ul>
            <!--
            Title/subtitle sort
             -->
            <xsl:for-each select="current-group()" >
                <xsl:sort select="r:head/r:title" />
                <xsl:variable name="listItemClass">
                  <xsl:choose>
                    <xsl:when test="xs:date (r:meta[@name='DC.Date']/@content) >= $oneYearAgo">new</xsl:when>
                    <xsl:otherwise>old</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <li class="{$listItemClass}"><a href="{@id}.html"><xsl:value-of select="r:head/r:title" /></a>
                <xsl:if test="r:head/r:source">
                    from <xsl:value-of select="r:head/r:source" />
                </xsl:if>
                </li>
            </xsl:for-each>
            </ul>
        </xsl:for-each-group>
    </xsl:template>

<!--
   - Standard footer
   -
   - Non-content links (about, contact)
   - COPYRIGHT
   - Cafe Press link
   - Last updated date
  -->
	<xsl:template name="footer">
    <footer>
      <ul id="bottomNav" role="navigation">
        <li><a href="/about.html">About</a></li>
        <li><a href="/submit.html">Share a Recipe</a></li>
        <li><a href="/index.xml">RSS</a></li>
        <li><a href="http://twitter.com/ChristmasBaking">@ChristmasBaking</a></li>
        <li><a href="http://www.cafepress.com/xmasbaking">Stuff</a></li>
        <li><a href="http://www.cafepress.com/xmsbkgspritz">More stuff</a></li>

        <li id="linksToShareParent"></li>
      </ul>
      <p id="copyright">Copyright 1995-<xsl:value-of select="format-date (current-date(), '[Y]')" /> Susan J. Talbutt, all rights reserved. Please remember that typing and testing these recipes is a lot of work, as is creating and maintaining the web site. Links are always welcome. Please bake up a storm and share the results and the recipe with your friends! All other rights reserved. Last updated <xsl:value-of select="format-date (current-date(), '[FNn] [MNn] [D], [Y]')" /></p>
    </footer>
	</xsl:template>

	<xsl:template match="r:head/r:title|r:head/r:subtitle">
		<li>
		<xsl:value-of select="." />
		</li>
	</xsl:template>

</xsl:stylesheet>
