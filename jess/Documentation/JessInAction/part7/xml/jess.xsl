<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">
  <xsl:output method="text" indent="no"/>
  <xsl:strip-space elements="*"/>

  <!-- Top-level rule template -->
  <xsl:template match="rule">  
    <xsl:text>(defrule </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>&#xA;</xsl:text>
    <xsl:if test="@priority != ''">    
      <xsl:text>  (declare (salience </xsl:text>
      <xsl:value-of select="./@priority"/>
      <xsl:text>))&#xA;</xsl:text>      
    </xsl:if>
    <xsl:apply-templates select="./lhs"/>
    <xsl:text>  =&gt;</xsl:text>
    <xsl:apply-templates select="./rhs"/>
    <xsl:text>)&#xA;</xsl:text>
  </xsl:template>

  <!-- Rule left hand sides -->

  <xsl:template match="lhs">  
    <xsl:for-each select="./group | ./pattern">
      <xsl:text>  </xsl:text>
      <xsl:apply-templates select="."/>
    <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="group">  
    <xsl:text>(</xsl:text>
    <xsl:value-of select="./@name"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="pattern">  
    <xsl:if test="@binding != ''">
      <xsl:text>?</xsl:text>
      <xsl:value-of select="@binding"/>
      <xsl:text> &lt;- </xsl:text>
    </xsl:if>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="./@name"/>
    <xsl:apply-templates select="./slot"/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="slot">  
    <xsl:text> (</xsl:text>
    <xsl:value-of select="./@name"/>
    <xsl:for-each select="./*">
      <xsl:if test="position() != 1">
        <xsl:text>&amp;</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <xsl:text>)</xsl:text>    
  </xsl:template>
  
  <xsl:template match="slot/function-call"> 
    <xsl:text>:</xsl:text>
    <xsl:call-template name="funcall"/>
  </xsl:template>

  <!-- Rule right hand sides -->

  <xsl:template match="rhs/function-call"> 
    <xsl:text>&#xA;  </xsl:text>
    <xsl:call-template name="funcall"/>
    <xsl:text></xsl:text>
  </xsl:template>

  <!-- Function calls -->

  <xsl:template match="function-call"> 
    <xsl:call-template name="funcall"/>
  </xsl:template>

  <xsl:template name="funcall">  
    <xsl:text>(</xsl:text>
    <xsl:apply-templates select="./*"/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="function-call/function-call"> 
    <xsl:text> </xsl:text>
    <xsl:call-template name="funcall"/>
  </xsl:template>

  <!-- Miscellaneous -->

  <xsl:template match="variable"> 
    <xsl:text> ?</xsl:text>
    <xsl:value-of select="@name"/>
  </xsl:template>

  <xsl:template match="constant">  
    <xsl:text> </xsl:text>
    <xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>

