package fuzzy;

import nrc.fuzzy.*;

public class Vent extends BeanSupport {

    private Hardware m_hardware;
    private int m_floor;       
    
    private static FuzzyVariable m_ventChangeFV = null;
    
    static {
    	    try {
    			m_ventChangeFV = new FuzzyVariable("ventChange", -1, 1);
    	    }
    	    catch (InvalidFuzzyVariableNameException nameEx) {}
    	    catch (InvalidUODRangeException rangeEx) {}
    	    
    	    try {
    	    	m_ventChangeFV.addTerm("NB", new SingletonFuzzySet(-0.3));
    	    	m_ventChangeFV.addTerm("NM", new SingletonFuzzySet(-0.15));
    	    	m_ventChangeFV.addTerm("NS", new SingletonFuzzySet(-0.06));
    	    	m_ventChangeFV.addTerm("Z",   new SingletonFuzzySet(0.0));
    	    	m_ventChangeFV.addTerm("PS", new SingletonFuzzySet(0.06));
    	    	m_ventChangeFV.addTerm("PM", new SingletonFuzzySet(0.15));
    	    	m_ventChangeFV.addTerm("PB",  new SingletonFuzzySet(0.3));
    	    }
    	    catch (XValuesOutOfOrderException outOfOrderEx) { }
    	    catch (XValueOutsideUODException outsideOUD) { }
    }

    public Vent(Hardware hw, int floor) {
        m_hardware = hw;
        m_floor = floor;
    }

    public static FuzzyVariable getVentChangeFuzzyVariable() {
    	return m_ventChangeFV;
    }
    
    public int getFloor() {
        return m_floor;
    }

    public double getState() {
        return m_hardware.getVentState(m_floor);
    }
    
    public void changeState(double stateChange) {
        m_hardware.changeVentState(m_floor, stateChange);
    }
}

        
