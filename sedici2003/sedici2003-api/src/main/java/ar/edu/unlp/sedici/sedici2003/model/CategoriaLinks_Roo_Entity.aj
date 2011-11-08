// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import ar.edu.unlp.sedici.sedici2003.model.CategoriaLinks;
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

privileged aspect CategoriaLinks_Roo_Entity {
    
    declare @type: CategoriaLinks: @Entity;
    
    declare @type: CategoriaLinks: @Table(name = "categoria_links");
    
    @PersistenceContext
    transient EntityManager CategoriaLinks.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id_cat_link")
    private Integer CategoriaLinks.idCatLink;
    
    public Integer CategoriaLinks.getIdCatLink() {
        return this.idCatLink;
    }
    
    public void CategoriaLinks.setIdCatLink(Integer id) {
        this.idCatLink = id;
    }
    
    @Transactional
    public void CategoriaLinks.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void CategoriaLinks.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            CategoriaLinks attached = CategoriaLinks.findCategoriaLinks(this.idCatLink);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void CategoriaLinks.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void CategoriaLinks.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public CategoriaLinks CategoriaLinks.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        CategoriaLinks merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager CategoriaLinks.entityManager() {
        EntityManager em = new CategoriaLinks().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long CategoriaLinks.countCategoriaLinkses() {
        return entityManager().createQuery("SELECT COUNT(o) FROM CategoriaLinks o", Long.class).getSingleResult();
    }
    
    public static List<CategoriaLinks> CategoriaLinks.findAllCategoriaLinkses() {
        return entityManager().createQuery("SELECT o FROM CategoriaLinks o", CategoriaLinks.class).getResultList();
    }
    
    public static CategoriaLinks CategoriaLinks.findCategoriaLinks(Integer idCatLink) {
        if (idCatLink == null) return null;
        return entityManager().find(CategoriaLinks.class, idCatLink);
    }
    
    public static List<CategoriaLinks> CategoriaLinks.findCategoriaLinksEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM CategoriaLinks o", CategoriaLinks.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}
