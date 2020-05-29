package control;
import jess.*;

class WhichPump implements Userfunction {
    public String getName() { return "which-pump"; }
    public Value call(ValueVector vv, Context c)
        throws JessException {
        int floor = vv.get(1).intValue(c);
        int heatPump = (floor-1)/3 + 1;
        return new Value(heatPump, RU.INTEGER);        
    }
}
