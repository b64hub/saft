public abstract class CustomPermissionFeature implements IFeature {

    public Boolean isEnabled(String permissionName) {
        if (String.isBlank(permissionName)) {
            throw new IllegalArgumentException('feature cannot be blank');
        }

        if (permissionName.containsWhitespace()) {
            throw new IllegalArgumentException(
                'feature cannot contain white spaces'
            );
        }

        return FeatureManagement.checkPermission(permissionName);
    }
}