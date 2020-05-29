package control;

public class State {
    public static final String
        OPEN="open",
        CLOSED="closed",
        OFF="off",
        HEATING="heating",
        COOLING="cooling";
        
    public static String vent(double val) {
        return val == 0 ? CLOSED : OPEN;
    }
    
    public static double vent(String val) {
        if (val.equals(OPEN))
            return 1;
        else if (val.equals(CLOSED))
            return 0;
        else
            throw new IllegalArgumentException(val);
    }

    public static String heatpump(int val) {
        switch(val) {
        case Hardware.OFF:
            return OFF;
        case Hardware.HEATING:
            return HEATING;
        case Hardware.COOLING:
            return COOLING;
        default:
            throw new IllegalArgumentException(String.valueOf(val));
        }
    }

    public static int heatpump(String val) {
        if (val.equals(OFF))
            return Hardware.OFF;
        else if (val.equals(HEATING))
            return Hardware.HEATING;
        else if (val.equals(COOLING))
            return Hardware.COOLING;
        else
            throw new IllegalArgumentException(val);
    }
}
