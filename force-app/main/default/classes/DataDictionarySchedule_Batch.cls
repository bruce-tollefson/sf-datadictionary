global class DataDictionarySchedule_Batch implements Schedulable{
    
    global void execute(SchedulableContext sc)
    {
       
        DataDictionaryObjects_Batch DDOFB = new DataDictionaryObjects_Batch();
        Id batchId = Database.executeBatch(DDOFB);
    }
   
}