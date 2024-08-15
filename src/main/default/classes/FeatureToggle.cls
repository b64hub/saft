public class FeatureToggle {

    static Environment__mdt runtimeEnv;
    static Map<String, Map<String, Boolean>> featureCache = new Map<String, Map<String, Boolean>>(); 

    public class FeatureNotFoundException extends Exception {}
    public class EnvironmentNotFoundException extends Exception {}

    private static Boolean isEnabled(String featureName, Environment__mdt env) {

        if (featureCache.get(env.Label).containsKey(featureName)) {
            return featureCache.get(env.Label).get(featureName);
        }

        try {
            Feature__mdt feature = getFeature(featureName, env);
        } catch (FeatureNotFoundException e) {
            return false;
        }

        featureCache.get(env.Label).put(featureName, feature.Is_Enabled__c);
        return feature.Is_Enabled__c;
    }

    public static Boolean isEnabled(String featureName, String environment) {
        return isEnabled(featureName, getEnvironment(environment));
    }
    
    public static Boolean isEnabled(String featureName) {
        return isEnabled(featureName, getRuntimeEnvironment());
    }

    public static Feature__mdt getFeature(String featureName) {
        return getFeature(featureName, getRuntimeEnvironment());
    }

    public static Feature__mdt getFeature(String featureName, String environment) {
        return getFeature(featureName, getEnvironment(environment));
    }

    public static Feature__mdt getFeature(String featureName, Environment__mdt env) {
        if (String.isBlank(featureName)) {
            throw new IllegalArgumentException('Feature cannot be blank');
        }

        if (env == null) {
            throw new EnvironmentNotFoundException('Environment ' + env.Label + ' not found');
        }

        Feature__mdt feature  = [SELECT Is_Enabled__c FROM Feature__mdt WHERE Label = :featureName AND Environment__c = :env.Id LIMIT 1];

        if (feature == null) {
            throw new FeatureNotFoundException('Feature ' + featureName + ' not found in environment ' + env);
        }

        return feature;
    }

    private static Environment__mdt getEnvironment(String environment) {
        if (String.isBlank(environment)) {
            throw new IllegalArgumentException('Environment cannot be blank');
        }

        if (String.containsWhitespace(environment)) {
            throw new IllegalArgumentException('Environment cannot contain white spaces');
        }

        Environment__mdt env = Environment__mdt.getInstance(env);
        if (env == null) {
            throw new EnvironmentNotFoundException('Environment ' + environment + ' not found');
        }
        return env;
    }

    private static Environment__mdt getRuntimeEnvironment() {

        if (runtimeEnv != null) {
            return runtimeEnv;
        }

        // checks if in production
        Organization org = [SELECT isSandbox FROM Organization LIMIT 1];
        if (!org.isSandbox) {
            setEnvironment(getEnvironment('Prod'));
            return runtimeEnv;
        }

        // check if in sandbox or scratch org
        System.URL domainURL = System.URL.getOrgDomainUrl();
        String hostName = domainURL.getHost();
        System.Domain currentDomain = System.DomainParser.parse(hostName);

        String sandboxName = currentDomain.getSandboxName(); // returns the name of the sandbox, or null if not in a sandbox (as i have checked for production above, null means scratch org)

        if (sandboxName == null) {
            setEnvironment(getEnvironment('Scratch'));
        } else {
            setEnvironment(getEnvironment(sandboxName));
        }
        
        return runtimeEnv;
    }

    @TestVisible
    private static void setEnvironment(Environment__mdt env) {
        runtimeEnv = env;
    }

}










