package fuzzy;
import java.util.Arrays;

public class Simulator implements Hardware, Runnable {

    private int[] m_heatpumps;
    private double[] m_vents;
    private double[] m_temperature;
    
    private final double RATE = 0.01;
    private final double HOT = 100;
    private final double COLD = 50;
    double m_outdoor = 90;

    public Simulator(int numberOfFloors, double setPoint) {
        if (numberOfFloors % 3 != 0)
            throw new RuntimeException("Illegal value");

        m_heatpumps = new int[numberOfFloors/3];
        m_vents = new double[numberOfFloors];
        m_temperature = new double[numberOfFloors];
        Arrays.fill(m_temperature, setPoint);
        Thermometer.SetThermometerFVTerms(setPoint);
        new Thread(this).start();
    }
    
    public int getHeatPumpState(int heatPump) {
        return m_heatpumps[heatPump-1];
    }

    public void setHeatPumpState(int heatPump, int state) {
        switch (state) {
        case OFF: case HEATING: case COOLING:
            m_heatpumps[heatPump-1] = state; break;
        default:
            throw new RuntimeException("Illegal value");
        }
    }

    public int getNumberOfHeatPumps() {
        return m_heatpumps.length;
    }

    public double getVentState(int vent) {
        return m_vents[vent-1];
    }

    public void changeVentState(int vent, double stateChange) {
    	int ventIndex = vent-1;
    	// must always be between 0 and 1
        m_vents[ventIndex] = Math.max(0.0, Math.min(1.0, m_vents[ventIndex]+stateChange));
    }
    
    public double getTemperature(int sensor) {
        return m_temperature[sensor-1];
    }

    public void run() {
        while (true) {
            for (int i=0; i<m_temperature.length; ++i) {
                double temperature = m_temperature[i];
                
                // Leakage
                temperature += (m_outdoor-temperature)*RATE/2;
                
                // Heating and cooling, and heat rising
                switch (state(i)) {
                case HEATING:
                    temperature +=
                        (HOT-temperature)*RATE*getVentState(i+1) ; break;
                case COOLING:
                    temperature +=
                        (COLD-temperature)*RATE*getVentState(i+1); break;
                case OFF:
                    temperature += (i+1)*0.005;
                }
                
                m_temperature[i] = temperature;
            }
            
            try {Thread.sleep(1000);}
            catch (InterruptedException ie) { return;}
        }
    }        
    
    private int state(int floor) {
        if (getVentState(floor + 1) > 0)
            return getHeatPumpState(floor/3 + 1);
        else
            return OFF;
    }
}
