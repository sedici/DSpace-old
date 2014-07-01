/**
 * Copyright (C) 2011 SeDiCI <info@sedici.unlp.edu.ar>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *          http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package ar.edu.unlp.sedici.aspect.extraSubmission;

import java.io.IOException;
import java.sql.SQLException;

import org.dspace.app.xmlui.aspect.xmlworkflow.AbstractXMLUIAction;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Button;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.Select;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.content.Item;
import org.dspace.core.Constants;
import org.xml.sax.SAXException;

import ar.edu.unlp.sedici.dspace.content.CollectionSearchSedici;
import ar.edu.unlp.sedici.dspace.content.CollectionsWithCommunities;

public class SeDiCISelectCollectionStep extends AbstractXMLUIAction {

	/** Language Strings */
    protected static final Message T_submission_head = message("sedici.XMLWorkflow.workflow.selectCollectionAction.head");
    protected static final Message T_head = message("xmlui.Submission.submit.SelectCollection.head");
    protected static final Message T_collection = message("xmlui.Submission.submit.SelectCollection.collection");
    protected static final Message T_collection_help = message("sedici.Submission.submit.SelectCollection.collection_help");
    protected static final Message T_collection_default = message("xmlui.Submission.submit.SelectCollection.collection_default");
    protected static final Message T_submit_next = message("sedici.XMLWorkflow.workflow.selectCollectionAction.complete");
    protected static final Message T_edit_submit = message("xmlui.XMLWorkflow.workflow.EditMetadataAction.edit_submit");
    
	
    public void addBody(Body body) throws SAXException, WingException, UIException, SQLException, IOException, AuthorizeException
    {  
        Item item = workflowItem.getItem();
        Collection collection = workflowItem.getCollection();
		String actionURL = contextPath + "/handle/"+collection.getHandle() + "/xmlworkflow";

		// Listado de colecciones disponibles
		CollectionsWithCommunities collections = CollectionSearchSedici.findAuthorizedWithCommunitiesName(context, null, Constants.ADD);
        
		// Formulario con la lista de colecciones
        Division div = body.addInteractiveDivision("select-collection",actionURL,Division.METHOD_POST,"primary submission");
		div.setHead(T_submission_head);
        
        List list = div.addList("select-collection", List.TYPE_FORM);
        list.setHead(T_head);
        Select select = list.addItem().addSelect("collection_handle");
        select.setLabel(T_collection);
        select.setHelp(T_collection_help);
        
        select.addOption("",T_collection_default);
        String communityName, collectionName;
        Collection collectionOpt;
        for (int i = 0; i < collections.getCollections().size(); i++) {
        	collectionOpt = collections.getCollections().get(i);
        	
        	communityName = collections.getCommunitiesName().get(i);
        	collectionName = collectionOpt.getName();

   		   	if (communityName.length() > 40){
   		   		communityName = communityName.substring(0, 39);
            } 
   		   	if (collectionName.length() > 40){
   		   		collectionName = collectionName.substring(0, 39);
            }
        	select.addOption(collectionOpt.getHandle(),communityName+" > "+collectionName);
        }
        
        Button submit = list.addItem().addButton("submit");
        submit.setValue(T_submit_next);
        
        // Edit metadata
        list.addItem().addButton("submit_edit").setValue(T_edit_submit);

        
        div.addHidden("submission-continue").setValue(knot.getId());
     }
    
}