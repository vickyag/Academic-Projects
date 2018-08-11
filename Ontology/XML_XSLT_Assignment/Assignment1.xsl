<?xml version='1.0'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<xsl:output method="html"/>



<xsl:param name="news"></xsl:param>
<xsl:param name="place"></xsl:param>
<xsl:param name="category"></xsl:param>


<xsl:template match="/">
	<html>
	  <body>
	     <xsl:if test="$news='current_affairs'">
		 <h1 align="center">Current affairs</h1>
	     <table border="1" cellspacing="0" align="center">
		    <tr style="background-color:grey">
			   <th>Headline</th>
			   <th>Descrition</th>
			   <th>Author</th>
			   <th>Content</th>
			   <th>Date</th>
			   <th>Place</th>
             </tr>
			 
			 <xsl:for-each select="news/current_affairs/article">
			   <xsl:if test="(place=$place) or not($place)">
			    <tr>
				     <td style="background-color:#87ceeb"><xsl:value-of select="headline"/></td>
					 <td style="background-color:cyan"><xsl:value-of select="description"/></td>
					 <td style="background-color:red"><xsl:value-of select="author"/></td>
                     <td style="background-color:#F0FFF0"><xsl:value-of select="content"/></td>
					 <td style="background-color:yellow"><xsl:value-of select="date"/></td>
					 <td style="background-color:violet"><xsl:value-of select="place"/></td>
					    
				</tr>
				</xsl:if>   
			    </xsl:for-each>
			
			 </table>
			 </xsl:if>





			  <xsl:if test="$news='sports'">
			   <h1 align="center">Sports</h1>
	     <table border="1" cellspacing="0" align="center">
		    <tr style="background-color:grey">
			   <th>Headline</th>
			   <th>Descrition</th>
			   <th>Author</th>
			   <th>Content</th>
			   <th>Date</th>
			   <th>Category</th>
             </tr>
			 
			 <xsl:for-each select="news/sports/article">
			   <xsl:if test="(category=$category) or not($category)">
			    <tr>
				     <td style="background-color:grey"><xsl:value-of select="headline"/></td>
					 <td style="background-color:white"><xsl:value-of select="description"/></td>
					 <td style="background-color:grey"><xsl:value-of select="author"/></td>
                     <td style="background-color:white"><xsl:value-of select="content"/></td>
					 <td style="background-color:grey"><xsl:value-of select="date"/></td>
					 <td style="background-color:white"><xsl:value-of select="category"/></td>
					    
				</tr>
				</xsl:if>   
			    </xsl:for-each>
			
			 </table>
			 </xsl:if>





			  <xsl:if test="$news='technology'">
			   <h1 align="center">Technology</h1>
	     <table border="1" cellspacing="0" align="center">
		    <tr style="background-color:grey">
			   <th>Headline</th>
			   <th>Descrition</th>
			   <th>Author</th>
			   <th>Content</th>
			   <th>Date</th>
			   <th>Place</th>
			   <th>Tags</th>
			   <th>Category</th>
             </tr>
			
			 <xsl:for-each select="news/technology/article">
			   <xsl:if test="(catagory=$category) or not($category)">
			    <tr>
				     <td style="background-color:#87ceeb"><xsl:value-of select="headline"/></td>
					 <td style="background-color:cyan"><xsl:value-of select="description"/></td>
					 <td style="background-color:red"><xsl:value-of select="author"/></td>
                     <td style="background-color:#F0FFF0"><xsl:value-of select="content"/></td>
					 <td style="background-color:yellow"><xsl:value-of select="date"/></td>
					 <td style="background-color:violet"><xsl:value-of select="place"/></td>
					 <td style="background-color:#F0FFF0"><xsl:value-of select="tags"/></td>
					 <td style="background-color:yellow"><xsl:value-of select="catagory"/></td>
					   
				</tr>
				</xsl:if>   
			    </xsl:for-each>
			
			 </table>
			 </xsl:if>
			 </body>
			 </html>	
</xsl:template>

</xsl:stylesheet>