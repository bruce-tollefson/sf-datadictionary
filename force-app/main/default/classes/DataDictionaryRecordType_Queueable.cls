public class DataDictionaryRecordType_Queueable implements Finalizer, Queueable {

    public void execute(QueueableContext context){

        Map<String, Data_Object_Record_Type__c> dataObjRTMAP = new Map<String, Data_Object_Record_Type__c>();

        List<RecordType> rtList = [SELECT Id, Name, DeveloperName, 
                                    NamespacePrefix, Description, BusinessProcessId, 
                                    SobjectType, IsActive, 
                                    CreatedById, 
                                    CreatedBy.Name, CreatedDate, LastModifiedById, 
                                    LastModifiedBy.Name, LastModifiedDate, SystemModstamp 
                                    FROM RecordType];

        // Get the dataObject Ids for linking to the parent
        Map<String, Id> dataObjMap = new Map<String, Id>();
        List<Data_Object__c> dataObjList = [Select Id, Name from Data_Object__c];
        for(Data_Object__c dataObj :dataObjList){
            dataObjMap.put(dataObj.Name, dataObj.Id);
        }

        List<Data_Object_Record_Type__c> dataObjRTList = [SELECT Id, Name, Data_Object__c, Developer_Name__c, 
                                                    Record_Type_Id__c, Namespace_Prefix__c, Description__c, 
                                                    Business_Process_Id__c, Sobject_Type__c, Is_Active__c, 
                                                    Created_By_Id__c, Created_By_Name__c, 
                                                    Created_Date__c, Last_Modified_By_Id__c, Last_Modified_By_Name_Text__c, 
                                                    Last_Modified_Date__c, System_Modstamp__c 
                                                    FROM Data_Object_Record_Type__c];

        for(Data_Object_Record_Type__c dataObjRT :dataObjRTList){
            dataObjRTMAP.put(dataObjRT.Record_Type_Id__c, dataObjRT);
        }

        List<Data_Object_Record_Type__c> upsertDORTList = new List<Data_Object_Record_Type__c>();

        for(RecordType rt :rtList){
            Data_Object_Record_Type__c oldDataObjRT = dataObjRTMAP.get(rt.Id);
            if(oldDataObjRT != null){
                dataObjRTMAP.remove(rt.Id);
            }

            Data_Object_Record_Type__c newDataObjRT = new Data_Object_Record_Type__c();
            newDataObjRT.Developer_Name__c = rt.DeveloperName;
            newDataObjRT.Record_Type_Id__c = rt.Id;
            newDataObjRT.Namespace_Prefix__c = rt.NamespacePrefix;
            newDataObjRT.Description__c = rt.Description;
            newDataObjRT.Business_Process_Id__c = rt.BusinessProcessId;
            newDataObjRT.Sobject_Type__c = rt.SobjectType;
            newDataObjRT.Is_Active__c = rt.IsActive;
            newDataObjRT.Created_By_Id__c = rt.CreatedById;
            newDataObjRT.Created_By_Name__c = rt.CreatedBy.Name;
            newDataObjRT.Created_Date__c = rt.CreatedDate;
            newDataObjRT.Last_Modified_By_Id__c = rt.LastModifiedById;
            newDataObjRT.Last_Modified_By_Name_Text__c = rt.LastModifiedBy.Name;
            newDataObjRT.Last_Modified_Date__c = rt.LastModifiedDate;
            newDataObjRT.System_Modstamp__c = rt.SystemModstamp;
            newDataObjRT.Data_Object__c = dataObjMap.get(rt.SobjectType);
            newDataObjRT.Name = rt.Name;
            if(oldDataObjRT == null){
                newDataObjRT.Data_Object__c = dataObjMap.get(rt.SobjectType);
                upsertDORTList.add(newDataObjRT);
            }else if(newDataObjRT.Name != oldDataObjRT.Name ||
            newDataObjRT.Data_Object__c != oldDataObjRT.Data_Object__c ||
            newDataObjRT.Developer_Name__c != oldDataObjRT.Developer_Name__c ||
            newDataObjRT.Record_Type_Id__c != oldDataObjRT.Record_Type_Id__c ||
            newDataObjRT.Namespace_Prefix__c != oldDataObjRT.Namespace_Prefix__c ||
            newDataObjRT.Description__c != oldDataObjRT.Description__c ||
            newDataObjRT.Business_Process_Id__c != oldDataObjRT.Business_Process_Id__c ||
            newDataObjRT.Sobject_Type__c != oldDataObjRT.Sobject_Type__c ||
            newDataObjRT.Is_Active__c != oldDataObjRT.Is_Active__c ||
            newDataObjRT.Created_By_Id__c != oldDataObjRT.Created_By_Id__c ||
            newDataObjRT.Created_By_Name__c != oldDataObjRT.Created_By_Name__c ||
            newDataObjRT.Created_Date__c != oldDataObjRT.Created_Date__c ||
            newDataObjRT.Last_Modified_By_Id__c != oldDataObjRT.Last_Modified_By_Id__c ||
            newDataObjRT.Last_Modified_By_Name_Text__c != oldDataObjRT.Last_Modified_By_Name_Text__c ||
            newDataObjRT.Last_Modified_Date__c != oldDataObjRT.Last_Modified_Date__c ||
            newDataObjRT.System_Modstamp__c != oldDataObjRT.System_Modstamp__c){
            newDataObjRT.Id = oldDataObjRT.Id;

            upsertDORTList.add(newDataObjRT);
            }
        }
        delete dataObjRTMAP.values();
        upsert upsertDORTList;
        
        DataDictionaryRecordType_Queueable DDRT = new DataDictionaryRecordType_Queueable();
        System.attachFinalizer(DDRT);
    }

      // Finalizer implementation
  public void execute(FinalizerContext ctx) {

      String parentJobId = '' + ctx.getAsyncApexJobId();
      if (ctx.getResult() == ParentJobResult.SUCCESS) {
          DataDictionaryPicklist_Batch DDPB = new DataDictionaryPicklist_Batch();//batch for creating all picklist values
          Id batchId = Database.executeBatch(DDPB);   
      }
  }
}