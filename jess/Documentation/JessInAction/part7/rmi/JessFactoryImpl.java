import jess.*;
import java.rmi.*;
import java.rmi.server.*;

public class JessFactoryImpl extends UnicastRemoteObject
    implements JessFactory {
    
    private JessFactoryImpl() throws RemoteException {
    }
    
    public Jess create() throws RemoteException {
        return new JessImpl();
    }

    public static void main(String[] argv) throws Exception {
        JessFactoryImpl impl = new JessFactoryImpl();
        Naming.rebind("Jess", impl);        
    }
    
}
