package control;
import jess.*;

class ReadVent implements Userfunction {
    public String getName() { return "get-vent-state"; }
    public Value call(ValueVector vv, Context c)
        throws JessException {        
        int vent = vv.get(1).intValue(c);
        Simulator sim = InitSimulator.getSimulator(c);
        double state = sim.getVentState(vent);
        return new Value(State.vent(state), RU.ATOM);        
    }
}
