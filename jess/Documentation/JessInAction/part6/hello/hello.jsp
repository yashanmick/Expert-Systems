<html>
  <%@ page import="jess.*" %>
  <jsp:useBean id="engine" class="jess.Rete" scope="request"/>
  <head>
    <title>Hello World!</title>
  </head>
  <body>
    <H1><%
        engine.addOutputRouter("page", out);
        engine.executeCommand("(printout page \"Hello World from Jess!\" crlf)");
    %></H1>
  </body>
</html>


