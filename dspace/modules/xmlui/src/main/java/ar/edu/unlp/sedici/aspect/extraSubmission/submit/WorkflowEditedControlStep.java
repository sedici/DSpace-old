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
package ar.edu.unlp.sedici.aspect.extraSubmission.submit;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import org.dspace.app.util.SubmissionInfo;
import org.dspace.app.util.Util;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.DCValue;
import org.dspace.content.Item;
import org.dspace.content.LicenseUtils;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.eperson.EPerson;
import org.dspace.license.CreativeCommons;
import org.dspace.submit.AbstractProcessingStep;
import org.dspace.xmlworkflow.XmlWorkflowManager;

public class WorkflowEditedControlStep extends AbstractProcessingStep {

    public int doProcessing(Context context, HttpServletRequest request,
            HttpServletResponse response, SubmissionInfo subInfo)
            throws ServletException, IOException, SQLException,
            AuthorizeException
    {        
        // get reference to item
        Item item = subInfo.getSubmissionItem().getItem();

        // Si esta en el workflow, seteo el flag
        if(subInfo.isInWorkflow())
        	XmlWorkflowManager.setWorkflowEdited(context, item);
        
        // completed without errors
        return STATUS_COMPLETE;
    }

    public int getNumberOfPages(HttpServletRequest request, SubmissionInfo subInfo) throws ServletException
    {
        return 1;
    }

}

