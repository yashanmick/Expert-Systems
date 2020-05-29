package control;
import jess.*;

class ReadHeatPump implements Userfunction {
    public String getName() { return "get-hp-state"; }
    public Value call(ValueVector vv, Context c)
        throws JessException {        
        int heatPump = vv.get(1).intValue(c);
        Simulator sim = InitSimulator.getSimulator(c);
        int state = sim.getHeatPumpState(heatPump);
        try {
            return new Value(State.heatpump(state), RU.ATOM);
        } catch (IllegalArgumentException iae) {
            throw new JessException("get-hp-state",
                                    "Unexpected  state",
                                    state);
        }
    }
}
