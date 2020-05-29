package control;

import java.beans.*;

public abstract class BeanSupport {
    protected PropertyChangeSupport m_pcs =
        new PropertyChangeSupport(this);

    public void addPropertyChangeListener(PropertyChangeListener pcl) {
        m_pcs.addPropertyChangeListener(pcl);
    }
    public void removePropertyChangeListener(PropertyChangeListener pcl) {
        m_pcs.removePropertyChangeListener(pcl);
    }
}
