import jess.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Iterator;

public class Recommend extends BaseServlet {

    public void doGet(HttpServletRequest request,
                       HttpServletResponse response)
        throws IOException, ServletException {
        checkInitialized();

        ServletContext servletContext = getServletContext();

        String[] items = (String[]) request.getParameterValues("items");
        String orderNumberString =
            (String) request.getSession().getAttribute("orderNumber");
        String customerIdString =
            (String) request.getSession().getAttribute("customerId");
        if (items == null ||
            orderNumberString == null || customerIdString == null) {
            dispatch(request, response, "/index.html");
            return;
        }
        
        try {
            Rete engine = (Rete) servletContext.getAttribute("engine");

            engine.executeCommand("(assert (clean-up-order " +
                                  orderNumberString + "))");
            engine.run();

            int orderNumber = Integer.parseInt(orderNumberString);
            Value orderNumberValue = new Value(orderNumber, RU.INTEGER);
            Value customerIdValue = new Value(customerIdString, RU.ATOM);
            Fact order = new Fact("order", engine);
            order.setSlotValue("order-number", orderNumberValue);
            order.setSlotValue("customer-id", customerIdValue);
            engine.assertFact(order);

            for (int i=0; i<items.length; ++i) {
                Fact item = new Fact("line-item", engine);
                item.setSlotValue("order-number", orderNumberValue);
                item.setSlotValue("part-number", new Value(items[i], RU.ATOM));
                item.setSlotValue("customer-id", customerIdValue);
                engine.assertFact(item);
            }
            engine.run();
            Iterator result =
                engine.runQuery("recommendations-for-order",
                                new ValueVector().add(orderNumberValue));

            if (result.hasNext()) {
                request.setAttribute("queryResult", result);
                dispatch(request, response, "/recommend.jsp");
            } else
                dispatch(request, response, "/purchase");

        } catch (JessException je) {
            throw new ServletException(je);
        }

    }
}
