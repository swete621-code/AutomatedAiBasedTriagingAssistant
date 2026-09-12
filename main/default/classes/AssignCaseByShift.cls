public class AssignCaseByShift {

    private static Boolean isRunning = false;

    // Get all shifts
    public static List<Shift__c> getAllShifts() {
        return [
            SELECT Id, Start_Time__c, End_Time__c, Name
            FROM Shift__c
        ];
    }


    public static Shift__c getActiveShift() {
        
        Time currentTime = System.now().time();
        System.debug('Current Local Time: ' + currentTime);
        List<Shift__c> shifts = getAllShifts();

        for (Shift__c s : shifts) {

            if (s.Start_Time__c == null || s.End_Time__c == null) {
                continue;
            }


            if (s.Start_Time__c <= s.End_Time__c) {

                if (currentTime >= s.Start_Time__c &&
                    currentTime <= s.End_Time__c) {
                    return s;
                }
            }

            else {

                if (currentTime >= s.Start_Time__c ||
                    currentTime <= s.End_Time__c) {
                    return s;
                }
            }
        }

        return null;
    }

    //  Get cases
    public static List<Case> giveCases() {
        return [
            SELECT Id, OwnerId, Status, CreatedDate, ClosedDate, Owner.Name
            FROM Case
            WHERE OwnerId != null
        ];
    }

    // Get shift members
    public static List<Shift_Member__c> getAllMembers() {

        Shift__c activeShift = getActiveShift();

        if (activeShift == null) {
            return new List<Shift_Member__c>();
        }

        return [
            SELECT Id, Name, User__c, Order__c
            FROM Shift_Member__c
            WHERE Shift__c = :activeShift.Id
            ORDER BY Order__c ASC
        ];
    }

    //  MAIN METHOD (ROUND ROBIN)
    public static void fun(Set<Id> caseIds, Id oweaId) {

        if (isRunning) return;
        isRunning = true;

        try {

            if (caseIds == null || caseIds.isEmpty()) return;

            Shift__c activeShift = getActiveShift();

            List<Case> caseList = [
                SELECT Id, OwnerId
                FROM Case
                WHERE Id IN :caseIds
                ORDER BY CreatedDate ASC
            ];

            if (caseList.isEmpty()) return;

            List<Shift_Member__c> members = new List<Shift_Member__c>();

            //  No shift → fallback
            if (activeShift == null) {
                fallbackAssignment(caseList);
                notifyAdmin('noUser', members, oweaId);
                update caseList;
                return;
            }

            // Fetch members
            members = [
                SELECT Id, Name, User__c, Order__c
                FROM Shift_Member__c
                WHERE Shift__c = :activeShift.Id
                ORDER BY Order__c ASC
            ];

            if (members.isEmpty()) {
                fallbackAssignment(caseList);
                notifyAdmin('noUser', members, oweaId);
                update caseList;
                return;
            }

            if (members.size() == 1) {
                notifyAdmin('singleUser', members, oweaId);
            }

            //  Round robin config
            List<RoundRobinSetting__c> settings = [
                SELECT Id, Last_Index__c
                FROM RoundRobinSetting__c
                LIMIT 1
                FOR UPDATE
            ];

            if (settings.isEmpty()) return;

            RoundRobinSetting__c setting = settings[0];

            Integer startIndex = 0;

            for (Integer i = 0; i < members.size(); i++) {
                if (members[i].Order__c == setting.Last_Index__c) {
                    startIndex = i + 1;
                    break;
                }
            }

            startIndex = Math.mod(startIndex, members.size());

            // Assign cases
            for (Integer i = 0; i < caseList.size(); i++) {

                Integer currentIndex = Math.mod(startIndex + i, members.size());

                if (members[currentIndex].User__c != null) {
                    caseList[i].OwnerId = members[currentIndex].User__c;
                    setting.Last_Index__c = members[currentIndex].Order__c;
                }
            }

            update setting;
            update caseList;

        } finally {
            isRunning = false;
        }
    }

    // Fallback logic
    private static void fallbackAssignment(List<Case> caseList) {

        Id ownerId;

        List<Group> queues = [
            SELECT Id
            FROM Group
            WHERE Name = 'Common Queue'
            AND Type = 'Queue'
            LIMIT 1
        ];

        if (!queues.isEmpty()) {
            ownerId = queues[0].Id;
        } else {

            List<User> users = [
                SELECT Id
                FROM User
                WHERE IsActive = true
                AND UserRole.Name = 'Support Admin'
                LIMIT 1
            ];

            ownerId = (!users.isEmpty())
                ? users[0].Id
                : UserInfo.getUserId();
        }

        for (Case c : caseList) {
            c.OwnerId = ownerId;
        }
    }

    //  Notify admin
    private static void notifyAdmin(
        String userNumber,
        List<Shift_Member__c> members,
        Id oweaId
    ) {

        List<User> admins = [
            SELECT Email
            FROM User
            WHERE IsActive = true
            AND UserRole.Name = 'Support Admin'
            LIMIT 1
        ];

        if (admins.isEmpty()) return;

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setToAddresses(new List<String>{ admins[0].Email });

        if (oweaId != null) {
            email.setOrgWideEmailAddressId(oweaId);
        }

        if (userNumber == 'noUser') {
            email.setSubject('No user in shift');
            email.setHtmlBody('No users are configured for the active shift.');
        }
        else if (userNumber == 'singleUser') {

            String names = '';

            for (Shift_Member__c m : members) {
                names += m.Name + ', ';
            }

            email.setSubject('Only one user in shift');
            email.setHtmlBody('Only one user configured: ' + names);
        }

        Messaging.sendEmail(
            new List<Messaging.SingleEmailMessage>{ email }
        );
    }
}