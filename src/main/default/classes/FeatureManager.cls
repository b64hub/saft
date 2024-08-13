public with sharing class FeatureManager {
    
    public static Boolean isEnabled(String featureName) {
        // logic for getting metadata with the same name as featureName, and in the same environment as the current one
        Environment__mdt currentEnvironment;

        try{
            currentEnvironment = getCurrentEnvironment();
        }
        catch(Exception e){
            System.debug('Error getting current environment: ' + e.getMessage() + '. stack trace: ' + e.getStackTraceString());
            return false;
        }


        Feature__mdt feature;

        try {
            feature = [SELECT Enabled__c FROM Feature__mdt WHERE SharedFeatureName__c = :featureName AND Environment__c = :currentEnvironment.Id LIMIT 1];
        }
        catch (Exception e) {
            System.debug('Feature not found: ' + featureName + '. message: ' + e.getMessage() + '. stack trace: ' + e.getStackTraceString());
            return false;
        }

        return feature.Enabled__c;
    }
    


    private static Environment__mdt getCurrentEnvironment() {

        // checks if in production
        Organization org = [SELECT isSandbox FROM Organization LIMIT 1];
        if(!org.isSandbox){ // isSandbox is true for both sandbox and scratch orgs, so if false it is production
            Environment__mdt env = [SELECT Id, DeveloperName FROM Environment__mdt WHERE DeveloperName = 'Prod' LIMIT 1];
            return env;
        }

        // check if in sandbox or scratch org
        System.URL domainURL = System.URL.getOrgDomainUrl();
        String hostName = domainURL.getHost();
        System.Domain currentDomain = System.DomainParser.parse(hostName);

        String sandboxName = currentDomain.getSandboxName(); // returns the name of the sandbox, or null if not in a sandbox (as i have checked for production above, null means scratch org)


        if(sandboxName == null){
            Environment__mdt env = [SELECT Id, DeveloperName FROM Environment__mdt WHERE DeveloperName = 'Scratch' LIMIT 1];
            return env;
        }
        else{
            Environment__mdt env = [SELECT Id, DeveloperName FROM Environment__mdt WHERE DeveloperName = :sandboxName LIMIT 1];
            return env;
        }
    }
}










// Feature__mdt feature;

// try {
//     feature = [SELECT Enabled__c FROM Feature__mdt WHERE DeveloperName = :featureName LIMIT 1];
// }
// catch (Exception e) {
//     System.debug('Feature not found: ' + featureName + '. message: ' + e.getMessage() + '. stack trace: ' + e.getStackTraceString());
//     return false;
// }

// return feature.Enabled__c;