import jess.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Iterator;

public class Purchase extends BaseServlet {

    public void doGet(HttpServletRequest request,
                       HttpServletResponse response)
        throws IOException, ServletException {
        checkInitialized();

        ServletContext servletContext = getServletContext();

        String orderNumberString =
            (String) request.getSession().getAttribute("orderNumber");
        String customerIdString =
            (String) request.getSession().getAttribute("customerId");
        if (orderNumberString == null || customerIdString == null) {
            dispatch(request, response, "/index.html");
            return;
        }
        
        try {
            Rete engine = (Rete) servletContext.getAttribute("engine");

            int orderNumber = Integer.parseInt(orderNumberString);
            Value orderNumberValue = new Value(orderNumber, RU.INTEGER);
            Value customerIdValue = new Value(customerIdString, RU.ATOM);

            String[] items = (String[]) request.getParameterValues("items");
            if (items != null) {
                for (int i=0; i<items.length; ++i) {
                    Fact item = new Fact("line-item", engine);
                    item.setSlotValue("order-number", orderNumberValue);
                    item.setSlotValue("customer-id", customerIdValue);
                    item.setSlotValue("part-number", new Value(items[i], RU.ATOM));
                    engine.assertFact(item);
                }
            }

            Iterator result =
                engine.runQuery("items-for-order",
                                new ValueVector().add(orderNumberValue));
            request.setAttribute("queryResult", result);

        } catch (JessException je) {
            throw new ServletException(je);
        }

        dispatch(request, response, "/purchase.jsp");
    }
}
