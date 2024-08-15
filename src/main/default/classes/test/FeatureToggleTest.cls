@IsTest
public class FeatureToggleTest {

    @IsTest
    static void testIsEnabled() {
        Test.startTest();
        Boolean enabled = FeatureToggle.isEnabled('TestFeature');
        Test.stopTest();
        System.assertEquals(false, enabled);
    }
    

    @IsTest
    static void testGetCurrentEnvironment() {
        return;
        // checks if in production
        // Organization org = [SELECT isSandbox FROM Organization LIMIT 1];
        // if(!org.isSandbox){ // isSandbox is true for both sandbox and scratch orgs, so if false it is production
        //     Environment__mdt env = [SELECT Id, DeveloperName FROM Environment__mdt WHERE DeveloperName = 'Prod' LIMIT 1];
        //     return env;
        // }

        // // check if in sandbox or scratch org
        // System.URL domainURL = System.URL.getOrgDomainUrl();
        // String hostName = domainURL.getHost();
        // System.Domain currentDomain = System.DomainParser.parse(hostName);

        // String sandboxName = currentDomain.getSandboxName(); // returns the name of the sandbox, or null if not in a sandbox (as i have checked for production above, null means scratch org)


        // if(sandboxName == null){
        //     Environment__mdt env = [SELECT Id, DeveloperName FROM Environment__mdt WHERE DeveloperName = 'Scratch' LIMIT 1];
        //     return env;
        // }
        // else{
        //     Environment__mdt env = [SELECT Id, DeveloperName FROM Environment__mdt WHERE DeveloperName = :sandboxName LIMIT 1];
        //     return env;
        // }
    }
}