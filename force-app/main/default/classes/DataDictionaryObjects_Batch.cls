public class DataDictionaryObjects_Batch implements Database.Batchable<SObjectType>, Database.Stateful {

    //setup stateful - get the current list of DataObjects to check against changes, get
    private List<Data_Object__c> currentDataObjectList = new List<Data_Object__c> ([Select Custom__c, Custom_Setting__c, Feed_Enabled__c, 
                                                                             Has_Subtypes__c, Label_Plural__c, Mergeable__c, 
                                                                             Name, Record_Type_Dev_Names__c, Record_Type_Names__c 
                                                                             from Data_Object__c]);
    private List<String> currentObjectNamesList = new List<String>();//used to compare for changes
    private Map<String, Data_Object__c> currentObjMap = new Map<String, Data_Object__c>();
    
    public Iterable<SObjectType> start(Database.BatchableContext bc){
        //put all current object records into map and list
        for(Data_Object__c objects : currentDataObjectList){
            currentObjectNamesList.add(objects.Name);
            currentObjMap.put(objects.Name, objects);
        }
        return Schema.getGlobalDescribe().values();//grab full all object describes
    }
    
    public void execute(Database.BatchableContext bc, List<SObjectType> scope){
        
        List<Data_Object__c> newDataObjectList = new List<Data_Object__c>();
	    List<Data_Object__c> updatedDataObjectList = new List<Data_Object__c>();
        //Loop through all the SObjectTypes
        for ( Schema.SObjectType typ : scope ) {
            String sobjName = String.valueOf(typ);
            Schema.DescribeSObjectResult objectResult = typ.getDescribe();//get describe of object
            //put 
            Boolean custom = objectResult.isCustom();
            Boolean customSetting = objectResult.isCustomSetting();
            Boolean feedEnabled = objectResult.isFeedEnabled();
            Boolean hasSubTypes = objectResult.getHasSubTypes();
            String labelPlural = objectResult.getLabelPlural();
            Boolean mergeable = objectResult.isMergeable();
            String prefix = objectResult.getKeyPrefix();
            String label = objectResult.getLabel();
            String name = objectResult.getName();
            list<Schema.RecordTypeInfo> objectRecordTypeInfoList = new list<Schema.RecordTypeInfo>();
            objectRecordTypeInfoList = objectResult.getRecordTypeInfos();//get recordtypeinfo
            String recordtypename;
            String recordtypedevname;
            Integer c = 0;
            List<String> recordTypeNameList = new List<String>();
            List<String> recordTypeDevNameList = new List<String>();
            
            //Loop record Type info and create get record type name and dev name
            for(Schema.RecordTypeInfo objectRecordTypeInfo : objectRecordTypeInfoList){
                recordTypeNameList.add(objectRecordTypeInfo.getName());
                recordTypeDevNameList.add(objectRecordTypeInfo.getDeveloperName());
                
            }
            //join record type lists into a string
            recordtypename = String.join(recordTypeNameList, ', ');
            recordtypedevname = String.join(recordTypeDevNameList, ', ');
            
            //get record and check for any updates
            if(currentObjectNamesList.contains(sobjName)){
                Data_Object__c checkObjectUpdate = currentObjMap.get(sobjName);
                //remove record from map if any are remaining then the objects have been deleted
                currentObjMap.remove(sobjName);
                //check if there are any changes/updates
                if(checkObjectUpdate.Custom__c != custom
                   || checkObjectUpdate.Custom_Setting__c != customSetting
                   || checkObjectUpdate.Feed_Enabled__c != feedEnabled
                   || checkObjectUpdate.Has_Subtypes__c != hasSubTypes
                   || checkObjectUpdate.Label_Plural__c != labelPlural
                   || checkObjectUpdate.Mergeable__c != mergeable
                   || checkObjectUpdate.Record_Type_Dev_Names__c != recordtypedevname 
                   || checkObjectUpdate.Record_Type_Names__c != recordtypename){
                       checkObjectUpdate.Custom__c = custom;
                       checkObjectUpdate.Custom_Setting__c = customSetting;
                       checkObjectUpdate.Feed_Enabled__c = feedEnabled;
                       checkObjectUpdate.Has_Subtypes__c = hasSubTypes;
                       checkObjectUpdate.Label_Plural__c = labelPlural;
                       checkObjectUpdate.Mergeable__c = mergeable;
                    checkObjectUpdate.Record_Type_Dev_Names__c = recordtypedevname;
                    checkObjectUpdate.Record_Type_Names__c = recordtypename;
                    updatedDataObjectList.add(checkObjectUpdate);
                }
            }else{
                //create a new Data Object record
                Data_Object__c newObject = new Data_Object__c(
                    Custom__c = custom,
                    Custom_Setting__c = customSetting,
                    Feed_Enabled__c = feedEnabled,
                    Has_Subtypes__c = hasSubTypes,
                    Label_Plural__c = labelPlural,
                    Mergeable__c = mergeable,
                    Name = name,
                    Prefix__c = prefix,
                    Record_Type_Names__c = recordtypename,
                    Record_Type_Dev_Names__c = recordtypedevname,
                    Label__c = label
                );
                newDataObjectList.add(newObject);
            }
        }
        insert newDataObjectList;
        update updatedDataObjectList;
    }
    
    public void finish(Database.BatchableContext bc){
        
        delete currentObjMap.values();
        DataDictionaryFields_Batch DDFB = new DataDictionaryFields_Batch();//batch for creating all field records
        Id batchId = Database.executeBatch(DDFB);
    }
}