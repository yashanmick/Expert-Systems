/**
 * The remote interface for our Jess server.
 */

import java.rmi.*;
import jess.*;

interface Jess extends Remote {
    Value executeCommand(String command)
        throws RemoteException, JessException;

    void store(String name, Object object) throws RemoteException;

    Value fetch(String name) throws RemoteException;

    void definstance(String jessTypename, Object object, boolean dynamic)
        throws RemoteException, JessException;
    
    void undefinstance(Object object) 
        throws RemoteException, JessException;

    void defclass(String jessName, String clazz, String parent) 
        throws RemoteException, JessException;
}
