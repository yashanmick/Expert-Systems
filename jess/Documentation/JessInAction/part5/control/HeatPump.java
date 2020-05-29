package control;

public class HeatPump extends BeanSupport
    implements Runnable {

    private Hardware m_hardware;
    private int m_pump;       
    private int m_oldState;

    public HeatPump(Hardware hw, int pump) {
        m_hardware = hw;
        m_pump = pump;
        new Thread(this).start();
    }

    public int getNumber() {
        return m_pump;
    }

    public String getState() {
        return State.heatpump(m_hardware.getHeatPumpState(m_pump));
    }

    public void setState(String szState) {
        int state = State.heatpump(szState);
        m_hardware.setHeatPumpState(m_pump, state);
        m_pcs.firePropertyChange("state",
                                 State.heatpump(m_oldState),
                                 szState);
        m_oldState = state;
    }

    public void run() {
        while (true) {
            int state = m_hardware.getHeatPumpState(m_pump);
            m_pcs.firePropertyChange("state",
                                   State.heatpump(m_oldState),
                                   State.heatpump(state));
            m_oldState = state;
            try { Thread.sleep(1000); }
            catch (InterruptedException ie) { return; }        
        }
    }

}

        
