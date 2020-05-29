import jess.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class HelloJess extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        Rete engine = new Rete();
        engine.addOutputRouter("page", out);

        try {
            print("<html>", engine);
            print("<head>", engine);
            print("<title>Hello World!</title>", engine);
            print("</head>", engine);
            print("<body>", engine);
            print("<h1>Hello World from Jess!</h1>", engine);
            print("</body>", engine);
            print("</html>", engine);
        } catch (JessException je) {
            throw new ServletException(je);
        }
    }

    private void print(String message, Rete engine) throws JessException {
        engine.executeCommand("(printout page \"" + message +
                              "\" crlf)");
    }
}
