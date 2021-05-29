public class DataDictionaryUtility {

    public static Data_Field__c createNewDataField(FieldDefinition fieldDef, schema.describefieldresult describeField){
        Data_Field__c newDataField = new Data_Field__c();

        if(describeField != null){
            newDataField.Name = describeField.getName();
            newDataField.Name__c = describeField.getName();
            newDataField.Length__c = describeField.getLength();
            newDataField.AI_Prediction_Field__c = describeField.isAiPredictionField();
            newDataField.Calculated_Formula__c = String.valueOf(describeField.getCalculatedFormula());
            newDataField.Default_Value__c = String.valueOf(describeField.getDefaultValue());
            newDataField.Deprecated_and_Hidden__c = describeField.isDeprecatedAndHidden();
            newDataField.Formula_Treat_Null_Number_As_Zero__c = describeField.isFormulaTreatNullNumberAsZero();
            newDataField.Inline_Help_Text__c = String.valueOf(describeField.getInlineHelpText());
            newDataField.Permissionable__c = describeField.isPermissionable();
            
            String referenceTo;
            if(describefield.getReferenceTo().size()>0){
                referenceTo = String.ValueOf(describefield.getReferenceTo());
            }
            newDataField.Reference_To__c = referenceTo;
            
            newDataField.Restricted_Picklist__c = describeField.isRestrictedPicklist();
            newDataField.SObject_Field__c = String.valueOf(describeField.getSobjectField());
            newDataField.Auto_Number__c = describeField.isAutoNumber();
            newDataField.Cascade_Delete__c = describeField.isCascadeDelete();
            newDataField.Default_Value_Formula__c = String.valueOf(describeField.getDefaultValueFormula());
            newDataField.Digits__c = describeField.getDigits();
            newDataField.Label__c = describeField.getLabel();
            newDataField.Name_Field__c = describeField.isNameField();
            //getpicklist from method
            newDataField.Picklist_Values__c = getPicklistValues(describefield.getPicklistValues());
            newDataField.Type__c = String.valueOf(describeField.getType());
            newDataField.Byte_Length__c = describeField.getByteLength();
            newDataField.Controller__c = String.valueOf(describeField.getController());
            newDataField.Defaulted_On_Create__c = describeField.isDefaultedOnCreate();
            newDataField.External_Id__c = describeField.isExternalId();
            newDataField.Name_Pointing__c = describeField.isNamePointing();
            newDataField.Unique__c = describeField.isUnique();
            newDataField.Relationship_Order__c = describeField.getRelationshipOrder();
            newDataField.Restricted_Delete__c = describeField.isRestrictedDelete();
            newDataField.Soap_Type__c = String.valueOf(describeField.getSoapType());
            newDataField.Write_Requires_Master_Read__c = describeField.isWriteRequiresMasterRead();
            newDataField.Id_Lookup__c = describeField.isIdLookup();
            newDataField.Custom__c = describeField.isCustom();
            newDataField.Dependent_Picklist__c = describeField.isDependentPicklist();
        }

        if(fieldDef != null){
            if(String.isBlank(newDataField.Name)){
                system.debug('newDataField.Name is blank'+newDataField.Name);
                newDataField.Name = fieldDef.QualifiedApiName;
            }
            system.debug(fieldDef.QualifiedApiName);
            newDataField.Durable_Id__c = fieldDef.DurableId;
            newDataField.Name__c = fieldDef.QualifiedApiName;
            newDataField.Entity_Definition_Id__c = fieldDef.EntityDefinitionId;
            newDataField.Namespace_Prefix__c = fieldDef.NamespacePrefix;
            newDataField.Local_Name__c = fieldDef.Label;
            if(newDataField.Length__c == null){
                system.debug('newDataField.Length__c is blank'+newDataField.Name);
                newDataField.Length__c = fieldDef.Length;
            }
            newDataField.Data_Type__c = fieldDef.DataType;
            newDataField.Extra_Type_Info__c = fieldDef.ExtraTypeInfo;
            newDataField.Calculated__c = fieldDef.IsCalculated;
            newDataField.Is_High_Scale_Number__c = fieldDef.IsHighScaleNumber;
            newDataField.HTML_Formatted__c = fieldDef.IsHtmlFormatted;
            newDataField.Is_Name_Field__c = fieldDef.IsNameField;
            newDataField.Nillable__c = fieldDef.IsNillable;
            newDataField.Is_Workflow_Filterable__c = fieldDef.IsWorkflowFilterable;
            newDataField.Is_Compact_Layoutable__c = fieldDef.IsCompactLayoutable;
            newDataField.Precision__c = String.ValueOf(fieldDef.Precision);
            newDataField.Scale__c = fieldDef.Scale;
            newDataField.Is_Field_History_Tracked__c = fieldDef.IsFieldHistoryTracked;
            newDataField.Is_Indexed__c = fieldDef.IsIndexed;
            newDataField.Filterable__c = fieldDef.IsApiFilterable;
            newDataField.Is_Api_Sortable__c = fieldDef.IsApiSortable;
            newDataField.Is_List_Filterable__c = fieldDef.IsListFilterable;
            newDataField.Is_List_Sortable__c = fieldDef.IsListSortable;
            newDataField.Groupable__c = fieldDef.IsApiGroupable;
            newDataField.Is_List_Visible__c = fieldDef.IsListVisible;
            newDataField.Controlling_Field_Definition_Id__c = fieldDef.ControllingFieldDefinitionId;
            newDataField.Last_Modified_Date__c = String.ValueOf(fieldDef.LastModifiedDate);
            newDataField.Last_Modified_By_Id__c = fieldDef.LastModifiedById;
            newDataField.Relationship_Name__c = fieldDef.RelationshipName;
            newDataField.Is_Compound__c = fieldDef.IsCompound;
            newDataField.Search_Prefilterable__c = fieldDef.IsSearchPrefilterable;
            newDataField.Is_Polymorphic_Foreign_Key__c = fieldDef.IsPolymorphicForeignKey;
            newDataField.Business_Owner_Id__c = fieldDef.BusinessOwnerId;
            newDataField.Business_Status__c = fieldDef.BusinessStatus;
            newDataField.Security_Classification__c = fieldDef.SecurityClassification;
            newDataField.Description__c = fieldDef.Description;
        }

        return newDataField;
    }

    public static Data_Field__c createNewDataField(FieldDefinition fieldDef, schema.describefieldresult describeField, Id dataFieldId, Id dataObjectId){
        Data_Field__c potentialDataField = createNewDataField(fieldDef, describeField);
        potentialDataField.Data_Object__c = dataObjectId;
        try{
            potentialDataField.Id = dataFieldId;
        }catch(System.NullPointerException e){
            system.debug('PointerException: '+potentialDataField);//do I need?
        }
        return potentialDataField;
    }

    
    public static String getPicklistValues(List<PicklistEntry> currentPickListEntryList){
        
        String pickListString;
        if(currentPickListEntryList != null){
            List<String> pickListStringList = New List<String>();
            String test = String.ValueOf(currentPickListEntryList);
            for(Schema.PicklistEntry picklistEntry : currentPickListEntryList){
                pickListStringList.add(picklistEntry.getValue());
            }                                           
            //Picklist needs to be null if it is for the compare or it will throw the update
            If(!pickListStringList.isEmpty()){
                pickListString = String.join(pickListStringList, ', ');
            }
            //check length if over the field length will get an error outbound of bounds, this prevents it
            If(pickListString != null){
                pickListString = pickListString.abbreviate(131000);
            }
        }
        
        return pickListString;
    }
    
    //used to check if the data field record fields are matching
    public static Boolean dataDictionaryFieldsMatching(Data_Field__c dataField, Data_Field__c potentialNewDataField, List<String> trackedFieldsStringList){
        
        boolean isMatching = true;
        if(dataField != null && !trackedFieldsStringList.isEmpty()){
            datafield.Data_Object__r = null;
            
            for(String objectField : trackedFieldsStringList){
                String dataFieldString = String.valueOf(dataField.get(objectField));
                String potentialNewDataFieldString = String.ValueOf(potentialNewDataField.get(objectField));
                // .equals would give null pointer exception
                if(dataFieldString != potentialNewDataFieldString){
                    isMatching = false;
                    break;
                }
            }
    }        
        return isMatching;
    }

    public static DataDictionaryObjects.DataFieldScopeWrapper dataFieldsInScope(List<RecordType> dataRecordsInScope){

        Set<String> sObjectsInScope = new Set<String>();
        Set<Id> recordTypeIds = new Set<Id>();
        Map<String, Id> dataFieldsMap = new Map<String,Id>();
        for(RecordType dataRecord :dataRecordsInScope){
            sObjectsInScope.add(dataRecord.SobjectType);
            recordTypeIds.add(dataRecord.Id);
            system.debug('dataRecord: '+dataRecord);
        }

        system.debug('sObjectsInScope: '+sObjectsInScope);
        List<Data_Field__c> dataFieldList = [Select Id, Name, Data_Object__r.Name
                                            from Data_Field__c
                                            where Data_Object__r.Name IN :sObjectsInScope 
                                            AND Type__c IN ('COMBOBOX', 'MULTIPICKLIST', 'PICKLIST')];
        //loop through and put DataField Key and Id in Map
        for(Data_Field__c dataField :dataFieldList){
            dataFieldsMap.put(dataField.Data_Object__r.Name+'|'+dataField.Name, dataField.Id);
        }

        system.debug('dataFieldsMap: '+dataFieldsMap);
        DataDictionaryObjects.DataFieldScopeWrapper wrapper = new DataDictionaryObjects.DataFieldScopeWrapper();
        wrapper.dataFieldsIdMap = dataFieldsMap;
        wrapper.ScopeRecordTypeIdSet = recordTypeIds;
        return wrapper;
    }

    public static Data_Field_Record_Type_Picklist__c createDFRTP(DataDictionaryObjects.ValuesClass valueItem, Id DataFieldId, Id DataObjRTId){
        Data_Field_Record_Type_Picklist__c newDFRTP = new Data_Field_Record_Type_Picklist__c();
        newDFRTP.Name = valueItem.label;
        newDFRTP.Attributes__c = String.ValueOf(valueItem.attributes);
        if(DataFieldId != null){
        newDFRTP.Data_Field__c = DataFieldId;
        }else{
            system.debug('Null Id: '+DataFieldId);
        }
        newDFRTP.Data_Object_Record_Type__c = DataObjRTId;
        newDFRTP.Picklist_API_Name__c = valueItem.value;

        return newDFRTP;
    }

    @AuraEnabled(cacheable=true)
    public static Id submitDataObjectBatch(){
        DataDictionaryObjects_Batch dObjBatch = new DataDictionaryObjects_Batch();
        Id batchId = Database.executeBatch(dObjBatch);
        return batchId;
    }   

    @AuraEnabled(cacheable=true)
    public static Id submitDataPicklistBatch(){
        system.debug('here');
        DataDictionaryPicklist_Batch dPickBatch = new DataDictionaryPicklist_Batch();
        Id batchId = Database.executeBatch(dPickBatch);
        return batchId;
    }
}