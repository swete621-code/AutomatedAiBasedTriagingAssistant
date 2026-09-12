public class DashboardController {

@AuraEnabled(cacheable=true)
    public static Shift__c getActiveShift(){
        
    Shift__c activeShift= AssignCaseByShift.getActiveShift();    
    return activeShift;
    
    }
    
@AuraEnabled(cacheable=true)
    public static List<Case> getAllCases(){
        
    return AssignCaseByShift.giveCases();
    }

@AuraEnabled(cacheable=true)
    public static List<Shift_Member__c> getAllMembers(){
        
    return AssignCaseByShift.getAllMembers();
    }
    
@AuraEnabled(cacheable=true)
    public static List<Shift__c> getAllShifts(){
        
    return AssignCaseByShift.getAllShifts();
    }
    
@AuraEnabled
public static void saveShift(String name, String startTime, String endTime) {
    Shift__c shift = new Shift__c();
    shift.Name = name;
    
    List<String> startParts = startTime.split(':');
    shift.Start_Time__c = Time.newInstance(
        Integer.valueOf(startParts[0]),
        Integer.valueOf(startParts[1]),
        0, 0
    );
    
    List<String> endParts = endTime.split(':');
    shift.End_Time__c = Time.newInstance(
        Integer.valueOf(endParts[0]),
        Integer.valueOf(endParts[1]),
        0, 0
    );
    
    insert shift;
}
    
@AuraEnabled
    public static void deleteShift(String name, String startTime, String endTime){
        
    List<String> startParts = startTime.split(':');
    Time startT = Time.newInstance(
        Integer.valueOf(startParts[0]),
        Integer.valueOf(startParts[1]),
        0, 0
    );
    
    List<String> endParts = endTime.split(':');
     Time endT= Time.newInstance(
        Integer.valueOf(endParts[0]),
        Integer.valueOf(endParts[1]),
        0, 0
    );
    
    Shift__c shift =[
        Select Id from Shift__c
        where Name = :name
        and Start_Time__c= :startT
        and End_Time__c = :endT
        Limit 1
    ];
    delete shift;        
    }
    
}