package control;
import jess.*;

class CountDevices implements Userfunction {
    static final String N_HEATPUMPS = "n-heatpumps";
    static final String N_FLOORS = "n-floors";
    private String m_name;
    public CountDevices(String name) {
        m_name = name;
    }
    public String getName() { return m_name; }
    public Value call(ValueVector vv, Context c)
        throws JessException {
        Simulator sim = InitSimulator.getSimulator(c);
        int nHeatPumps = sim.getNumberOfHeatPumps();
        if (m_name.equals(N_HEATPUMPS))
            return new Value(nHeatPumps, RU.INTEGER);        
        else
            return new Value(nHeatPumps*3, RU.INTEGER);
    }
}
