// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import java.lang.String;

privileged aspect PlantillaCorreo_Roo_ToString {
    
    public String PlantillaCorreo.toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Asunto: ").append(getAsunto()).append(", ");
        sb.append("Codigo: ").append(getCodigo()).append(", ");
        sb.append("Id: ").append(getId()).append(", ");
        sb.append("Texto: ").append(getTexto());
        return sb.toString();
    }
    
}
