package fuzzy;

public class State {
    public static final String

        OFF="off",
        HEATING="heating",
        COOLING="cooling";
        
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
