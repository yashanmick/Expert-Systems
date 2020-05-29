package fuzzy;
import jess.*;

class WriteVent implements Userfunction {
    public String getName() { return "change-vent-state"; }
    public Value call(ValueVector vv, Context c)
        throws JessException {        
        int vent = vv.get(1).intValue(c);
        Simulator sim = InitSimulator.getSimulator(c);                
        double stateChange = vv.get(2).floatValue(c);
        try {
            sim.changeVentState(vent, stateChange);
        } catch (IllegalArgumentException iae) {
            throw new JessException("change-vent-state",
                                    "Invalid  state",
                                    String.valueOf(stateChange));
        }

        return Funcall.TRUE;
    }
}
