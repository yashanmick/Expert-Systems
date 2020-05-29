package fuzzy;
import jess.*;

public class HardwareFunctions implements Userpackage {
    public void add(Rete engine) {
        engine.addUserfunction(new InitSimulator());
        engine.addUserfunction(new CountDevices(CountDevices.N_HEATPUMPS));
        engine.addUserfunction(new CountDevices(CountDevices.N_FLOORS));
        engine.addUserfunction(new WhichPump());
        engine.addUserfunction(new ReadHeatPump());
        engine.addUserfunction(new WriteHeatPump());
        engine.addUserfunction(new ReadVent());
        engine.addUserfunction(new WriteVent());
    }
}
