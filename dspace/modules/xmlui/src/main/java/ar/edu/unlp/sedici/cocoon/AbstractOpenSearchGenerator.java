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
package ar.edu.unlp.sedici.cocoon;

import org.apache.avalon.excalibur.pool.Recyclable;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.generation.AbstractGenerator;
import org.apache.cocoon.util.HashUtil;
import org.apache.excalibur.source.SourceValidity;
import org.apache.excalibur.source.impl.validity.ExpiresValidity;
import org.dspace.app.util.OpenSearch;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.content.DSpaceObject;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.sort.SortException;
import org.dspace.sort.SortOption;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import java.io.IOException;
import java.io.Serializable;
import java.net.URLDecoder;
import java.sql.SQLException;
import java.util.Map;

/**
 * This class provides the common attributes and methods for parameter parsing,
 * cache key and validity generations.
 *
 * Parameters are parsed, sanitized and default values are assigned to them.
 * Subclasses requiring a custom parameter parsing is able to overwrite this setup() method,
 * but in most cases, this method should be enough.
 *
 * @author Richard Rodgers
 * @author Nestor Oviedo
 */

public abstract class AbstractOpenSearchGenerator extends AbstractGenerator
                implements CacheableProcessingComponent, Recyclable
{
    /** Cache of this object's validity */
    private ExpiresValidity validity = null;
    
    /** The results requested format */
    protected String format = null;

    /** the search query string */
    protected String query = null;

    /** optional search scope (= handle of container) or null */
    protected DSpaceObject scope = null;

    /** optional sort specification */
    protected SortOption sort = null;

    /** sort order, see SortOption **/
    protected String sortOrder = null;

    /** results per page */
    protected int rpp = 0;

    /** first result index */
    protected int start = 0;

    /** the results document (cached) */
    protected Document resultsDoc = null;

    /** default value for results per page parameter  */
    public static int DEFAULT_RPP = 20;

    /** max allowed value for results per page parameter  */
    public static int MAX_RPP = 100;

    /**
     * Generate the unique caching key.
     * This key includes the concrete class name to ensure uniqueness
     */
    public Serializable getKey()
    {
        StringBuffer key = new StringBuffer("key:");

        // Include the concrete class as part of the cache key
        key.append(this.getClass().getName());

        if (scope != null)
        {
            key.append(scope.getHandle());
        }

        key.append(query);

        if (format != null)
        {
            key.append(format);
        }
        if (sort != null)
        {
            key.append(sort.getNumber());
        }
        key.append(start);
        key.append(rpp);
        key.append(sortOrder);

        return HashUtil.hash(key.toString());
    }

    /**
     * Generate the cache validity object, based on the websvc.opensearch.validity config property
     */
    public SourceValidity getValidity()
    {
        if (this.validity == null)
        {
                long expiry = System.currentTimeMillis() +
                    ConfigurationManager.getLongProperty("websvc.opensearch.validity") * 60 * 60 * 1000;
                this.validity = new ExpiresValidity(expiry);
        }
        return this.validity;
    }

    /**
     * Setup configuration for this request, parameter parsing and sanitization.
     * This methods should be overwrite only if the subclass requires a different parameter parsing
     */
    public void setup(SourceResolver resolver, Map objectModel, String src,
                      Parameters par) throws ProcessingException, SAXException, IOException
    {
        super.setup(resolver, objectModel, src, par);

        Context context = null;
        try
        {
            context = ContextUtil.obtainContext(objectModel);
        }
        catch (SQLException e)
        {
            throw new ProcessingException("Couldn't get DSpace Context object", e);
        }

        Request request = ObjectModelHelper.getRequest(objectModel);

        // Query param (defaults to empty query)
        this.query = request.getParameter("query");
        if (query == null)
        {
            query = "";
        }
        query = URLDecoder.decode(query, "UTF-8");

        // Format param (defaults to atom)
        this.format = request.getParameter("format");
        if (format == null || format.length() == 0 || !OpenSearch.getFormats().contains(format))
        {
            format = "atom";
        }

        // Scope param (throws ProcessingException when scope is not a valid community or collection)
        String scopeParam = request.getParameter("scope");
        try
        {
            scope = OpenSearch.resolveScope(context, scopeParam);
        }
        catch (SQLException e)
        {
            throw new ProcessingException("Error resolving scope handle param "+scopeParam, e);
        }

        // Sort field param (defaults to 0)
        String srt = request.getParameter("sort_by");
        int sortValue = -1;
        try
        {
            if (srt != null && srt.length() > 0)
                sortValue = Integer.valueOf(srt);
        }
        catch (NumberFormatException e)
        {
            // do nothing. preserves the default value
        }

        try
        {
            this.sort = SortOption.getSortOption(sortValue);
        }
        catch (SortException e)
        {
            // This exception is thrown when there is a configuration error. We wrap it in a ProcessingException
            // in order to be able to rethrow it
            throw new ProcessingException("Error obtaining SortOptions", e);
        }


        // Sort order param if the sort param is not null (defaults to asc)
        if(this.sort != null)
        {
            String order = request.getParameter("order");
            this.sortOrder = (order == null || order.length() == 0 || order.toLowerCase().startsWith("asc")) ?
                    SortOption.ASCENDING : SortOption.DESCENDING;
        }

        // Start index param
        String st = request.getParameter("start");
        try
        {
            this.start = (st == null || st.length() == 0) ? 0 : Integer.valueOf(st);
            if(this.start < 0)
                this.start = 0;
        }
        catch (NumberFormatException e)
        {
            this.start = 0;
        }


        // Results per page param (defaults to DEFAULT_RPP)
        String pp = request.getParameter("rpp");
        try
        {
            this.rpp = (pp == null || pp.length() == 0) ? DEFAULT_RPP : Integer.valueOf(pp);
            if(this.rpp <= 0 || this.rpp > MAX_RPP)
                this.rpp = DEFAULT_RPP;
        }
        catch (NumberFormatException e)
        {
            this.rpp = DEFAULT_RPP;
        }
    }

    /**
     * Recycle
     */
    
    public void recycle()
    {
        this.format = null;
        this.query = null;
        this.scope = null;
        this.sort = null;
        this.rpp = 0;
        this.start = 0;
        this.sortOrder = null;
        this.resultsDoc = null;
        this.validity = null;
        super.recycle();
    }
}
