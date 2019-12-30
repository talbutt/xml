<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:r="http://www.christmas-baking.com/recipeml.dtd"
	xmlns:x="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="r x xs"
	xmlns="http://www.w3.org/1999/xhtml"
	version="2.0">
	<xsl:output method="html"
	            indent="yes"
	            omit-xml-declaration="yes"
                encoding="utf-8" />

                <!--

	            doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
 -->

<!--
   - Create the an html page for each recipe node. Right now, we assume one
   - recipe per file. With XSLT2, we'll be able to split multiple recipes
   - out of one large file.
   -
   - There's a very basic structure:
   - the html head, including title and meta tags
   - the page header, the same for every page on www.christmas-baking.com
   - the history (from the description)
   - ingredients
   - directions
   - common footer
  -->
	<xsl:template match="/r:recipeml/r:recipe">
	<xsl:result-document href="{@id}.html">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
<html lang="en">
<head>
	<xsl:call-template name="head" />
</head>

<body>
	<xsl:call-template name="header" />

  <main>

  <article id="recipePage" class="container-fluid">

	<xsl:apply-templates select="r:ingredients" />

  <section id="recipe">
    <xsl:apply-templates select="r:directions" />

    <xsl:call-template name="meta-data" />
  </section>

	<xsl:apply-templates select="r:description" />

  </article>

  </main>

	<xsl:call-template name="footer" />

</body>
</html>

	</xsl:result-document>
	</xsl:template>

<!--
   - HTML head: title, meta keywords, stylesheets, javascript
   -
   - This is very site-specific. The CSS will do the actual styling of the
   - pages.
  -->
	<xsl:template name="head">
		<title>
			<xsl:value-of select="r:head/r:title" />: <xsl:value-of select="r:head/r:categories/r:cat[@class='main']" />: Christmas Baking with SusieJ
		</title>
    <meta charset="utf-8" />

		<!-- Create a meta tag for keywords, using the categories and
			 subtitle. -->
		<meta>
			<xsl:attribute name="name">keywords</xsl:attribute>
			<xsl:attribute name="content">
				<xsl:for-each select="r:head/r:categories/r:cat">
					<xsl:value-of select="." />
					<xsl:text>, </xsl:text>
				</xsl:for-each>

				<!-- if doesn't change the meaning of "." -->
				<xsl:if test="r:head/r:subtitle">
					<xsl:value-of select="r:head/r:subtitle" />
					<xsl:text>, </xsl:text>
				</xsl:if>
				<!-- Standard keywords -->
				<xsl:value-of select="normalize-space ('Christmas, baking, recipe')" />
			</xsl:attribute>
		</meta>
    <meta name="viewport" content="initial-scale=1" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <!--[if IE]>
      <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <link rel="stylesheet" href="../../public_html/styles/advent.css" type="text/css" />

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
    <header>
      <h1><xsl:if test="r:meta[@name='DC.Creator']">
          <xsl:value-of select="r:meta[@name='DC.Creator']/@content" /><xsl:text>'s </xsl:text>
      </xsl:if>
      <xsl:value-of select="r:head/r:title" />
      <xsl:if test="r:head/r:subtitle">
          <xsl:text> </xsl:text><span class="nowrap">(<xsl:value-of select="r:head/r:subtitle" />)</span><xsl:text> </xsl:text>
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

	<xsl:template name="meta-data">
    <ul id="meta" >
    <xsl:if test="r:head/r:categories/r:cat[@class='main']">
        <li id="category">
            <a href="categories.html" class="category">Category:</a>
            <xsl:text> </xsl:text><a href="categories.html#{r:head/r:categories/r:cat[@class='main']}"><xsl:value-of select="r:head/r:categories/r:cat[@class='main']" /></a><xsl:text> </xsl:text>
        </li>
    </xsl:if>

    <xsl:if test="r:head/r:categories/r:cat[@class='region']">
        <li id="region">
            <a href="regions.html" class="category">Region:</a>
            <xsl:for-each select="r:head/r:categories/r:cat[@class='region']">
            <xsl:text> </xsl:text><a href="regions.html#{.}"><xsl:value-of select="." /></a>
            </xsl:for-each>
        </li>
    </xsl:if>

    <xsl:if test="r:head/r:categories/r:cat[@class='diet']">
        <li id="diet">
            <a href="diets.html" class="category">Special diet:</a>
            <xsl:for-each select="r:head/r:categories/r:cat[@class='diet']">
            <xsl:text> </xsl:text><a href="diets.html#{.}"><xsl:value-of select="." /></a>
            </xsl:for-each>
        </li>
    </xsl:if>
    </ul>
	</xsl:template>

<!--
   - Standard footer
   -
   - Non-content links (about, contact)
   - COPYRIGHT
   - Cafe Press link
   - The only data pulled from the XML file is the date from the meta tag
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
      <p id="copyright">Copyright 1995-<xsl:value-of select="format-date (current-date(), '[Y]')" /> Susan J. Talbutt, all rights reserved. Please remember that typing and testing these recipes is a lot of work, as is creating and maintaining the web site. Links are always welcome. Please bake up a storm and share the results and the recipe with your friends! All other rights reserved.
      <!-- If a meta tag (on the recipe) is a DC.Date type, print out the contents of the content
           attribute, formatted as a human date. -->
      <xsl:if test="r:meta[@name='DC.Date']">Last updated <xsl:value-of select="format-date (xs:date (r:meta[@name='DC.Date']/@content), '[FNn] [MNn] [D], [Y]')" /></xsl:if>
      </p>
    </footer>
	</xsl:template>

	<xsl:template match="r:ingredients">
	<section id="ingredientsAndEquipment">
    <h2>Measurements
		<xsl:choose>
			<xsl:when test="../@system = 'US'">
				<xsl:choose>
					<xsl:when test="substring (../@id, string-length(../@id) - 1, 2) = '_a'">
					<span id="alt_measure"><a href="{substring (../@id, 0, string-length(../@id) - 1)}.html">[metric]</a> </span>
					</xsl:when>
					<xsl:otherwise>
					<span id="alt_measure"><a href="{../@id}_m.html">[metric]</a> </span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="../@system = 'metric'">
				<xsl:choose>
					<xsl:when test="substring (../@id, string-length(../@id) - 1, 2) = '_m'">
					<span id="alt_measure"><a href="{substring (../@id, 0, string-length(../@id) - 1)}.html">[American]</a> </span>
					</xsl:when>
					<xsl:otherwise>
					<span id="alt_measure"><a href="{../@id}_a.html">[American]</a> </span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="substring (../@id, string-length(../@id) - 1, 2) = '_a'">
					<span id="alt_measure"><a href="{substring (../@id, 0, string-length(../@id) - 1)}.html">[metric]</a> </span>
					</xsl:when>
					<xsl:otherwise>
					<span id="alt_measure"><a href="{../@id}_m.html">[metric]</a> </span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</h2>
	<xsl:for-each select="r:ing-div">
		<xsl:apply-templates select="r:title|r:note" />
		<ul>
			<xsl:apply-templates select="r:ing" />
		</ul>
	</xsl:for-each>
	</section>
	</xsl:template>

	<!-- Ingredients in directions. Ingredients get marked up in directions
	     so that we can covert to metric. -->
	<xsl:template match="r:ing">
		<xsl:apply-templates select="r:amt" />
		<xsl:apply-templates select="r:prep" />
		<xsl:apply-templates select="r:item" />
		<xsl:text> </xsl:text>
		<xsl:if test="@optional = 'yes'">
			<xsl:text> (optional) </xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- Individual ingredients and alternate ingredients have the
	     same format (just different levels). A more specific rule
	     for ing/r:alt-ing will catch the beginning of an alternate
	     ingredient list -->
	<xsl:template match="r:ingredients/*/r:ing|r:alt-ing">
		<xsl:variable name="alternatives" as="xs:integer" select="count (r:alt-ing)" />
		<xsl:choose>
			<xsl:when test="r:alt-ing">
				<li><xsl:choose>
					<xsl:when test="$alternatives = 2"><xsl:text>Either</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>One of</xsl:text></xsl:otherwise>
					</xsl:choose><xsl:text>:</xsl:text>
					<xsl:if test="@optional = 'yes'">
						<xsl:text> (optional) </xsl:text>
					</xsl:if>
				</li>
				<ul>
					<xsl:apply-templates />
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<li>
					<xsl:apply-templates select="r:amt" />
					<xsl:apply-templates select="r:item" />
					<xsl:apply-templates select="r:prep" />
					<xsl:if test="@optional = 'yes'">
						<xsl:text> (optional) </xsl:text>
					</xsl:if>
					<xsl:value-of select="r:ing-note" />
				</li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Amounts -->
	<xsl:template match="r:amt">
		<xsl:if test="r:qty">
			<xsl:value-of select="r:qty" />
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:if test="r:range">
			<xsl:value-of select="r:range/r:q1" />
			<xsl:text> to </xsl:text>
			<xsl:value-of select="r:range/r:q2" />
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:if test="r:unit">
			<xsl:value-of select="r:unit" />
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="r:prep">
		<xsl:text>, </xsl:text>
		<xsl:value-of select="." />
	</xsl:template>

	<!-- The History section -->
	<xsl:template match="r:description">
        <sidebar id="history">
			<xsl:apply-templates />
        </sidebar>
	</xsl:template>

	<!-- The Directions section -->
	<xsl:template match="r:directions">
		<xsl:apply-templates />
	</xsl:template>

	<!-- Within steps there can be in-line elements -->
	<xsl:template match="r:step">
		<p><xsl:apply-templates /></p>
	</xsl:template>

	<!-- Block-level elements used in multiple places -->
	<xsl:template match="r:note[@type='variation']">
		<p class="variation"><strong><xsl:value-of select="@title" />: </strong> <xsl:apply-templates /></p>
	</xsl:template>

	<xsl:template match="r:note">
		<p class="note"><strong>Note: </strong> <xsl:value-of select="."/></p>
	</xsl:template>

	<xsl:template match="r:title">
		<h3><xsl:apply-templates /></h3>
	</xsl:template>

	<xsl:template match="r:tempunit">
		<xsl:text> degrees </xsl:text><xsl:value-of select="@unit" />
	</xsl:template>

	<!--
	     XHTML elements included in the recipeML file. The namespace prefix
	     MUST be x: Got that?
	  -->

	<xsl:template match="x:*">
	  <xsl:element name="{local-name()}">
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates/>
	  </xsl:element>
	</xsl:template>

</xsl:stylesheet>
