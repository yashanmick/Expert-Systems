package control;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

/**
 * Note: this GUI can consume a lot of CPU power while updating,
 * especially if there are very many (near 100 or more) floors. JDK
 * 1.4.x works much better than 1.3.x, as 1.4 has dramatically better
 * Swing performance.
 */

public class SimulatorGUI implements Runnable{
    private Simulator m_simulator;
    private JLabel[][] m_labels;
    private JTextField m_outdoorField = new JTextField();
    private int m_nFloors;
    public SimulatorGUI(Simulator s) {
        m_simulator = s;
        m_nFloors = m_simulator.getNumberOfHeatPumps()*3;
            
        JFrame frame = new JFrame();
        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        JPanel panel = new JPanel();
        panel.setLayout(new GridLayout(m_nFloors, 3));
        m_labels = new JLabel[m_nFloors][3];
        for (int i=0; i<m_nFloors; ++i)
            for (int j=0; j<3; ++j) {
                m_labels[i][j] = new JLabel();
                panel.add(m_labels[i][j]);
            }
        
        String text =
            String.valueOf(m_simulator.m_outdoor);
        m_outdoorField.setText(text);   

        m_outdoorField.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent ae) {
                    double value =
                        Double.parseDouble(m_outdoorField.getText());
                    m_simulator.m_outdoor = value;
                }
            });

        Container content = frame.getContentPane();
        content.setLayout(new BorderLayout());
        content.add(panel, BorderLayout.CENTER);
        content.add(m_outdoorField, BorderLayout.SOUTH);

        new Thread(this).start();

        frame.pack();
        frame.setVisible(true);        
    }        

    public void run() {
        while(true) {
            for (int i=0; i<m_nFloors; ++i) {
                int hpState = m_simulator.getHeatPumpState(i/3+1);
                m_labels[i][0].setText(State.heatpump(hpState));
                
                double ventState = m_simulator.getVentState(i+1);
                m_labels[i][1].setText(State.vent(ventState));

                double temperature = m_simulator.getTemperature(i+1);
                m_labels[i][2].setText(String.valueOf(temperature));
            }
            try {
                Thread.sleep(100);
            } catch (InterruptedException ie) {
                return;
            }
        }
    }

    public static void main(String[] argv) {
        Simulator s = new Simulator(9);
        SimulatorGUI gui = new SimulatorGUI(s);
    }
}
