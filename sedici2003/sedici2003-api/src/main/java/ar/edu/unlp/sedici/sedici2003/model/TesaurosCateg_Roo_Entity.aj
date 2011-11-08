// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import ar.edu.unlp.sedici.sedici2003.model.TesaurosCateg;
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

privileged aspect TesaurosCateg_Roo_Entity {
    
    declare @type: TesaurosCateg: @Entity;
    
    declare @type: TesaurosCateg: @Table(name = "tesauros_categ");
    
    @PersistenceContext
    transient EntityManager TesaurosCateg.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Integer TesaurosCateg.id;
    
    public Integer TesaurosCateg.getId() {
        return this.id;
    }
    
    public void TesaurosCateg.setId(Integer id) {
        this.id = id;
    }
    
    @Transactional
    public void TesaurosCateg.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void TesaurosCateg.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            TesaurosCateg attached = TesaurosCateg.findTesaurosCateg(this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void TesaurosCateg.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void TesaurosCateg.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public TesaurosCateg TesaurosCateg.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        TesaurosCateg merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager TesaurosCateg.entityManager() {
        EntityManager em = new TesaurosCateg().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long TesaurosCateg.countTesaurosCategs() {
        return entityManager().createQuery("SELECT COUNT(o) FROM TesaurosCateg o", Long.class).getSingleResult();
    }
    
    public static List<TesaurosCateg> TesaurosCateg.findAllTesaurosCategs() {
        return entityManager().createQuery("SELECT o FROM TesaurosCateg o", TesaurosCateg.class).getResultList();
    }
    
    public static TesaurosCateg TesaurosCateg.findTesaurosCateg(Integer id) {
        if (id == null) return null;
        return entityManager().find(TesaurosCateg.class, id);
    }
    
    public static List<TesaurosCateg> TesaurosCateg.findTesaurosCategEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM TesaurosCateg o", TesaurosCateg.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}
