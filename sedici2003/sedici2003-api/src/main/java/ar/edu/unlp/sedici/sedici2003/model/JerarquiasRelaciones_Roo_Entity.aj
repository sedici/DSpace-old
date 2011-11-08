// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import ar.edu.unlp.sedici.sedici2003.model.JerarquiasRelaciones;
import ar.edu.unlp.sedici.sedici2003.model.JerarquiasRelacionesPK;
import java.util.List;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Table;
import org.springframework.transaction.annotation.Transactional;

privileged aspect JerarquiasRelaciones_Roo_Entity {
    
    declare @type: JerarquiasRelaciones: @Entity;
    
    declare @type: JerarquiasRelaciones: @Table(name = "jerarquias_relaciones");
    
    @PersistenceContext
    transient EntityManager JerarquiasRelaciones.entityManager;
    
    @EmbeddedId
    private JerarquiasRelacionesPK JerarquiasRelaciones.id;
    
    public JerarquiasRelacionesPK JerarquiasRelaciones.getId() {
        return this.id;
    }
    
    public void JerarquiasRelaciones.setId(JerarquiasRelacionesPK id) {
        this.id = id;
    }
    
    @Transactional
    public void JerarquiasRelaciones.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void JerarquiasRelaciones.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            JerarquiasRelaciones attached = JerarquiasRelaciones.findJerarquiasRelaciones(this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void JerarquiasRelaciones.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void JerarquiasRelaciones.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public JerarquiasRelaciones JerarquiasRelaciones.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        JerarquiasRelaciones merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager JerarquiasRelaciones.entityManager() {
        EntityManager em = new JerarquiasRelaciones().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long JerarquiasRelaciones.countJerarquiasRelacioneses() {
        return entityManager().createQuery("SELECT COUNT(o) FROM JerarquiasRelaciones o", Long.class).getSingleResult();
    }
    
    public static List<JerarquiasRelaciones> JerarquiasRelaciones.findAllJerarquiasRelacioneses() {
        return entityManager().createQuery("SELECT o FROM JerarquiasRelaciones o", JerarquiasRelaciones.class).getResultList();
    }
    
    public static JerarquiasRelaciones JerarquiasRelaciones.findJerarquiasRelaciones(JerarquiasRelacionesPK id) {
        if (id == null) return null;
        return entityManager().find(JerarquiasRelaciones.class, id);
    }
    
    public static List<JerarquiasRelaciones> JerarquiasRelaciones.findJerarquiasRelacionesEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM JerarquiasRelaciones o", JerarquiasRelaciones.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}
