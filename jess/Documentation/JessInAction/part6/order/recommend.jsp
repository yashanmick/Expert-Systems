<HTML>
  <%@ page import="jess.*" %>
  <jsp:useBean id="queryResult" class="java.util.Iterator" scope="request"/>

  <HEAD>
    <TITLE>Some Recommendations for You from Tekmart.com</TITLE>
  </HEAD>

  <BODY>
    <H1>Your Recommendations</H1>
    You may also wish to purchase the following items:
    <FORM action="/Order/purchase" method="POST">
    <TABLE border="1">
    <TR>
        <TH>Name</TH>
        <TH>Catalog #</TH>
        <TH>Because you bought...</TH>
        <TH>Price</TH>
        <TH>Purchase?</TH>
    </TR>
    <% while (queryResult.hasNext()) {
           Token token = (Token) queryResult.next();
           Fact fact1 = token.fact(1);
           Fact fact2 = token.fact(2); 
           String partNum =
               fact2.getSlotValue("part-number").stringValue(null); %>
       <TR>
         <TD><%= fact2.getSlotValue("name").stringValue(null) %></TD>
         <TD><%= partNum %> 
         <TD><% ValueVector vv = fact1.getSlotValue("because").listValue(null);
                for (int i=0; i<vv.size(); ++i) { %>
                <%= vv.get(i).stringValue(null) %>
                <% if (i != vv.size()-1) %>,                  
                <% } %>
         </TD>
         <TD><%= fact2.getSlotValue("price").floatValue(null) %></TD>
         <TD><INPUT type="checkbox" name="items"         
                    value=<%= '"' + partNum + '"'%>></TD>
       </TR> 
     <% } %>                 
    </TABLE>
    <INPUT type="submit" value="Purchase">
    </FORM>

  </BODY>
</HTML>
