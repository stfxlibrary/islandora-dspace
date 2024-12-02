<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mods="http://www.loc.gov/mods/v3" exclude-result-prefixes="mods" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:srw_dc="info:srw/schema/1/dc-schema" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:oaire="http://namespace.openaire.eu/schema/oaire/">

	<!-- 
    Version 1.8		2015-03-05 tmee@loc.gov
    				Typo mods:provence changed to mods:province
    
	Version 1.7 	2015-01-30 ws
					Changed dc:creator to dc:contributor if mods:name/mods:roleTerm != creator
					Fixed xpath bug in dc:subject output for mods:subject/mods:titleInfo/mods:title
					Fixed xpath bug in dc:format when mods:extent | mods:form | mods:internetMediaType [@unit]
					Fixedbug in xpath for @type
					
	Version 1.6		2015-01-30 schema location change: 
    				http://www.loc.gov/standards/sru/recordSchemas/dc-schema.xsd
        
	Version 1.5		2014-07-23 tmee@loc.gov
					Fixed subject transformation to eliminate empty element output
		
	Version 1.4		2013-12-13 tmee@loc.gov
					Upgraded to MODS 3.5
		
	Version 1.3		2013-12-09 tmee@loc.gov
					Fixed date transformation for dates without start/end points
	
	Version 1.2		2012-08-12 WS 
					Upgraded to MODS 3.4
	
	Version 1.1	2007-05-18 tmee@loc.gov
					Added modsCollection conversion to DC SRU
					Updated introductory documentation
	
	Version 1.0		2007-05-04 tmee@loc.gov
	
	This stylesheet transforms MODS version 3.4 records and collections of records to simple Dublin Core (DC) records, 
	based on the Library of Congress' MODS to simple DC mapping <http://www.loc.gov/standards/mods/mods-dcsimple.html> 
			
	The stylesheet will transform a collection of MODS 3.4 records into simple Dublin Core (DC)
	as expressed by the SRU DC schema <http://www.loc.gov/standards/sru/dc-schema.xsd>
	
	The stylesheet will transform a single MODS 3.4 record into simple Dublin Core (DC)
	as expressed by the OAI DC schema <http://www.openarchives.org/OAI/2.0/oai_dc.xsd>
			
	Because MODS is more granular than DC, transforming a given MODS element or subelement to a DC element frequently results in less precise tagging, 
	and local customizations of the stylesheet may be necessary to achieve desired results. 
	
	This stylesheet makes the following decisions in its interpretation of the MODS to simple DC mapping: 
		
	When the roleTerm value associated with a name is creator, then name maps to dc:creator
	When there is no roleTerm value associated with name, or the roleTerm value associated with name is a value other than creator, then name maps to dc:contributor
	Start and end dates are presented as span dates in dc:date and in dc:coverage
	When the first subelement in a subject wrapper is topic, subject subelements are strung together in dc:subject with hyphens separating them
	Some subject subelements, i.e., geographic, temporal, hierarchicalGeographic, and cartographics, are also parsed into dc:coverage
	The subject subelement geographicCode is dropped in the transform

-->

	<xsl:strip-space elements="*"/>
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		
		<xsl:choose>
			<!-- WS: updated schema location -->
			<xsl:when test="//mods:modsCollection">
				<srw_dc:dcCollection xsi:schemaLocation="info:srw/schema/1/dc-schema http://www.loc.gov/standards/sru/recordSchemas/dc-schema.xsd">
					<xsl:apply-templates/>
					<xsl:for-each select="mods:modsCollection/mods:mods">
						<srw_dc:dc xsi:schemaLocation="info:srw/schema/1/dc-schema http://www.loc.gov/standards/sru/recordSchemas/dc-schema.xsd">
							<xsl:apply-templates/>
						</srw_dc:dc>
					</xsl:for-each>
				</srw_dc:dcCollection>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="mods:mods">
					<oai_dc:dc xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
						<xsl:apply-templates/>
						<xsl:call-template name="obituaries"/>
					</oai_dc:dc>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name='obituaries'>
		<oaire:citation.title>The Casket</oaire:citation.title>
		
		<xsl:for-each select="mods:casket_year">
			<dc:date.issued><xsl:value-of select="."/></dc:date.issued>	
		</xsl:for-each>
		
		<xsl:for-each select="mods:casket_vol">
			<oaire:citation.volume><xsl:value-of select="."/></oaire:citation.volume>	
		</xsl:for-each>
		
		<xsl:for-each select="mods:casket_issue">
			<oaire:citation.issue><xsl:value-of select="."/></oaire:citation.issue>	
		</xsl:for-each>
		
		<xsl:for-each select="mods:casket_page">
			<oaire:citation.startPage><xsl:value-of select="."/></oaire:citation.startPage>
			<oaire:citation.endPage><xsl:value-of select="."/></oaire:citation.endPage>
		</xsl:for-each>
		
		<xsl:for-each select="mods:birth_place">
			<dc:subject.birth_location><xsl:value-of select="."/></dc:subject.birth_location>	
		</xsl:for-each>

		<xsl:for-each select="mods:birth">
			<dc:date.birth><xsl:value-of select="."/></dc:date.birth>	
		</xsl:for-each>
		
		<xsl:for-each select="mods:death_place">
			<dc:subject.death_location><xsl:value-of select="."/></dc:subject.death_location>	
		</xsl:for-each>
		
		<xsl:for-each select="mods:death">
			<dc:date.death><xsl:value-of select="."/></dc:date.death>	
		</xsl:for-each>		
		
		<xsl:for-each select="mods:age">
			<dc:subject.age><xsl:value-of select="."/></dc:subject.age>	
		</xsl:for-each>
		
		<xsl:for-each select="mods:father">
			<dc:subject.father><xsl:value-of select="."/></dc:subject.father>
		</xsl:for-each>
		
		<xsl:for-each select="mods:father_town">
			<dc:subject.father_town><xsl:value-of select="."/></dc:subject.father_town>
		</xsl:for-each>
		
		<xsl:for-each select="mods:mother">
			<dc:subject.mother><xsl:value-of select="."/></dc:subject.mother>
		</xsl:for-each>
		
		<xsl:for-each select="mods:mother_town">
			<dc:subject.mother_town><xsl:value-of select="."/></dc:subject.mother_town>
		</xsl:for-each>		

		<xsl:for-each select="mods:spouse">
			<dc:subject.spouse><xsl:value-of select="."/></dc:subject.spouse>	
		</xsl:for-each>
		
		<xsl:for-each select="mods:spouse_death">
			<dc:date.spouse_death><xsl:value-of select="."/></dc:date.spouse_death>	
		</xsl:for-each>		
		
		<xsl:for-each select="mods:siblings">
			<dc:subject.siblings><xsl:value-of select="."/></dc:subject.siblings>	
		</xsl:for-each>
		
		<xsl:for-each select="mods:other_relations">
			<dc:subject.other_relations><xsl:value-of select="."/></dc:subject.other_relations>	
		</xsl:for-each>		

		<xsl:for-each select="mods:notes">
			<dc:description.note><xsl:value-of select="."/></dc:description.note>	
		</xsl:for-each>	
		
		<xsl:for-each select="mods:affiliation">
			<dc:subject.affiliation><xsl:value-of select="."/></dc:subject.affiliation>	
		</xsl:for-each>		
	</xsl:template>

	<xsl:template match="mods:titleInfo">
		<xsl:if test="mods:title/text()">
			<xsl:choose>
				<xsl:when test="@type = 'alternative'">
					<dc:title.alternative>
						<xsl:value-of select="*"/>
					</dc:title.alternative>
				</xsl:when>
				<xsl:otherwise>
					<dc:title>
						<xsl:value-of select="mods:nonSort"/>
						<xsl:if test="mods:nonSort">
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:value-of select="mods:title"/>
						<xsl:if test="mods:subTitle/text()">
							<xsl:text>: </xsl:text>
							<xsl:value-of select="mods:subTitle"/>
						</xsl:if>
						<xsl:if test="mods:partNumber">
							<xsl:text>. </xsl:text>
							<xsl:value-of select="mods:partNumber"/>
						</xsl:if>
						<xsl:if test="mods:partName">
							<xsl:text>. </xsl:text>
							<xsl:value-of select="mods:partName"/>
						</xsl:if>
					</dc:title>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>


	<!-- tmee mods 3.5 -->
	<xsl:template match="mods:name">
		<xsl:choose>
			<!-- StFX: Change mods:roletype author to dc.contributor.author -->
			<xsl:when test="translate(mods:role/mods:roleTerm[@type='text'],'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')='author'">
				<dc:contributor.author>
					<xsl:call-template name="name"/>
				</dc:contributor.author>
			</xsl:when>
			
			<xsl:when test="translate(mods:role/mods:roleTerm[@type='text'],'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')='creator' or mods:role/mods:roleTerm[@type='code']='cre'">
				<dc:contributor.author>
					<xsl:call-template name="name"/>
				</dc:contributor.author>
			</xsl:when>
			<xsl:when test="translate(mods:role/mods:roleTerm[@type='text'],'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')='editor'">
				<dc:contributor.editor>
					<xsl:call-template name="name"/>
				</dc:contributor.editor>
			</xsl:when>			
			<xsl:otherwise>
				<!-- ws  1.7 -->
				<dc:contributor>
					<xsl:call-template name="name"/>
					<xsl:if test="mods:etal">et al.</xsl:if>
				</dc:contributor>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mods:classification">
		<dc:subject>
			<xsl:value-of select="."/>
		</dc:subject>
	</xsl:template>

	<!-- ws 1.7  -->
	<xsl:template match="mods:subject">
		<xsl:if test="mods:topic">
			<xsl:for-each select="mods:topic">
				<xsl:if test="text()">
					<dc:subject>
						<xsl:value-of select="."/>
					</dc:subject>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>		
		<xsl:if test="mods:occupation | mods:name">
			<dc:subject>
				<xsl:for-each select="mods:topic | mods:occupation">
					<xsl:value-of select="."/>
					<xsl:if test="position()!=last()">--</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="mods:name">
					<xsl:call-template name="name"/>
				</xsl:for-each>
			</dc:subject>
		</xsl:if>
		<xsl:for-each select="mods:titleInfo">
			<dc:subject>
				<xsl:for-each select="child::*">
					<xsl:value-of select="."/>
					<xsl:if test="following-sibling::*"><xsl:text> </xsl:text></xsl:if>
				</xsl:for-each>
			</dc:subject>
		</xsl:for-each>
		<xsl:for-each select="mods:geographic">
			<xsl:if test="text()">
				<dc:coverage>
					<xsl:value-of select="."/>
				</dc:coverage>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="mods:hierarchicalGeographic">
			<dc:coverage.spatial>
				<xsl:for-each select="mods:continent|mods:country|mods:province|mods:region|mods:state|mods:territory|mods:county|mods:city|mods:island|mods:area">
					<xsl:value-of select="."/>
					<xsl:if test="position()!=last()">--</xsl:if>
				</xsl:for-each>
			</dc:coverage.spatial>
		</xsl:for-each>
		<xsl:for-each select="mods:cartographics/*">
			<dc:coverage.spatial>
				<xsl:value-of select="."/>
			</dc:coverage.spatial>
		</xsl:for-each>
		<xsl:if test="mods:temporal">
				<xsl:for-each select="mods:temporal">
					<xsl:if test="text()">
						<dc:coverage.temporal>
							<xsl:value-of select="."/>
							<xsl:if test="position()!=last()">-</xsl:if>
						</dc:coverage.temporal>
					</xsl:if>
				</xsl:for-each>
		</xsl:if>
		<!--<xsl:if test="*[1][local-name()='topic'] and *[local-name()!='topic']">
			<dc:subject>
				<xsl:for-each select="*[local-name()!='cartographics' and local-name()!='geographicCode' and local-name()!='hierarchicalGeographic'] ">
					<xsl:value-of select="."/>
					<xsl:if test="position()!=last()">-\-</xsl:if>
				</xsl:for-each>
			</dc:subject>
		</xsl:if>-->
	</xsl:template>


	<xsl:template match="mods:note">
		<xsl:if test="text()">		
			<xsl:variable name="note" select="."/>
			<xsl:choose>
				<xsl:when test="contains($note,'Print copy') = true()">
					<dc:relation>
						<xsl:value-of select="."/>
					</dc:relation>				
				</xsl:when>
				<xsl:otherwise>
					<dc:description>
						<xsl:value-of select="."/>
					</dc:description>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mods:tableOfContents">
		<xsl:if test="text()">
			<dc:description>
				<xsl:value-of select="."/>
			</dc:description>
		</xsl:if>
	</xsl:template>	
	
	<xsl:template match="mods:abstract">
		<dc:description.abstract>
			<xsl:value-of select="."/>
		</dc:description.abstract>
	</xsl:template>	
	<xsl:template match="mods:originInfo">
		<xsl:apply-templates select="*[@point='start']"/>
		<xsl:apply-templates select="*[not(@point)]"/>
		<xsl:for-each select="mods:publisher">
			<dc:publisher>
				<xsl:value-of select="."/>
			</dc:publisher>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="mods:dateCreated | mods:dateCaptured">
		<dc:date>
			<xsl:choose>
				<xsl:when test="@point='start'">
					<xsl:value-of select="."/>
					<xsl:text> - </xsl:text>
				</xsl:when>
				<xsl:when test="@point='end'">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</dc:date>
	</xsl:template>
	
	<xsl:template match="mods:dateCreated[@point='start'] | mods:dateCaptured[@point='start'] | mods:dateOther[@point='start'] ">
		<xsl:variable name="dateName" select="local-name()"/>
		<dc:date>
			<xsl:value-of select="."/>-<xsl:value-of select="../*[local-name()=$dateName][@point='end']"/>
		</dc:date>
	</xsl:template>
	
	<xsl:template match="mods:dateIssued">
		<xsl:if test="text()">
			<dc:date.issued>
				<xsl:choose>
					<xsl:when test="@point='start'">
						<xsl:value-of select="."/>
						<xsl:text> - </xsl:text>
					</xsl:when>
					<xsl:when test="@point='end'">
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</dc:date.issued>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="mods:dateIssued[@point='start']">
		<xsl:variable name="dateName" select="local-name()"/>
		<dc:date.issued>
			<xsl:value-of select="."/>-<xsl:value-of select="../*[local-name()=$dateName][@point='end']"/>
		</dc:date.issued>
	</xsl:template>
	<xsl:template match="mods:temporal[@point='start']  ">
		<xsl:value-of select="."/>-<xsl:value-of select="../mods:temporal[@point='end']"/>
	</xsl:template>

	<xsl:template match="mods:temporal[@point!='start' and @point!='end']  ">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="mods:genre">
		<xsl:if test="text()">
			<xsl:choose>
				<xsl:when test="@authority='dct'">
					<dc:type>
						<xsl:value-of select="."/>
					</dc:type>
				</xsl:when>
				<xsl:otherwise>
					<dc:type>
						<xsl:value-of select="."/>
					</dc:type>
					<xsl:apply-templates select="mods:typeOfResource"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mods:typeOfResource">
		<xsl:if test="@collection='yes'">
			<dc:type>Collection</dc:type>
		</xsl:if>
		<xsl:if test=". ='software' and ../mods:genre='database'">
			<dc:type>Dataset</dc:type>
		</xsl:if>
		<xsl:if test=".='software' and ../mods:genre='online system or service'">
			<dc:type>Service</dc:type>
		</xsl:if>
		<xsl:if test=".='software'">
			<dc:type>Software</dc:type>
		</xsl:if>
		<xsl:if test=".='cartographic material'">
			<dc:type>Image</dc:type>
		</xsl:if>
		<xsl:if test=".='multimedia'">
			<dc:type>Interactive Resource</dc:type>
		</xsl:if>
		<xsl:if test=".='moving image'">
			<dc:type>Moving Image</dc:type>
		</xsl:if>
		<xsl:if test=".='three dimensional object'">
			<dc:type>Physical Object</dc:type>
		</xsl:if>
		<xsl:if test="starts-with(.,'sound recording')">
			<dc:type>Sound</dc:type>
		</xsl:if>
		<xsl:if test=".='still image'">
			<dc:type>Still Image</dc:type>
		</xsl:if>
		<xsl:if test=". ='text'">
			<dc:type>Text</dc:type>
		</xsl:if>
		<xsl:if test=".='notated music'">
			<dc:type>Text</dc:type>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mods:physicalDescription">
		
		<xsl:for-each select="mods:extent">
			<xsl:if test="text()">
				<dc:format.extent>
					
					<!-- tmee mods 3.5 -->
					<xsl:variable name="unit" select="translate(@unit,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
					<!-- ws 1.7 -->
					<xsl:if test="@unit">
						<xsl:value-of select="$unit"/>: 
					</xsl:if>
					<xsl:value-of select="."/>
				</dc:format.extent>
			</xsl:if>
		</xsl:for-each>
		
		<xsl:for-each select="mods:form">
			<xsl:if test="text()">
				<dc:format.medium>
					<!-- tmee mods 3.5 -->
					<xsl:variable name="unit" select="translate(@unit,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
					<!-- ws 1.7 -->
					<xsl:if test="@unit">
						<xsl:value-of select="$unit"/>: 
					</xsl:if>
					<xsl:value-of select="."/>
				</dc:format.medium>
			</xsl:if>
		</xsl:for-each>	
		
		<xsl:for-each select="mods:internetMediaType">
			<xsl:if test="text()">
				<dc:format>
					<!-- tmee mods 3.5 -->
					<xsl:variable name="unit" select="translate(@unit,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
					<!-- ws 1.7 -->
					<xsl:if test="@unit">
						<xsl:value-of select="$unit"/>: 
					</xsl:if>
					<xsl:value-of select="."/>
				</dc:format>
			</xsl:if>
		</xsl:for-each>	
	</xsl:template>
	
	<!--
	<xsl:template match="mods:mimeType">
		<dc:format>
			<xsl:value-of select="."/>
		</dc:format>
	</xsl:template>
-->
	<xsl:template match="mods:identifier">
		<xsl:if test="text()">
			<xsl:variable name="type" select="translate(@type,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
			<xsl:choose>
				<!-- 2.0: added identifier type attribute to output, if it is present-->
				
				<!-- ws 1.7  -->
				<xsl:when test="@type">
					<xsl:choose>		
						<xsl:when test="contains ('school cbu-school', $type)">
							<dc:subject>
								<xsl:value-of select="."/>
							</dc:subject>
						</xsl:when>
						<xsl:when test="contains ('department cbu-department', $type)">
							<dc:subject.discipline>
								<xsl:value-of select="."/>
							</dc:subject.discipline>
						</xsl:when>											
						<xsl:when test="contains ('doi', $type)">
							<dc:identifier.doi>
								<xsl:value-of select="."/>
							</dc:identifier.doi>
						</xsl:when>
						<xsl:when test="contains ('isbn', $type)">
							<dc:identifier.isbn>
								<xsl:value-of select="."/>
							</dc:identifier.isbn>
						</xsl:when>
						<xsl:when test="contains ('uri', $type)">
							<dc:identifier.uri>
								<xsl:value-of select="."/>
							</dc:identifier.uri>
						</xsl:when>
						<xsl:when test="contains ('lccn', $type)">
							<dc:identifier.lccn>
								<xsl:value-of select="."/>
							</dc:identifier.lccn>
						</xsl:when>
						<xsl:otherwise>
							<dc:identifier>
								<xsl:value-of select="$type"/>: <xsl:value-of select="."/>
							</dc:identifier>	
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<dc:identifier.other>
						<xsl:value-of select="."/>
					</dc:identifier.other>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="mods:location">
		<xsl:for-each select="mods:url">
			<xsl:if test="text()">
				<dc:identifier.uri>
					<xsl:value-of select="."/>
				</dc:identifier.uri>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="mods:physicalLocation">
			<xsl:if test="text()">
				<dc:relation>
					<xsl:value-of select="."/>
				</dc:relation>
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>

	<xsl:template match="mods:language">
		<xsl:for-each select="mods:languageTerm">
			<xsl:if test="text()">
				<xsl:choose>
					<xsl:when test="@type='code'">
						<dc:language>
							<xsl:value-of select="."/>
						</dc:language>
						<dc:language.iso>
							<xsl:value-of select="@authority"/>
						</dc:language.iso>			
					</xsl:when>
					<xsl:otherwise>
						<dc:language>
							<xsl:value-of select="."/>
						</dc:language>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
		
		
	</xsl:template>

	<xsl:template match="mods:relatedItem[mods:titleInfo | mods:name | mods:identifier | mods:location]">
		<xsl:choose>
			<xsl:when test="@type='original'">
				<dc:source>
					<xsl:for-each select="mods:titleInfo/mods:title | mods:identifier | mods:location/mods:url">
						<xsl:if test="normalize-space(.)!= ''">
							<xsl:value-of select="."/>
							<xsl:if test="position()!=last()">--</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</dc:source>
			</xsl:when>
			<xsl:when test="@type='series'"/>
			<xsl:otherwise>
				<dc:relation>
					<xsl:for-each select="mods:titleInfo/mods:title | mods:identifier | mods:location/mods:url">
						<xsl:if test="normalize-space(.)!= ''">
							<xsl:value-of select="."/>
							<xsl:if test="position()!=last()">--</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</dc:relation>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<xsl:template match="mods:accessCondition">
		<xsl:variable name="contact_author" select="."></xsl:variable>
		<xsl:choose>
			<xsl:when test="(@displayLabel='License') and ($contact_author='Contact Author')">
				<dc:rights.holder>Author</dc:rights.holder>
			</xsl:when>
			<xsl:when test="(@displayLabel='Permission Statement')">
				<dc:rights>
					<xsl:value-of select="."/>
				</dc:rights>
			</xsl:when>
			<xsl:when test="(@type='restriction on access')">
				<dc:rights>
					<xsl:value-of select="."/>
				</dc:rights>
			</xsl:when>			
			<xsl:otherwise>
				<dc:rights>
					<xsl:value-of select="."/>
				</dc:rights>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="name">
		<xsl:variable name="name">
			<xsl:for-each select="mods:namePart[not(@type)]">
				<xsl:value-of select="."/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
			<xsl:value-of select="mods:namePart[@type='family']"/>
			<xsl:if test="mods:namePart[@type='given']">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="mods:namePart[@type='given']"/>
			</xsl:if>
			<xsl:if test="mods:namePart[@type='date']">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="mods:namePart[@type='date']"/>
				<xsl:text/>
			</xsl:if>
			<xsl:if test="mods:displayForm">
				<xsl:text> (</xsl:text>
				<xsl:value-of select="mods:displayForm"/>
				<xsl:text>) </xsl:text>
			</xsl:if>
			<xsl:for-each select="mods:role[mods:roleTerm[@type='text']]">
				<xsl:if test="
					not(contains(translate(self::*,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'author')) 
					and not(contains(translate(self::*,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'contributor')) 
					and not(contains(translate(self::*,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'creator'))
					and not(contains(translate(self::*,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'editor'))">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="normalize-space(child::*)"/>
					<xsl:text>) </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="normalize-space($name)"/>
	</xsl:template>

	<!-- suppress all else:-->
	<xsl:template match="*"/>


</xsl:stylesheet>