// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import java.lang.String;

privileged aspect Documentos_Roo_ToString {
    
    public String Documentos.toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("AbstractEn: ").append(getAbstractEn()).append(", ");
        sb.append("AbstractEs: ").append(getAbstractEs()).append(", ");
        sb.append("AbstractPt: ").append(getAbstractPt()).append(", ");
        sb.append("Bajadas: ").append(getBajadas()).append(", ");
        sb.append("Difusion: ").append(getDifusion()).append(", ");
        sb.append("FechaDisponibilidad: ").append(getFechaDisponibilidad()).append(", ");
        sb.append("FechaHoraActualizacion: ").append(getFechaHoraActualizacion()).append(", ");
        sb.append("FechaHoraCreacion: ").append(getFechaHoraCreacion()).append(", ");
        sb.append("Id: ").append(getId()).append(", ");
        sb.append("IdDependencia: ").append(getIdDependencia()).append(", ");
        sb.append("IdEstado: ").append(getIdEstado()).append(", ");
        sb.append("IdInstitucion: ").append(getIdInstitucion()).append(", ");
        sb.append("IdOwner: ").append(getIdOwner()).append(", ");
        sb.append("IdPadreDoc: ").append(getIdPadreDoc()).append(", ");
        sb.append("IdPais: ").append(getIdPais()).append(", ");
        sb.append("IdTipodocumento: ").append(getIdTipodocumento()).append(", ");
        sb.append("IdUnidad: ").append(getIdUnidad()).append(", ");
        sb.append("IpNorestringidas: ").append(getIpNorestringidas()).append(", ");
        sb.append("IpNorestringidas1: ").append(getIpNorestringidas1()).append(", ");
        sb.append("IpNorestringidas2: ").append(getIpNorestringidas2()).append(", ");
        sb.append("LinkLogo: ").append(getLinkLogo()).append(", ");
        sb.append("Logo: ").append(getLogo());
        return sb.toString();
    }
    
}