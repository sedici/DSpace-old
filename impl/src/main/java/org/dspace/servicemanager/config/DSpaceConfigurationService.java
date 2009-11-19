/**
 * $Id$
 * $URL$
 * *************************************************************************
 * Copyright (c) 2002-2009, DuraSpace.  All rights reserved
 * Licensed under the DuraSpace Foundation License.
 *
 * A copy of the DuraSpace License has been included in this
 * distribution and is available at: http://scm.dspace.org/svn/repo/licenses/LICENSE.txt
 */
package org.dspace.servicemanager.config;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Map.Entry;

import org.azeckoski.reflectutils.ReflectUtils;
import org.azeckoski.reflectutils.map.ArrayOrderedMap;
import org.azeckoski.reflectutils.map.ConcurrentOrderedMap;
import org.dspace.constants.Constants;
import org.dspace.servicemanager.ServiceConfig;
import org.dspace.services.ConfigurationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;

/**
 * The central DSpace configuration service,
 * this is effectively immutable once the config has loaded
 * 
 * @author Aaron Zeckoski (azeckoski @ gmail.com)
 */
public class DSpaceConfigurationService implements ConfigurationService {

    private static final Logger log = LoggerFactory.getLogger(DSpaceConfigurationService.class);

    public static final String DSPACE = "dspace";
    public static final String DOT_PROPERTIES = ".cfg";
    public static final String DSPACE_PREFIX = "dspace.";
    public static final String DSPACE_HOME = DSPACE + ".dir";
    public static final String DEFAULT_CONFIGURATION_FILE_NAME = "dspace-defaults.properties";
    public static final String DEFAULT_DSPACE_CONFIG_PATH = "config/" + DEFAULT_CONFIGURATION_FILE_NAME;
    public static final String DSPACE_CONFIG_PATH = "config/" + DSPACE + DOT_PROPERTIES;
    
    protected transient Map<String, Map<String, ServiceConfig>> serviceNameConfigs;
    
    public DSpaceConfigurationService() {
        // init and load up current config settings
        loadInitialConfig(null);
    }

    public DSpaceConfigurationService(String providedHome) {
		loadInitialConfig(providedHome);
	}

	/* (non-Javadoc)
     * @see org.dspace.services.ConfigurationService#getAllProperties()
     */
    public Map<String, String> getAllProperties() {
        Map<String, String> props = new ArrayOrderedMap<String, String>();
        for (DSpaceConfig config : configuration.values()) {
            props.put(config.getKey(), config.getValue());
        }
        return props;
    }

    /* (non-Javadoc)
     * @see org.dspace.services.ConfigurationService#getProperties()
     */
    public Properties getProperties() {
        Properties props = new Properties();
        for (DSpaceConfig config : configuration.values()) {
            props.put(config.getKey(), config.getValue());
        }
        return props;
    }

    /* (non-Javadoc)
     * @see org.dspace.services.ConfigurationService#getProperty(java.lang.String)
     */
    public String getProperty(String name) {
        DSpaceConfig config = configuration.get(name);
        String value = null;
        if (config != null) {
            value = config.getValue();
        }
        return value;
    }

    /* (non-Javadoc)
     * @see org.dspace.services.ConfigurationService#getPropertyAsType(java.lang.String, java.lang.Class)
     */
    public <T> T getPropertyAsType(String name, Class<T> type) {
        String value = getProperty(name);
        T property = ReflectUtils.getInstance().convert(value, type);
        return property;
    }

    /* (non-Javadoc)
     * @see org.dspace.services.ConfigurationService#getPropertyAsType(java.lang.String, java.lang.Object)
     */
    public <T> T getPropertyAsType(String name, T defaultValue) {
        return getPropertyAsType(name, defaultValue, false);
    }

    /* (non-Javadoc)
     * @see org.dspace.services.ConfigurationService#getPropertyAsType(java.lang.String, java.lang.Object, boolean)
     */
    @SuppressWarnings("unchecked")
    public <T> T getPropertyAsType(String name, T defaultValue, boolean setDefaultIfNotFound) {
        String value = getProperty(name);
        T property = null;
        if (defaultValue == null) {
            property = null; // just return null when default value is null
        } else if (value == null) {
            property = defaultValue; // just return the default value if nothing is currently set
            // also set the default value as the current stored value
            if (setDefaultIfNotFound) {
                setProperty(name, defaultValue);
            }
        } else {
            // something is already set so we convert the stored value to match the type
            property = (T) ReflectUtils.getInstance().convert(value, defaultValue.getClass());
        }
        return property;
    }

    // config loading methods

    /* (non-Javadoc)
     * @see org.dspace.services.ConfigurationService#setProperty(java.lang.String, java.lang.Object)
     */
    public boolean setProperty(String name, Object value) {
        if (name == null) {
            throw new IllegalArgumentException("name cannot be null for setting configuration");
        }
        boolean changed = false;
        if (value == null) {
            changed = this.configuration.remove(name) != null;
            log.info("Cleared the configuration setting for name ("+name+")");
        } else {
            String sVal = ReflectUtils.getInstance().convert(value, String.class);
            changed = loadConfig(name, sVal);
        }
        return changed;
    }

    // INTERNAL loading methods
    public List<DSpaceConfig> getConfiguration() {
        return new ArrayList<DSpaceConfig>( configuration.values() );
    }

    /**
     * Get all configs that start with the given value
     * @param prefix a string which the configs to return must start with
     * @return the list of all configs that start with the given string
     */
    public List<DSpaceConfig> getConfigsByPrefix(String prefix) {
        List<DSpaceConfig> configs = new ArrayList<DSpaceConfig>();
        if (prefix != null && prefix.length() > 0) {
            for (DSpaceConfig config : configuration.values()) {
                if (config.getKey().startsWith(prefix)) {
                    configs.add(config);
                }
            }
        }
        return configs;
    }

    protected Map<String, DSpaceConfig> configuration = new ConcurrentOrderedMap<String, DSpaceConfig>();
    /**
     * @return a map of the service name configurations that are known for fast resolution
     */
    public Map<String, Map<String, ServiceConfig>> getServiceNameConfigs() {
        return serviceNameConfigs;
    }

    public void setConfiguration(Map<String, DSpaceConfig> configuration) {
        if (configuration == null) {
            throw new IllegalArgumentException("configuration cannot be null");
        }
        this.configuration = configuration;
        replaceVariables(this.configuration);
        // refresh the configs
        serviceNameConfigs = makeServiceNameConfigs();
    }

    /**
     * Load a series of properties into the configuration,
     * checks to see if the settings exist or are changed and only loads changes,
     * clears out existing ones depending on the setting
     * 
     * @param properties a map of key -> value strings 
     * @param clear if true then clears the existing configuration settings first
     * @return the list of changed configuration names
     */
    public String[] loadConfiguration(Map<String, String> properties, boolean clear) {
        if (properties == null) {
            throw new IllegalArgumentException("properties cannot be null");
        }
        // transform to configs and call load
        ArrayList<DSpaceConfig> dspaceConfigs = new ArrayList<DSpaceConfig>();
        for (Entry<String, String> entry : properties.entrySet()) {
            String key = entry.getKey();
            if (key != null &&  ! "".equals(key)) {
                String val = entry.getValue();
                if (val != null &&  ! "".equals(val)) {
                    dspaceConfigs.add( new DSpaceConfig(entry.getKey(), entry.getValue()) );
                }
            }
        }
        return loadConfiguration(dspaceConfigs, clear);
    }

    /**
     * Load up a bunch of {@link DSpaceConfig}s into the configuration,
     * checks to see if the settings exist or are changed and only loads changes,
     * clears out existing ones depending on the setting
     * 
     * @param dspaceConfigs a list of {@link DSpaceConfig} objects
     * @param clear if true then clears the existing configuration settings first
     * @return the list of changed configuration names
     */
    public String[] loadConfiguration(List<DSpaceConfig> dspaceConfigs, boolean clear) {
        ArrayList<String> changed = new ArrayList<String>();
        if (clear) {
            this.configuration.clear();
        }
        for (DSpaceConfig config : dspaceConfigs) {
            String key = config.getKey();
            boolean same = true;
            if (clear) {
                // all are new
                same = false;
            } else {
                if (this.configuration.containsKey(key)) {
                    if (this.configuration.get(key).equals(config)) {
                        // this one has changed
                        same = false;
                    }
                } else {
                    // this one is new
                    same = false;
                }
            }
            if (!same) {
                changed.add(key);
                this.configuration.put(key, config);
            }
        }
        if (changed.size() > 0) {
            replaceVariables(this.configuration);
            // refresh the configs
            serviceNameConfigs = makeServiceNameConfigs();
        }
        return changed.toArray(new String[changed.size()]);
    }

    /**
     * Loads an additional config setting into the system
     * @param key
     * @param value
     * @return true if the config is new or changed
     */
    public boolean loadConfig(String key, String value) {
        if (key == null) {
            throw new IllegalArgumentException("key cannot be null");
        }
        // update replacements and add
        boolean changed = replaceAndAddConfig( new DSpaceConfig(key, value) );
        if (changed) {
            // refresh the configs
            serviceNameConfigs = makeServiceNameConfigs();
        }
        return changed;
    }

    /**
     * Clears the configuration settings
     */
    public void clear() {
        this.configuration.clear();
        this.serviceNameConfigs.clear();
        log.info("Cleared all configuration settings");
    }

    // loading from files code

    /**
     * Loads up the default initial configuration from the dspace config files in the file home
     * and on the classpath
     */
    public void loadInitialConfig(String providedHome) {
        Map<String, String> configMap = new ArrayOrderedMap<String, String>();
        // load default settings
        try {
            String defaultServerId = InetAddress.getLocalHost().getHostName();
            configMap.put("serverId", defaultServerId);
        } catch (UnknownHostException e) {
            // oh well
        }
        // default is testing mode off
        configMap.put(Constants.DSPACE_TESTING_MODE, "false");

        // now we load the settings from properties files
        String homePath = System.getProperty(DSPACE_HOME);
        
		// now we load from the provided parameter if its not null
        if (providedHome != null && homePath == null) {
			homePath = providedHome;
		}
        
        if (homePath == null) {
            String catalina = getCatalina();
            if (catalina != null) {
                homePath = catalina + File.separatorChar + DSPACE + File.separatorChar;
            }
        }
        if (homePath == null) {
            homePath = System.getProperty("user.home");
        }
        if (homePath == null) {
            homePath = "/";
        }

        // make sure it's set properly
        //System.setProperty(DSPACE_HOME, homePath);
        configMap.put(DSPACE_HOME, homePath);

        // LOAD the internal defaults
        Properties defaultProps = readPropertyResource(DEFAULT_DSPACE_CONFIG_PATH);
        if (defaultProps.size() <= 0) {
            // failed to load defaults!
            throw new RuntimeException("Failed to load default dspace config properties: " + DEFAULT_DSPACE_CONFIG_PATH);
        }
        pushPropsToMap(configMap, defaultProps);

        // load all properties from the system which begin with the prefix
        Properties systemProps = System.getProperties();
        for (Object o : systemProps.keySet()) {
            String key = (String) o;
            if (key != null
                    && ! key.equals(DSPACE_HOME)) {
                try {
                    if (key.startsWith(DSPACE_PREFIX)) {
                        String propName = key.substring(DSPACE_PREFIX.length());
                        String propVal = systemProps.getProperty(key);
                        log.info("Loading system property as config: "+propName+"=>"+propVal);
                        configMap.put(propName, propVal);
                    }
                } catch (RuntimeException e) {
                    log.error("Failed to properly get config value from system property: " + o, e);
                }
            }
        }
        
        // Collect values from all the properties files: the later ones loaded override settings from prior.

        // read all the known files from the home path that are properties files
        pushPropsToMap(configMap, readPropertyFile(homePath + File.separatorChar + DSPACE_CONFIG_PATH));
        pushPropsToMap(configMap, readPropertyFile(homePath + "local" + DOT_PROPERTIES));

        // attempt to load from the current classloader also (works for commandline config sitting on classpath
        pushPropsToMap(configMap, readPropertyResource(DSPACE + DOT_PROPERTIES));
        pushPropsToMap(configMap, readPropertyResource("local" + DOT_PROPERTIES));
        pushPropsToMap(configMap, readPropertyResource("webapp" + DOT_PROPERTIES));

        // now push all of these into the config service store
        loadConfiguration(configMap, true);
        log.info("Started up configuration service and loaded "+configMap.size()+" settings");
    }


    /**
     * Adds in this DSConfig and then updates the config by checking for replacements everywhere else
     * @param dsConfig a DSConfig to update the value of and then add in to the main config
     * @return true if the config changed or is new
     */
    protected boolean replaceAndAddConfig(DSpaceConfig dsConfig) {
        String key = dsConfig.getKey();
        if (dsConfig.getValue().contains("${")) {
            String value = dsConfig.getValue();
            int start = -1;
            while ((start = value.indexOf("${")) > -1) {
                int end = value.indexOf('}', start);
                if (end > -1) {
                    String newKey = value.substring(start+2, end);
                    if (newKey.equals(key)) {
                        log.warn("Found circular reference for key ("+newKey+") in config value: " + value);
                        break;
                    }
                    DSpaceConfig dsc = this.configuration.get(newKey);
                    if (dsc == null) {
                        log.warn("Could not find key ("+newKey+") for replacement in value: " + value);
                        break;
                    }
                    String newVal = dsc.getValue();
                    value = value.replace("${"+newKey+"}", newVal);
                    dsConfig = new DSpaceConfig(key, value);
                } else {
                    log.warn("Found '${' but could not find a closing '}' in the value: " + value);
                    break;
                }
            }
        }
        // add the config
        if (this.configuration.containsKey(key)) {
            if (this.configuration.get(key).equals(dsConfig)) {
                return false; // SHORT CIRCUIT
            }
        }

        // config changed or new
        this.configuration.put(key, dsConfig);
        // update replacements
        replaceVariables(this.configuration);
        return true;
    }

    /**
     * This will replace the ${key} with the value from the matching key if it exists,
     * logs a warning if the key does not exist <br/>
     * Goes through and updates the replacements for the the entire configuration
     * and updates any replaced values
     */
    protected void replaceVariables(Map<String, DSpaceConfig> dsConfiguration) {
        for (Entry<String, DSpaceConfig> entry : dsConfiguration.entrySet()) {
            if (entry.getValue().getValue().contains("${")) {
                String value = entry.getValue().getValue();
                int start = -1;
                while ((start = value.indexOf("${")) > -1) {
                    int end = value.indexOf('}', start);
                    if (end > -1) {
                        String newKey = value.substring(start+2, end);
                        if (newKey.equals(entry.getKey())) {
                            log.warn("Found circular reference for key ("+newKey+") in config value: " + value);
                            break;
                        }
                        DSpaceConfig dsc = dsConfiguration.get(newKey);
                        if (dsc == null) {
                            log.warn("Could not find key ("+newKey+") for replacement in value: " + value);
                            break;
                        }
                        String newVal = dsc.getValue();
                        value = value.replace("${"+newKey+"}", newVal);
                        entry.setValue( new DSpaceConfig(newKey, value) );
                    } else {
                        log.warn("Found '${' but could not find a closing '}' in the value: " + value);
                        break;
                    }
                }
            }
        }
    }

    protected Properties readPropertyFile(String filePathName) {
        Properties props = new Properties();
        InputStream is = null;
        try {
            File f = new File(filePathName);
            if (f.exists()) {
                is = new FileInputStream(f);
                props.load(is);
                log.info("Loaded "+props.size()+" config properties from file: " + f);
            }
            else
            {
            	log.info("Failed to load config properties from file ("+filePathName+"): Does not exist");
                	
            }
        } catch (Exception e) {
            log.warn("Failed to load config properties from file ("+filePathName+"): " + e.getMessage(), e);
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException ioe) {
                    // Ignore exception on close
                }
            }
        }
        return props;
    }

    protected Properties readPropertyResource(String resourcePathName) {
        Properties props = new Properties();
        try {
            ClassPathResource resource = new ClassPathResource(resourcePathName);
            if (resource.exists()) {
                props.load(resource.getInputStream());
                log.info("Loaded "+props.size()+" config properties from resource: " + resource);
            }
        } catch (Exception e) {
            log.warn("Failed to load config properties from resource ("+resourcePathName+"): " + e.getMessage(), e);
        }
        return props;
    }

    protected void pushPropsToMap(Map<String, String> map, Properties props) {
        for (Entry<Object, Object> entry : props.entrySet()) {
            map.put(entry.getKey().toString(), entry.getValue() == null ? "" : entry.getValue().toString());
        }
    }

    /**
     * this simply attempts to find the servlet container home for tomcat
     * @return the path to the servlet container home OR null if it cannot be found
     */
    protected String getCatalina() {
        String catalina = System.getProperty("catalina.base");
        if (catalina == null) {
            catalina = System.getProperty("catalina.home");
        }
        return catalina;
    }

    @Override
    public String toString() {
        return "Config:" + DSPACE_HOME + ":size=" + configuration.size();
    }


    /**
     * Constructs service name configs map for fast lookup of service configurations
     * @param configurationService the dspace configuration service
     * @return the map of config service settings
     */
    public Map<String, Map<String, ServiceConfig>> makeServiceNameConfigs() {
        Map<String, Map<String, ServiceConfig>> serviceNameConfigs = new HashMap<String, Map<String,ServiceConfig>>();
        for (DSpaceConfig dsConfig : getConfiguration()) {
            String beanName = dsConfig.getBeanName();
            if (beanName != null) {
                Map<String, ServiceConfig> map = null;
                if (serviceNameConfigs.containsKey(beanName)) {
                    map = serviceNameConfigs.get(beanName);
                } else {
                    map = new HashMap<String, ServiceConfig>();
                    serviceNameConfigs.put(beanName, map);
                }
                map.put(beanName, new ServiceConfig(dsConfig));
            }
        }
        return serviceNameConfigs;
    }

}
