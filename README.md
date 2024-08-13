# Saft - Salesforce Feature Toggling 

<div align="center">
    <img src=".images/saft-logo.png" alt="saft logo" width="200"/>
</div>

## Overview

Feature toggling, also known as feature flagging, is an essential technique for managing the release of new features in a controlled manner, especially in Salesforce development. This project provides a simple yet powerful framework for implementing feature toggling within your Salesforce environment using custom metadata and Apex code. By utilizing feature toggles, you can enable or disable features across different environments (development, testing, production) without needing to deploy new code.

## Why Feature Toggling?

In a complex Salesforce development lifecycle, it's common to work across multiple environments, such as development, staging, and production. Feature toggling allows you to:

- **Safely introduce new features**: Roll out features to specific environments or user groups without impacting others.
- **Quickly react to issues in production**: Disable a problematic feature instantly without redeploying or rolling back code.
- **Parallel development**: Multiple features can be developed and tested concurrently without interfering with each other, even if they are part of the same codebase.
- **Controlled rollouts**: Gradually release features to end users, starting with a small group before a full rollout.

## How It Works

This framework leverages Salesforce Custom Metadata Types to define features and their statuses. Apex code is then used to query and check the status of each feature in real-time, determining whether a feature should be enabled or disabled based on the environment.

### Custom Metadata

A custom metadata type, `Feature__mdt`, is used to define each feature toggle. The custom metadata should include the following fields:

- **Feature Name (`Feature_Name__c`)**: A unique name for the feature.
- **Is Enabled (`Is_Is_Enabled__c`)**: A checkbox field that indicates whether the feature is currently enabled.
- **Environment (`Environment__c`)**: A picklist or text field to specify the environment where this setting applies (e.g., Development, Staging, Production). Lookup to `Environment__mdt`.
- **Description (`Description__c`)**: (Optional) A brief description of what the feature does.

A custom metadata type `Environment__mdt` is used to define each environment, production, sandboxes and scratch orgs. The custom metadata include the following fields:
- **Environment Name (`Name__c`)**: A unique name for the environment.


### Apex Code

The Apex code is responsible for querying the `Feature__mdt` custom metadata to determine the status of a feature. The framework provides a simple method to check whether a feature is enabled in the current environment:

```apex
public class FeatureToggle {
    
    public static Boolean isFeatureEnabled(String featureName, String environment) {
        Feature__mdt feature = [
            SELECT Is_Is_Enabled__c 
            FROM Feature__mdt 
            WHERE Feature_Name__c = :featureName 
              AND Environment__c = :environment
            LIMIT 1
        ];
        return feature != null ? feature.Is_Is_Enabled__c : false;
    }
}
```

### Usage Example

In your Salesforce code, you can easily check whether a feature should be enabled or not:

```apex
if (FeatureToggle.isFeatureEnabled('New_UI', 'Production')) {
    // Execute code for the new UI feature
} else {
    // Execute fallback or existing functionality
}
```

### Deployment

To deploy this feature toggling framework to your Salesforce environment:

1. **Define Environments**:
   - Create records under the `Environment__mdt` to define your environments
   - The package comes shipped with predfined environments for `Prod` production environment and `Scratch` orgs. These are referenced in code and should not be altered.

2. **Add Metadata Records**:
   - Create records under the `Feature__mdt` to define your features and their statuses per environment.

3. **Use the Feature Toggling in Your Code**:
   - Implement the feature checks in your existing Apex codebase where needed.

## Best Practices

- **Feature Naming**: Use descriptive and unique names for your features to avoid conflicts and confusion.
- **Environment Awareness**: Ensure that the `Environment__mdt` accurately reflects the environments and sandbox names.
- **Version Control**: Track changes to your feature toggles and metadata in version control to maintain a history of what features were enabled when and where.
- **Testing**: Regularly test your feature toggles in sandbox environments before deploying to production to ensure they work as expected.
- **Monitoring**: Implement logging or monitoring to track when and where features are toggled, which can help in diagnosing issues.

## Contributing

Contributions to this project are welcome! Please fork the repository and submit a pull request with your changes. Ensure that your code follows Salesforce development best practices and is well-tested.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Support

If you encounter any issues or have questions, feel free to open an issue on the GitHub repository or contact the maintainers directly.