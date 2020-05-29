import java.rmi.*;

public class JessClient {
    public static void main(String[] argv) throws Exception {
        System.setSecurityManager(new RMISecurityManager());
        JessFactory factory = (JessFactory) Naming.lookup("Jess");
        Jess jess = factory.create();
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<argv.length; ++i) {
            sb.append(argv[i]);
            sb.append(" ");
        }
        System.out.println(jess.executeCommand(sb.toString()));        
    }
}
