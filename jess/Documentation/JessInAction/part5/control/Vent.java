package control;

public class Vent extends BeanSupport
    implements Runnable {

    private Hardware m_hardware;
    private int m_floor;       
    private double m_oldState;

    public Vent(Hardware hw, int floor) {
        m_hardware = hw;
        m_floor = floor;
        new Thread(this).start();
    }

    public int getFloor() {
        return m_floor;
    }

    public String getState() {
        return State.vent(m_hardware.getVentState(m_floor));
    }

    public void setState(String szState) {
        double state = State.vent(szState);
        m_hardware.setVentState(m_floor, state);
        m_pcs.firePropertyChange("state",
                                 State.vent(m_oldState),
                                 szState);
        m_oldState = state;
    }

    public void run() {
        while (true) {
            double state = m_hardware.getVentState(m_floor);
            m_pcs.firePropertyChange("state",
                                   State.vent(m_oldState),
                                   State.vent(state));
            m_oldState = state;
            try { Thread.sleep(1000); }
            catch (InterruptedException ie) { return; }        
        }
    }

}

        
