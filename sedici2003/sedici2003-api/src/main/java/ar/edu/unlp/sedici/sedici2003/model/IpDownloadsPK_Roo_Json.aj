// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ar.edu.unlp.sedici.sedici2003.model;

import ar.edu.unlp.sedici.sedici2003.model.IpDownloadsPK;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.lang.String;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect IpDownloadsPK_Roo_Json {
    
    public String IpDownloadsPK.toJson() {
        return new JSONSerializer().exclude("*.class").serialize(this);
    }
    
    public static IpDownloadsPK IpDownloadsPK.fromJsonToIpDownloadsPK(String json) {
        return new JSONDeserializer<IpDownloadsPK>().use(null, IpDownloadsPK.class).deserialize(json);
    }
    
    public static String IpDownloadsPK.toJsonArray(Collection<IpDownloadsPK> collection) {
        return new JSONSerializer().exclude("*.class").serialize(collection);
    }
    
    public static Collection<IpDownloadsPK> IpDownloadsPK.fromJsonArrayToIpDownloadsPKs(String json) {
        return new JSONDeserializer<List<IpDownloadsPK>>().use(null, ArrayList.class).use("values", IpDownloadsPK.class).deserialize(json);
    }
    
}
