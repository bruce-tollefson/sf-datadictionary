public class DataDictionaryObjects {
    
    public class ValuesClass{
        public Attributes attributes;
        public String label;
        public List<String> validFor;
        public String value;
    }
    
    //needed to create this blank object so the attributes field is not strongly typed, for attributes tried List<String>, Object, sObject, String none worked all produced errors
    public class Attributes{}
    
    public class DataFieldScopeWrapper{
       public Map<String, Id> dataFieldsIdMap;
       public Set<Id> ScopeRecordTypeIdSet;
    }
    
    public class HeaderObject {
       public String key;
       public String value;
    }
}