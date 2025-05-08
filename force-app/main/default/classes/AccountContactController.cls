public with sharing class AccountContactController {
    
    @AuraEnabled
    public static List<Contact> getAccountContacts(Id accountId) {
        return [SELECT Id, FirstName, LastName, Name, Email 
                FROM Contact 
                WHERE AccountId = :accountId 
                ORDER BY Name ASC];
    }
    
    @AuraEnabled
    public static Contact saveContact(Contact contact) {
        // Validate required fields
        if (String.isBlank(contact.LastName)) {
            throw new AuraHandledException('Last Name is required');
        }
        
        // Validate email format if provided
        if (String.isNotBlank(contact.Email)) {
            String emailRegex = '^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$';
            Pattern emailPattern = Pattern.compile(emailRegex);
            Matcher emailMatcher = emailPattern.matcher(contact.Email);
            
            if (!emailMatcher.matches()) {
                throw new AuraHandledException('Invalid email format');
            }
        }
        
        try {
            upsert contact;
            return contact;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating contact: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Contact updateContact(Contact contact) {
        // Validate required fields
        if (String.isBlank(contact.LastName)) {
            throw new AuraHandledException('Last Name is required');
        }
        
        // Validate email format if provided
        if (String.isNotBlank(contact.Email)) {
            String emailRegex = '^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$';
            Pattern emailPattern = Pattern.compile(emailRegex);
            Matcher emailMatcher = emailPattern.matcher(contact.Email);
            
            if (!emailMatcher.matches()) {
                throw new AuraHandledException('Invalid email format');
            }
        }
        
        try {
            update contact;
            return contact;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating contact: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteContact(Id contactId) {
        try {
            delete new Contact(Id = contactId);
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting contact: ' + e.getMessage());
        }
    }
}