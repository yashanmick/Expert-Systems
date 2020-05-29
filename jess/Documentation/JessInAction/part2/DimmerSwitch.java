public class DimmerSwitch { 
    private int brightness = 0; 
    public int getBrightness() { return brightness; } 
    public void setBrightness(int b) { 
        brightness = b; 
        adjustTriac(b); 
    } 
    private void adjustTriac(int brightness) { 
        // Code not shown 
    } 
} 
