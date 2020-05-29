import java.rmi.*;

interface JessFactory extends Remote {
    Jess create() throws RemoteException;
}
