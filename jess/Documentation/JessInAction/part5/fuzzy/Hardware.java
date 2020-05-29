package fuzzy;

public interface Hardware {

    public final int OFF=0, HEATING=1, COOLING=2;

    int getHeatPumpState(int heatPump);
    void setHeatPumpState(int heatPump, int state);
    int getNumberOfHeatPumps();
    
    double getTemperature(int sensor);
    
    double getVentState(int vent);
    void changeVentState(int vent, double state);
}
