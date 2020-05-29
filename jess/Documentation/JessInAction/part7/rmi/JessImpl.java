/**
 * Simple Jess server
 */

import java.rmi.*;
import java.rmi.server.*;
import jess.*;

public class JessImpl extends UnicastRemoteObject implements Jess {
    private Rete m_rete = new Rete();

    JessImpl() throws RemoteException {}

    public Value executeCommand(String command)
        throws JessException {
        return m_rete.executeCommand(command);
    }

    public void store(String name, Object object) {
        m_rete.store(name, object);
    }

    public Value fetch(String name) {
        return m_rete.fetch(name);
    }
    
    public void definstance(String jessTypename,
                            Object object, boolean dynamic)
        throws JessException {
        m_rete.definstance(jessTypename, object, dynamic);
    }

    public void undefinstance(Object object) 
        throws JessException {
        m_rete.undefinstance(object);        
    }

    public void defclass(String jessName, String clazz, String parent) 
        throws JessException {
        m_rete.defclass(jessName, clazz, parent);
    }
}
