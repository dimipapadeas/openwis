<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- ============================================================================================= -->

	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

	<!-- ============================================================================================= -->
	<!-- === Generate a table row for the harvesting entry list -->
	<!-- ============================================================================================= -->

	<xsl:template match="/root/node">

		<tr id="{@id}">
			<td class="padded" align="center"><input type="checkbox"/></td>
			<td class="padded" id="node.name"><xsl:value-of select="site/name"/></td>

			<!-- Type - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:variable name="type" select="@type"/>

			<td class="padded">
				<xsl:value-of select="/root/strings/info[@type=$type]/short"/>
			</td>

			<!-- Status - - - - - - - - - - - - - - - - - - - - - -->

			<td class="padded" align="center">
				<xsl:choose>
					<xsl:when test="options/status = 'inactive'">
						<img id="status" src="{/root/env/url}/images/fileclose.png" alt="I" />
					</xsl:when>
					<xsl:when test="options/status = 'active'">
						<xsl:choose>
							<xsl:when test="info/running = 'true'">
								<img id="status" src="{/root/env/url}/images/exec.png" alt="R" />
							</xsl:when>
							<xsl:otherwise>
								<img id="status" src="{/root/env/url}/images/clock.png" alt="A" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</td>

			<!-- Errors - - - - - - - - - - - - - - - - - - - - - -->

			<td class="padded" align="center">
				<xsl:choose>
					<xsl:when test="count(error/*) = 0">
						<img id="error" src="{/root/env/url}/images/button_ok.png" alt="I" />
					</xsl:when>
					<xsl:otherwise>
						<img id="error" src="{/root/env/url}/images/important.png" alt="R" />
					</xsl:otherwise>
				</xsl:choose>
			</td>

			<!-- Every - - - - - - - - - - - - - - - - - - - - - -->
			
			<xsl:variable name="every" select="options/every"/>
			<xsl:variable name="mins"  select="$every mod 60"/>
			<xsl:variable name="hours" select="($every - $mins) div 60 mod 24"/>
			<xsl:variable name="days"  select="($every - $mins - $hours * 60) div 1440"/>
			
			<td class="padded" id="node.every"><xsl:value-of select="concat($days, ':', $hours, ':', $mins)"/></td>
			
			<!-- Last run - - - - - - - - - - - - - - - - - - - - - -->
			
			<td class="padded" id="node.lastRun">
				<xsl:value-of select="substring-before(info/lastRun, 'T')"/>&#xA0;<xsl:value-of select="substring-after(info/lastRun, 'T')"/>
			</td>

			<!-- Edit button - - - - - - - - - - - - - - - - - - - - - -->
			
			<td class="padded" align="center">
				<!-- That f....d IE does not support buttons inside table row -->
				<!-- we have to use anchors instead -->
				
				<!--button class="content" onclick="harvesting.edit('{@id}')">
					<xsl:value-of select="/root/strings/edit"/>
				</button-->
				
				<a href="javascript:harvesting.edit('{@id}')">
					<xsl:value-of select="/root/strings/edit"/>
				</a>
			</td>
		</tr>

	</xsl:template>

	<!-- ============================================================================================= -->

	<xsl:template match="/root/strings"/>
	<xsl:template match="/root/env"/>

	<!-- ============================================================================================= -->

</xsl:stylesheet>
