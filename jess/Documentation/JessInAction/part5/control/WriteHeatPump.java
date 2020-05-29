package control;
import jess.*;

class WriteHeatPump implements Userfunction {
    public String getName() { return "set-hp-state"; }
    public Value call(ValueVector vv, Context c)
        throws JessException {        
        int heatPump = vv.get(1).intValue(c);
        Simulator sim = InitSimulator.getSimulator(c);                
        String szState = vv.get(2).stringValue(c);
        try {
            int state = State.heatpump(szState);
            sim.setHeatPumpState(heatPump, state);
        
        } catch (IllegalArgumentException iae) {
            throw new JessException("set-hp-state",
                                    "Invalid  state",
                                    szState);
        }
        return Funcall.TRUE;
    }
}
