package fuzzy;
import jess.*;

public class InitSimulator implements Userfunction {
    static final String NAME = "init-simulator";
    private Simulator m_simulator;
    public static Simulator getSimulator(Context c) {
        Rete engine = c.getEngine();
        InitSimulator is =
            (InitSimulator) engine.findUserfunction(NAME);
        return is.m_simulator;
    }
    public String getName() { return NAME; }
    public Value call(ValueVector vv, Context c)
        throws JessException {
        int nFloors = vv.get(1).intValue(c);
        double setPoint = vv.get(2).floatValue(c);
        m_simulator = new Simulator(nFloors, setPoint);
        new SimulatorGUI(m_simulator);
        return new Value(m_simulator);
    }
}
