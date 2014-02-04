// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import ar.edu.unlp.sedici.sedici2003.model.Unidades;
import java.lang.Integer;
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

privileged aspect Unidades_Roo_Entity {
    
    declare @type: Unidades: @Entity;
    
    declare @type: Unidades: @Table(name = "unidades");
    
    @PersistenceContext
    transient EntityManager Unidades.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "Id")
    private Integer Unidades.id;
    
    public Integer Unidades.getId() {
        return this.id;
    }
    
    public void Unidades.setId(Integer id) {
        this.id = id;
    }
    
    @Transactional
    public void Unidades.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Unidades.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Unidades attached = Unidades.findUnidades(this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Unidades.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void Unidades.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public Unidades Unidades.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Unidades merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager Unidades.entityManager() {
        EntityManager em = new Unidades().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Unidades.countUnidadeses() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Unidades o", Long.class).getSingleResult();
    }
    
    public static List<Unidades> Unidades.findAllUnidadeses() {
        return entityManager().createQuery("SELECT o FROM Unidades o", Unidades.class).getResultList();
    }
    
    public static Unidades Unidades.findUnidades(Integer id) {
        if (id == null) return null;
        return entityManager().find(Unidades.class, id);
    }
    
    public static List<Unidades> Unidades.findUnidadesEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Unidades o", Unidades.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}