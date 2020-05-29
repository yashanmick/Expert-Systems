<HTML>
  <%@ page import="jess.*" %>
  <jsp:useBean id="queryResult" class="java.util.Iterator" scope="request"/>

  <HEAD>
    <TITLE>Ordering from Tekmart.com</TITLE>
  </HEAD>

  <BODY>
    <H1>Tekmart.com Catalog</H1>
    Select the items you wish to purchase and press "Check Order" to continue.
    <FORM action="/Order/recommend" method="POST">
    <TABLE border="1">
    <TR><TH>Name</TH>
        <TH>Catalog #</TH>
        <TH>Price</TH>
        <TH>Purchase?</TH>
    </TR>
    <% while (queryResult.hasNext()) {
           Token token = (Token) queryResult.next();
           Fact fact = token.fact(1);
           String partNum =
                  fact.getSlotValue("part-number").stringValue(null); %> 
       <TR>
         <TD><%= fact.getSlotValue("name").stringValue(null) %></TD>
         <TD><%= partNum %></TD>
         <TD><%= fact.getSlotValue("price").floatValue(null) %></TD>
         <TD><INPUT type="checkbox" name="items"
                    value=<%= '"' + partNum + '"'%>></TD>
       </TR> 
     <% } %>                 
    </TABLE>
    <INPUT type="submit" value="Check Order">
    </FORM>
  </BODY>
</HTML>
