System.URL domainURL = System.URL.getOrgDomainUrl();
String hostName = domainURL.getHost();

System.Domain currentDomain = System.DomainParser.parse(hostName);
String sandboxName = currentDomain.getSandboxName();

Organization org = [SELECT InstanceName, Name, isSandbox FROM Organization LIMIT 1];

System.debug('hostName: ' + hostName);
System.debug('isSandbox(and scratch): ' + org.isSandbox); // true for sandboxes and scratch orgs
System.debug('sandboxName: ' + sandboxName); // null for production orgs and scratch orgs