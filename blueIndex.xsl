<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:r="http://www.christmas-baking.com/recipeml.dtd"
	xmlns:x="http://www.w3.org/1999/xhtml"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
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
<html xmlns="http://www.w3.org/1999/xhtml">
		<xsl:call-template name="htmlHead" />
<body>
		<xsl:call-template name="header" />
	
	<xsl:for-each-group select="r:recipe" group-by="r:head/r:categories/r:cat[@class='main']">
		<xsl:sort select="current-grouping-key()" />

		<h2><a name="{current-grouping-key()}"></a><xsl:value-of select="current-grouping-key()" /></h2>

		<ul>
		<!-- 
		Title/subtitle sort
		 -->
		<xsl:for-each select="current-group()" >
			<xsl:sort select="r:head/r:title" />
			<li><a href="{@id}.html"><xsl:value-of select="r:head/r:title" /></a>
			<xsl:if test="r:head/r:source">
				<xsl:text> from </xsl:text>
				<xsl:value-of select="r:head/r:source" />
			</xsl:if>
			</li>
		</xsl:for-each>
		</ul>
	</xsl:for-each-group> <!-- Main Category -->
	
	<xsl:call-template name="footer" />

</body>
</html>

	</xsl:result-document>
	</xsl:template>


	<!-- 
		Region grouping
	 -->
	<xsl:template match="r:recipeml" mode="region">
		<xsl:result-document href="regions.html" >
<html xmlns="http://www.w3.org/1999/xhtml">
		<xsl:call-template name="htmlHead" />
<body>
		<xsl:call-template name="header" />
	
	<xsl:for-each-group select="r:recipe" group-by="r:head/r:categories/r:cat[@class='region']">
		<xsl:sort select="current-grouping-key()" />

		<h2><a name="{current-grouping-key()}"></a><xsl:value-of select="current-grouping-key()" /></h2>

		<ul>
		<!-- 
		Title/subtitle sort
		 -->
		<xsl:for-each select="current-group()" >
			<xsl:sort select="r:head/r:title" />
			<li><a href="{@id}.html"><xsl:value-of select="r:head/r:title" /></a>
			<xsl:if test="r:head/r:source">
				<xsl:text> from </xsl:text>
				<xsl:value-of select="r:head/r:source" />
			</xsl:if>
			</li>
		</xsl:for-each>
		</ul>
	</xsl:for-each-group> <!-- Region -->
	
	<xsl:call-template name="footer" />

</body>
</html>

	</xsl:result-document>
	</xsl:template>


	<!-- 
		Special diets: egg-free, dairy-free
	 -->
	<xsl:template match="r:recipeml" mode="diet">
		<xsl:result-document href="diets.html" >
<html xmlns="http://www.w3.org/1999/xhtml">
		<xsl:call-template name="htmlHead" />
<body>
		<xsl:call-template name="header" />
	
	<xsl:for-each-group select="r:recipe" group-by="r:head/r:categories/r:cat[@class='diet']">
		<xsl:sort select="current-grouping-key()" />

		<h2><a name="{current-grouping-key()}"></a><xsl:value-of select="current-grouping-key()" /></h2>

		<ul>
		<!-- 
		Title/subtitle sort
		 -->
		<xsl:for-each select="current-group()" >
			<xsl:sort select="r:head/r:title" />
			<li><a href="{@id}.html"><xsl:value-of select="r:head/r:title" /></a>
			<xsl:if test="r:head/r:source">
				<xsl:text> from </xsl:text>
				<xsl:value-of select="r:head/r:source" />
			</xsl:if>
			</li>
		</xsl:for-each>
		</ul>
	</xsl:for-each-group> <!-- category -->
	
	<xsl:call-template name="footer" />

</body>
</html>

	</xsl:result-document>
	</xsl:template>



	<!-- 
	Head section of the html file
	 -->
	<xsl:template name="htmlHead">
		<head>
			<title>Christmas Baking with SusieJ: Recipes</title>
		
			<link rel="stylesheet" href="/christmas.css" type="text/css" title="white" />
			<link rel="alternate stylesheet" href="/christmasBlue.css" type="text/css" title="blue" />
		
			<link rel="shortcut icon" href="/favicon.ico" />
		
			<script type="text/javascript" src="/scripts/styleswitcher.js"></script>
			<script src="/scripts/cafe.js" type="text/javascript"></script>
			<script type="text/javascript" src="/scripts/jquery.js"></script>
			<script type="text/javascript" src="/scripts/socialLinks.js"></script>
		</head>
		
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
		<div class="header">
			<h1><a href="/index.html"><img src="/images/christmas-baking.gif" 
										   alt="Christmas Baking with SusieJ" /></a>
			Recipes
			</h1>
	
			<p class="menu2">
        	<span class="menu-item"><a href="cgi-bin/advent.cgi">Advent calendar</a></span>
        	<span class="menu-item"><a href="sources.html">Sources &amp; Resources</a></span>
        	<span class="menu-item"><a href= "hints.html">Baking 101</a></span>
        	<span class="menu-item"><a href= "guestbook.html">Baking Disasters</a></span>
        	<span class= "menu-item"><a href="other.html">Christmas Links</a></span>
        	<span class="menu-item"><a href="itsAllAboutTheFood/">(Not a) Blog</a></span>
        	<span class="menu-item"><a href="http://twitter.com/ChristmasBaking">@ChristmasBaking</a></span>
			</p>
		</div>

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
		<div class="footer">
			<p class="menu2">
				<span class="menu-item"><a href="mailto:webmistress@christmas-baking.com">Contact</a></span>
				<span class="menu-item"><a href="/about.html">About</a></span>
				<span class="menu-item"><a href="/submit.html">Share a Recipe</a></span>
				<span class="menu-item"><a href="/index.xml">RSS</a></span>
				<a href="http://www.cafepress.com/xmasbaking,xmsbkgspritz"><img src="/images/sticker.gif" style="float: right" alt="[Support the site!]" /></a>
			</p>
	
			<p>Please remember that typing and testing these recipes is
			a lot of work, as is creating and maintaining the web site.
			Links are always welcome. Please bake up a storm and share
			the results and the recipe with your friends! All other
			rights reserved.
			<br />
				<small>Last updated <xsl:value-of select="format-date (current-date(), '[FNn] [MNn] [D1], [Y]')" /></small>
			</p>
		</div>
	</xsl:template>
	
	<xsl:template match="r:head/r:title|r:head/r:subtitle">
		<li>
		<xsl:value-of select="." />
		</li>
	</xsl:template>

</xsl:stylesheet>
