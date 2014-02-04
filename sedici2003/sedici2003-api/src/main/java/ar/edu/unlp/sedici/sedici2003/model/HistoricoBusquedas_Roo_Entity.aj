// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import ar.edu.unlp.sedici.sedici2003.model.HistoricoBusquedas;
import java.lang.Long;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EntityManager;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PersistenceContext;
import javax.persistence.Table;
import org.springframework.transaction.annotation.Transactional;

privileged aspect HistoricoBusquedas_Roo_Entity {
    
    declare @type: HistoricoBusquedas: @Entity;
    
    declare @type: HistoricoBusquedas: @Table(name = "historico_busquedas");
    
    @PersistenceContext
    transient EntityManager HistoricoBusquedas.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long HistoricoBusquedas.id;
    
    public Long HistoricoBusquedas.getId() {
        return this.id;
    }
    
    public void HistoricoBusquedas.setId(Long id) {
        this.id = id;
    }
    
    @Transactional
    public void HistoricoBusquedas.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void HistoricoBusquedas.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            HistoricoBusquedas attached = HistoricoBusquedas.findHistoricoBusquedas(this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void HistoricoBusquedas.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void HistoricoBusquedas.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public HistoricoBusquedas HistoricoBusquedas.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        HistoricoBusquedas merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager HistoricoBusquedas.entityManager() {
        EntityManager em = new HistoricoBusquedas().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long HistoricoBusquedas.countHistoricoBusquedases() {
        return entityManager().createQuery("SELECT COUNT(o) FROM HistoricoBusquedas o", Long.class).getSingleResult();
    }
    
    public static List<HistoricoBusquedas> HistoricoBusquedas.findAllHistoricoBusquedases() {
        return entityManager().createQuery("SELECT o FROM HistoricoBusquedas o", HistoricoBusquedas.class).getResultList();
    }
    
    public static HistoricoBusquedas HistoricoBusquedas.findHistoricoBusquedas(Long id) {
        if (id == null) return null;
        return entityManager().find(HistoricoBusquedas.class, id);
    }
    
    public static List<HistoricoBusquedas> HistoricoBusquedas.findHistoricoBusquedasEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM HistoricoBusquedas o", HistoricoBusquedas.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}