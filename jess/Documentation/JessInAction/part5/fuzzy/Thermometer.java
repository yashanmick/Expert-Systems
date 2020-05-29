package fuzzy;

import nrc.fuzzy.*;

public class Thermometer extends BeanSupport
    implements Runnable {

    private Hardware m_hardware;
    private int m_floor;       
    private double m_oldReading;
    private FuzzyValue m_fuzzyReading;
    private FuzzyValue m_fuzzyReadingRateOfChange;
    
    private static FuzzyVariable m_thermometerFV = null;
    private static FuzzyVariable m_thermometerRateOfChangeFV = null;
    
    static {
    	    try {
    			m_thermometerFV = new FuzzyVariable("thermometer", 0, 120);
    	    }
    	    catch (InvalidFuzzyVariableNameException nameEx) {}
    	    catch (InvalidUODRangeException rangeEx) {}
    	    
    	    SetThermometerFVTerms(70.0);
    	    
    	    try {
    			m_thermometerRateOfChangeFV = new FuzzyVariable("thermometerRateofChange", -10, 10);
    	    }
    	    catch (InvalidFuzzyVariableNameException nameEx) {}
    	    catch (InvalidUODRangeException rangeEx) {}

    	    try {
    	    	m_thermometerRateOfChangeFV.addTerm("decreasing", new RFuzzySet(-0.10,0.0,new RightLinearFunction()));
    	    	m_thermometerRateOfChangeFV.addTerm("zero", new TriangleFuzzySet(-0.10,0,0.10));
    	    	m_thermometerRateOfChangeFV.addTerm("increasing", new LFuzzySet(0.0, 0.10,new LeftLinearFunction()));
    	    }
    	    catch (XValuesOutOfOrderException outOfOrderEx) {}
    	    catch (XValueOutsideUODException outsideOUD) {}
    }

    public Thermometer(Hardware hw, int floor) {
        m_hardware = hw;
        m_floor = floor;
        new Thread(this).start();
    }

    public int getFloor() {
        return m_floor;
    }

    public double getReading() {
        return m_hardware.getTemperature(m_floor);
    }

    public FuzzyValue getFuzzyReading() {
        return m_fuzzyReading;
    }

    public FuzzyValue getFuzzyReadingRateOfChange() {
        return m_fuzzyReadingRateOfChange;
    }
    
    public static void SetThermometerFVTerms( double setPoint) {
    	try {
    	      m_thermometerFV.addTerm("cold", 
    	   	   new RFuzzySet(setPoint-1.5,setPoint-1,new RightLinearFunction()));
    	      m_thermometerFV.addTerm("cool", 
    	           new TriangleFuzzySet(setPoint-1.5,setPoint-1,setPoint));
    	      m_thermometerFV.addTerm("OK",   
    	           new TriangleFuzzySet(setPoint-1,setPoint,setPoint+1));
    	      m_thermometerFV.addTerm("warm", 
    	           new TriangleFuzzySet(setPoint,setPoint+1,setPoint+1.5));
    	      m_thermometerFV.addTerm("hot",  
    	           new LFuzzySet(setPoint+1,setPoint+1.5,new LeftLinearFunction()));
    	}
    	catch (XValuesOutOfOrderException outOfOrderEx) {}
    	catch (XValueOutsideUODException outsideOUD) {}
    }

    public void run() {
    	boolean firstLoopDone = false;
        while (true) {
            double reading = getReading();
            double rateOfChange = firstLoopDone ? reading-m_oldReading : 0.0;
            boolean readingChanged = (reading != m_oldReading);
            m_pcs.firePropertyChange("reading",
                                   new Double(m_oldReading),
                                   new Double(reading));
            m_oldReading = reading;
            if (readingChanged) {
            	try {
            		m_fuzzyReading = new FuzzyValue(m_thermometerFV,new SingletonFuzzySet(reading));
            	}
            	catch (XValuesOutOfOrderException xvorder) 
            		{System.out.println("Error: " + xvorder); return;} 
            	catch (XValueOutsideUODException xvuod) 
            		{System.out.println("Error: " + xvuod); return;}
                // do NOT use old value when notifying of changes to FuzzyValues.
                // firePropertyChange will not pass it on since FuzzyValues with
                // the same FuzzyVariable are considered to be EQUAL ... even if
                // they have different fuzzysets!!
            	m_pcs.firePropertyChange("fuzzyReading",
                                   null,
                                   (Object)m_fuzzyReading);
            }
            try {
            	m_fuzzyReadingRateOfChange = 
            		new FuzzyValue(m_thermometerRateOfChangeFV,new SingletonFuzzySet(rateOfChange));
           	   }
           	catch (XValuesOutOfOrderException xvorder) 
            	{System.out.println("Error: " + xvorder); return;} 
            catch (XValueOutsideUODException xvuod) 
            	{System.out.println("Error: " + xvuod); return;} 
            // do NOT use old value when notifying of changes to FuzzyValues.
            // firePropertyChange will not pass it on since FuzzyValues with
            // the same FuzzyVariable are considered to be EQUAL ... even if
            // they have different fuzzysets!!
            m_pcs.firePropertyChange("fuzzyReadingRateOfChange",
                                   null,
                                   (Object)m_fuzzyReadingRateOfChange);
            
            firstLoopDone = true;
            
            try { Thread.sleep(1000); }
            catch (InterruptedException ie) { return; }        
        }
    }

}

        
