public class FeatureToggle {

    static Environment__mdt currentEnv;
    static Map<String, Boolean> featureCache; 

    public class FeatureNotFoundException extends Exception {}
    public class EnvironmentNotFoundException extends Exception {}

    public static Boolean isEnabled(String featureName, Environment__mdt env) {

        if (featureCache.containsKey(featureName)) {
            return featureCache.get(featureName);
        }

        if (env == null) {
            throw new EnvironmentNotFoundException('Environment ' + env + ' not found');
        }

        Feature__mdt feature  = [SELECT Is_Enabled__c FROM Feature__mdt WHERE Label = :featureName AND Environment__c = :env.Id LIMIT 1];

        if (feature == null) {
            throw new FeatureNotFoundException('Feature ' + featureName + ' not found in environment ' + env);
        }

        featureCache.put(featureName, feature.Is_Enabled__c);

        return feature.Is_Enabled__c;
    }
    
    public static Boolean isEnabled(String featureName) {
        return isEnabled(featureName, getEnvironment());
    }

    private static Environment__mdt getEnvironment() {

        if (currentEnv != null) {
            return currentEnv;
        }

        // checks if in production
        Organization org = [SELECT isSandbox FROM Organization LIMIT 1];
        if (!org.isSandbox) {
            setEnvironment(Environment__mdt.getInstance('Prod'));
            return currentEnv;
        }

        // check if in sandbox or scratch org
        System.URL domainURL = System.URL.getOrgDomainUrl();
        String hostName = domainURL.getHost();
        System.Domain currentDomain = System.DomainParser.parse(hostName);

        String sandboxName = currentDomain.getSandboxName(); // returns the name of the sandbox, or null if not in a sandbox (as i have checked for production above, null means scratch org)

        if (sandboxName == null) {
            setEnvironment(Environment__mdt.getInstance('Scratch'));
        } else {
            setEnvironment(Environment__mdt.getInstance(sandboxName));
        }
        return currentEnv;
    }

    @TestVisible
    private static void setEnvironment(Environment__mdt env) {
        currentEnv = env;
    }

}










