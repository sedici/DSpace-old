// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import java.lang.Integer;
import java.lang.String;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import org.springframework.format.annotation.DateTimeFormat;

privileged aspect OrdenesMail_Roo_DbManaged {
    
    @Column(name = "cant_destinatarios")
    private Integer OrdenesMail.cantDestinatarios;
    
    @Column(name = "fecha_hora")
    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(style = "M-")
    private Date OrdenesMail.fechaHora;
    
    @Column(name = "id_plantilla")
    private Integer OrdenesMail.idPlantilla;
    
    @Column(name = "texto_plantilla", length = 255)
    private String OrdenesMail.textoPlantilla;
    
    public Integer OrdenesMail.getCantDestinatarios() {
        return this.cantDestinatarios;
    }
    
    public void OrdenesMail.setCantDestinatarios(Integer cantDestinatarios) {
        this.cantDestinatarios = cantDestinatarios;
    }
    
    public Date OrdenesMail.getFechaHora() {
        return this.fechaHora;
    }
    
    public void OrdenesMail.setFechaHora(Date fechaHora) {
        this.fechaHora = fechaHora;
    }
    
    public Integer OrdenesMail.getIdPlantilla() {
        return this.idPlantilla;
    }
    
    public void OrdenesMail.setIdPlantilla(Integer idPlantilla) {
        this.idPlantilla = idPlantilla;
    }
    
    public String OrdenesMail.getTextoPlantilla() {
        return this.textoPlantilla;
    }
    
    public void OrdenesMail.setTextoPlantilla(String textoPlantilla) {
        this.textoPlantilla = textoPlantilla;
    }
    
}