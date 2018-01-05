package ar.edu.unlp.sedici.aspect.extraSubmission;

import java.io.IOException;
import java.sql.SQLException;

import org.dspace.app.util.CollectionDropDown;
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
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.core.Constants;
import org.xml.sax.SAXException;

public class SeDiCISelectCollectionAction extends AbstractXMLUIAction {


	/** Language Strings */
    protected static final Message T_head = 
        message("xmlui.Submission.submit.SelectCollection.head");
    protected static final Message T_collection = 
        message("xmlui.Submission.submit.SelectCollection.collection");
    protected static final Message T_collection_help = 
        message("xmlui.Submission.submit.SelectCollection.collection_help");
    protected static final Message T_collection_default = 
        message("xmlui.Submission.submit.SelectCollection.collection_default");
    protected static final Message T_submit_next = 
        message("xmlui.general.next");
    protected static final Message T_submission_head = message("sedici.XMLWorkflow.workflow.selectCollectionAction.head");
    protected static final Message T_edit_submit = message("xmlui.XMLWorkflow.workflow.EditMetadataAction.edit_submit");
    
	
    public void addBody(Body body) throws SAXException, WingException, UIException, SQLException, IOException, AuthorizeException
    {  
        Collection collection = workflowItem.getCollection();
		String actionURL = contextPath + "/handle/"+collection.getHandle() + "/xmlworkflow";

		// Listado de colecciones disponibles
		//CollectionsWithCommunities collections = CollectionSearchSedici.findAuthorizedWithCommunitiesName(context, null, Constants.ADD);
        java.util.List<Collection> collections = ContentServiceFactory.getInstance().getCollectionService().findAuthorizedOptimized(context, Constants.ADD);

		// Formulario con la lista de colecciones
        Division div = body.addInteractiveDivision("select-collection",actionURL,Division.METHOD_POST,"primary submission");
        div.setHead(T_submission_head);
        
        List list = div.addList("select-collection", List.TYPE_FORM);
        list.setHead(T_head);
        Select select = list.addItem().addSelect("collection_handle");
        select.setLabel(T_collection);
        select.setHelp(T_collection_help);
        
        select.addOption("",T_collection_default);
        
        for (Collection c : collections)
        {
            select.addOption(c.getHandle(), CollectionDropDown.collectionPath(context, c));
        }
        Button submit = list.addItem().addButton("submit");
        submit.setValue(T_submit_next);
        
        // Edit metadata
        list.addItem().addButton("submit_edit").setValue(T_edit_submit);

        
        div.addHidden("submission-continue").setValue(knot.getId());
     }
    
}
