// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import ar.edu.unlp.sedici.sedici2003.model.Link;
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

privileged aspect Link_Roo_Entity {
    
    declare @type: Link: @Entity;
    
    declare @type: Link: @Table(name = "link");
    
    @PersistenceContext
    transient EntityManager Link.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "Id")
    private Integer Link.id;
    
    public Integer Link.getId() {
        return this.id;
    }
    
    public void Link.setId(Integer id) {
        this.id = id;
    }
    
    @Transactional
    public void Link.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Link.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Link attached = Link.findLink(this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Link.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void Link.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public Link Link.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Link merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager Link.entityManager() {
        EntityManager em = new Link().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Link.countLinks() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Link o", Long.class).getSingleResult();
    }
    
    public static List<Link> Link.findAllLinks() {
        return entityManager().createQuery("SELECT o FROM Link o", Link.class).getResultList();
    }
    
    public static Link Link.findLink(Integer id) {
        if (id == null) return null;
        return entityManager().find(Link.class, id);
    }
    
    public static List<Link> Link.findLinkEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Link o", Link.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}
