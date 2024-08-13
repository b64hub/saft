public class FeatureToggle {

    static Environment__mdt thisEnv;

    public static Boolean isEnabled(String featureName, Environment__mdt env) {

        if (env == null)
            System.debug('Invalid environment: ' + env.Label);
            return false;
        }

        Feature__mdt feature  = [SELECT Is_Enabled__c FROM Feature__mdt WHERE Label = :featureName AND Environment__c = :env.Id LIMIT 1];

        if (feature == null)
            System.debug('Feature not found: ' + featureName);
            return false;
        }

        return feature.Is_Enabled__c;
    }
    
    public static Boolean isEnabled(String featureName) {
        return isEnabled(featureName, getEnvironment())
    }

    private static Environment__mdt getEnvironment() {

        if (thisEnv != null) {
            return thisEnv;
        }

        // checks if in production
        Organization org = [SELECT isSandbox FROM Organization LIMIT 1];
        if (!org.isSandbox) {
            setEnvironment([SELECT Id, DeveloperName FROM Environment__mdt WHERE DeveloperName = 'Prod' LIMIT 1]);
            return thisEnv;
        }

        // check if in sandbox or scratch org
        System.URL domainURL = System.URL.getOrgDomainUrl();
        String hostName = domainURL.getHost();
        System.Domain currentDomain = System.DomainParser.parse(hostName);

        String sandboxName = currentDomain.getSandboxName(); // returns the name of the sandbox, or null if not in a sandbox (as i have checked for production above, null means scratch org)

        if (sandboxName == null) {
            setEnvironment([SELECT Id, DeveloperName FROM Environment__mdt WHERE DeveloperName = 'Scratch' LIMIT 1]);
        } else {
            setEnvironment([SELECT Id, DeveloperName FROM Environment__mdt WHERE DeveloperName = :sandboxName LIMIT 1]);
        }
        return thisEnv;
    }

    @TestVisible
    private static setEnvironment(Environment__mdt env) {
        thisEnv = env;
    }

}










