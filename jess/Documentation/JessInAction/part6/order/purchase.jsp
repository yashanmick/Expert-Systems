<HTML>
  <%@ page import="jess.*" %>
  <jsp:useBean id="queryResult" class="java.util.Iterator" scope="request"/>

  <HEAD>
    <TITLE>Thank you for your order</TITLE>
  </HEAD>

  <BODY>
    <H1>Thanks for shopping at TekMart.com!</H1>
    These are the items you are purchasing. If this were a real
    web site, I'd be asking for your credit card number now!
    <P>
    <TABLE border="1">
    <TR><TH>Name</TH>
        <TH>Catalog #</TH>
        <TH>Price</TH>
    </TR>
    <% double total = 0; 
       while (queryResult.hasNext()) {
           Token token = (Token) queryResult.next();
           Fact fact = token.fact(2); 
           double price = fact.getSlotValue("price").floatValue(null);
           total += price; %>

       <TR>
         <TD><%= fact.getSlotValue("name").stringValue(null) %></TD>
         <TD><%= fact.getSlotValue("part-number").stringValue(null) %></TD>
         <TD><%= price %></TD>
       </TR>        
     <% } %> 
     <TR><TD></TD><TD><B>Total:</B></TD><TD><%= total %></TD></TR>
    </TABLE>
  </BODY>
</HTML>
