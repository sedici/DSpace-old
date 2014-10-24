package ar.edu.unlp.sedici.dspace.xmlworkflow.state.actions.processingaction;

import java.sql.SQLException;

import org.dspace.authorize.AuthorizeManager;
import org.dspace.core.Context;
import org.dspace.xmlworkflow.WorkflowConfigurationException;
import org.dspace.xmlworkflow.state.actions.userassignment.ClaimAction;
import org.dspace.xmlworkflow.storedcomponents.XmlWorkflowItem;

public class AcceptRoleOrNotAdmin extends ClaimAction {

	/*
	 * If current user is member of the role of the current step, or is not ADMIN of the collection or 
	 * an upper community,then evaluate if exists users that can handle the actions of the current step.
	 */
	public boolean isValidUserSelection(Context ctx, XmlWorkflowItem wfi, boolean hasUI) throws WorkflowConfigurationException, SQLException {
		if (isUserMemberInStepRole(ctx,wfi) || !AuthorizeManager.isAdmin(ctx, wfi.getCollection()))
			return super.isValidUserSelection(ctx, wfi, hasUI);
		else
			return false;
	}
	/*
	 * @return true if current user is member of the role configured for the current step. 
	 */
	private boolean isUserMemberInStepRole(Context ctx, XmlWorkflowItem wfi) throws SQLException{
		return getParent().getStep().getRole().getMembers(ctx, wfi).getAllUniqueMembers(ctx).contains(ctx.getCurrentUser());
	}
}
