/**
 * Copyright (C) 2011 SeDiCI <info@sedici.unlp.edu.ar>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package ar.edu.unlp.sedici.dspace.authority;

import java.util.ArrayList;
import java.util.List;

import org.dspace.content.authority.Choice;

import ar.edu.unlp.sedici.sedici2003.model.Personas;

public class SeDiCI2003Authors extends SeDiCI2003AuthorityProvider{
	
	@Override
	protected List<Choice> findSeDiCI2003Entities(String field, String text, int start, int limit, ChoiceFactory choiceFactory) {
		
		String[] parts = text.split(",",2);
		String apellido = parts[0].trim();
		String nombre = (parts.length == 2)?parts[1].trim():"";
		List<Personas> personas = Personas.findPersonasesByApellidoYNombre(apellido, nombre, start, limit);
		List<Choice> choices= new ArrayList<Choice>(personas.size());
		for (Personas p : personas) {
			String contextInfo = "";
			
			if(p.getInstitucion() != null) {
				contextInfo += p.getInstitucion().getNombre();
			}
			
			if(p.getDependencia() != null) {
				if(contextInfo != "")
					contextInfo += "; ";
				contextInfo += p.getDependencia().getNombre();
			}

			if(contextInfo != "")
				contextInfo = " ("+contextInfo+")";
			
			choices.add(choiceFactory.createChoice(String.valueOf(p.getId()), p.getApellidoYNombre(), p.getApellidoYNombre()+contextInfo));
		}
		return choices;
	}
	
	@Override
	protected int findSeDiCI2003EntitiesCount(String field, String text) {
		
		String[] parts = text.split(",",2);
		String apellido = parts[0].trim();
		String nombre = (parts.length == 2)?parts[1].trim():"";
		int total = Personas.findPersonasesByApellidoYNombreCount(apellido, nombre);

		return total;
	}

	protected String getSeDiCI2003EntityLabel(String field, String key) {
		try {
			Personas p = Personas.findPersonas(Integer.valueOf(key));
			if (p == null){
				this.reportMissingAuthorityKey(field, key);
				return key;
			}else{
				return p.getApellidoYNombre();
			}
		} catch (NumberFormatException e) {
			//this.reportMissingAuthorityKey(field, key);
			return key;
		} 
		
	}
}
