// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import java.lang.String;

privileged aspect Instituciones_Roo_ToString {
    
    public String Instituciones.toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Abreviatura: ").append(getAbreviatura()).append(", ");
        sb.append("Comentarios: ").append(getComentarios()).append(", ");
        sb.append("Direccion: ").append(getDireccion()).append(", ");
        sb.append("Id: ").append(getId()).append(", ");
        sb.append("IdPais: ").append(getIdPais()).append(", ");
        sb.append("Nombre: ").append(getNombre()).append(", ");
        sb.append("SitioWeb: ").append(getSitioWeb()).append(", ");
        sb.append("Telefono: ").append(getTelefono());
        return sb.toString();
    }
    
}
