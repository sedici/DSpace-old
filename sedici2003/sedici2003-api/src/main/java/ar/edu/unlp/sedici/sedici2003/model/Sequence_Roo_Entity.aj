// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import ar.edu.unlp.sedici.sedici2003.model.Sequence;
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

privileged aspect Sequence_Roo_Entity {
    
    declare @type: Sequence: @Entity;
    
    declare @type: Sequence: @Table(name = "SEQUENCE");
    
    @PersistenceContext
    transient EntityManager Sequence.entityManager;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "SEQ_NAME", length = 50)
    private String Sequence.seqName;
    
    public String Sequence.getSeqName() {
        return this.seqName;
    }
    
    public void Sequence.setSeqName(String id) {
        this.seqName = id;
    }
    
    @Transactional
    public void Sequence.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Sequence.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Sequence attached = Sequence.findSequence(this.seqName);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Sequence.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void Sequence.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public Sequence Sequence.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Sequence merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
    public static final EntityManager Sequence.entityManager() {
        EntityManager em = new Sequence().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Sequence.countSequences() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Sequence o", Long.class).getSingleResult();
    }
    
    public static List<Sequence> Sequence.findAllSequences() {
        return entityManager().createQuery("SELECT o FROM Sequence o", Sequence.class).getResultList();
    }
    
    public static Sequence Sequence.findSequence(String seqName) {
        if (seqName == null || seqName.length() == 0) return null;
        return entityManager().find(Sequence.class, seqName);
    }
    
    public static List<Sequence> Sequence.findSequenceEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Sequence o", Sequence.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
}