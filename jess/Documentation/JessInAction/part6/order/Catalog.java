
import jess.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Iterator;

public class Catalog extends BaseServlet {

    public void doGet(HttpServletRequest request,
                       HttpServletResponse response)
        throws IOException, ServletException {
        checkInitialized();

        try {
            String customerId =
                (String) request.getParameter("customerId");
            if (customerId == null || customerId.length() == 0) {
                dispatch(request, response, "/index.html");
                return;
            }

            request.getSession().invalidate();
            HttpSession session = request.getSession();

            session.setAttribute("customerId", customerId);
            session.setAttribute("orderNumber",
                                 String.valueOf(getNewOrderNumber()));
            
            ServletContext servletContext = getServletContext();
            Rete engine = (Rete) servletContext.getAttribute("engine");
            Iterator result =
                engine.runQuery("all-products", new ValueVector());
            request.setAttribute("queryResult", result);


        } catch (JessException je) {
            throw new ServletException(je);
        }

        dispatch(request, response, "/catalog.jsp");
    }
    
    private int getNewOrderNumber() throws JessException {
        ServletContext servletContext = getServletContext();
        Rete engine = (Rete) servletContext.getAttribute("engine");
        int nextOrderNumber = 
            engine.executeCommand("(get-new-order-number)").intValue(null);
        return nextOrderNumber;
    }

    public void destroy() {
        try {
            ServletContext servletContext = getServletContext();
            Rete engine = (Rete) servletContext.getAttribute("engine");
            String factsFileName =
                servletContext.getInitParameter("factsfile");
            File factsFile = new File(factsFileName);
            File tmpFile =
                File.createTempFile("facts", "tmp", factsFile.getParentFile());
            engine.executeCommand("(save-facts " + tmpFile.getAbsolutePath() +
                                  " order recommend line-item next-order-number)");
            factsFile.delete();
            tmpFile.renameTo(factsFile);

        } catch (Exception je) {
            // Log error
        } 
    }

        
}
