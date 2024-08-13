/**
 * This class is an abstract class that is used to check if a feature is enabled or not.
 * the featureEnabled variable is used to check if the feature is enabled or not, it is set after instantiation.
 */
public abstract with sharing class Feature{

    public Map<String, Boolean> featureMap = new Map<String, Boolean>();

    public Boolean isEnabled(){
        return isEnabled(getClassName());
    }

    public Boolean isEnabled(String featureName){
        if(!featureMap.containsKey(featureName)){
            Boolean featureIsEnabled = FeatureManager.isEnabled(featureName);
            featureMap.put(featureName, featureIsEnabled);
        }

        return featureMap.get(featureName);
    }

    private String getClassName(){
        String totalClassName = String.valueOf(this);

        return totalClassName.substring(0, totalClassName.indexOf(':'));
    }
}