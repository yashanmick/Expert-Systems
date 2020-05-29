package control;
import jess.*;

class WriteVent implements Userfunction {
    public String getName() { return "set-vent-state"; }
    public Value call(ValueVector vv, Context c)
        throws JessException {        
        int vent = vv.get(1).intValue(c);
        Simulator sim = InitSimulator.getSimulator(c);                
        String szState = vv.get(2).stringValue(c);
        try {
            double state = State.vent(szState);
            sim.setVentState(vent, state);
        } catch (IllegalArgumentException iae) {
            throw new JessException("set-vent-state",
                                    "Invalid  state",
                                    szState);
        }

        return Funcall.TRUE;
    }
}
