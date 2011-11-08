// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import ar.edu.unlp.sedici.sedici2003.model.Documentos;
import java.lang.String;
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

privileged aspect Documentos_Roo_Entity {
    
    declare @type: Documentos: @Entity;
    
    declare @type: Documentos: @Table(name = "documentos");
    
    @PersistenceContext
    transient EntityManager Documentos.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", length = 100)
    private String Documentos.id;
    
    public String Documentos.getId() {
        return this.id;
    }
    
    public void Documentos.setId(String id) {
        this.id = id;
    }
    
    @Transactional
    public void Documentos.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Documentos.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Documentos attached = Documentos.findDocumentos(this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Documentos.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void Documentos.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public Documentos Documentos.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Documentos merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager Documentos.entityManager() {
        EntityManager em = new Documentos().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Documentos.countDocumentoses() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Documentos o", Long.class).getSingleResult();
    }
    
    public static List<Documentos> Documentos.findAllDocumentoses() {
        return entityManager().createQuery("SELECT o FROM Documentos o", Documentos.class).getResultList();
    }
    
    public static Documentos Documentos.findDocumentos(String id) {
        if (id == null || id.length() == 0) return null;
        return entityManager().find(Documentos.class, id);
    }
    
    public static List<Documentos> Documentos.findDocumentosEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Documentos o", Documentos.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}
