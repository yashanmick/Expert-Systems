package jess_interface;


import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.JButton;

public class Jess extends JFrame {

	private JPanel contentPane;
	private JTextField number1;
	private JTextField number2;
	private JTextField txtArea;
	
	
	
	

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Jess frame = new Jess();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public Jess() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JLabel lblNewLabel = new JLabel("Label 1");
		lblNewLabel.setBounds(25, 54, 46, 14);
		contentPane.add(lblNewLabel);
		
		JLabel label = new JLabel("Label 2");
		label.setBounds(25, 124, 46, 14);
		contentPane.add(label);
		
		number1 = new JTextField();
		number1.setBounds(131, 51, 86, 20);
		contentPane.add(number1);
		number1.setColumns(10);
		
		number2 = new JTextField();
		number2.setColumns(10);
		number2.setBounds(131, 121, 86, 20);
		contentPane.add(number2);
		
		JButton btnNewButton = new JButton("Button 1");
		btnNewButton.setBounds(281, 50, 89, 23);
		contentPane.add(btnNewButton);
		
		JButton button = new JButton("Button 2");
		button.setBounds(281, 120, 89, 23);
		contentPane.add(button);
		
		txtArea = new JTextField();
		txtArea.setColumns(10);
		txtArea.setBounds(131, 184, 239, 66);
		contentPane.add(txtArea);
	}
}


