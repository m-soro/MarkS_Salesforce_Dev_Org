@isTest
private class AccountContactControllerTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test account
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
    }
    
    @IsTest 
    static void testGetAccountContacts() {
        // Get the test account
        Account testAccount = [SELECT Id FROM Account WHERE Name='Test Account' LIMIT 1];
        
        // Create a test contact
        Contact con = new Contact(
            FirstName='John', 
            LastName='Doe', 
            Email='john.doe@example.com',
            AccountId=testAccount.Id
        );
        insert con;
        
        // Call the method to test
        Test.startTest();
        List<Contact> contacts = AccountContactController.getAccountContacts(testAccount.Id);
        Test.stopTest();
        
        // Verify results
        System.assertEquals(1, contacts.size(), 'Should return exactly one contact');
        System.assertEquals('John', contacts[0].FirstName, 'First name should match');
        System.assertEquals('Doe', contacts[0].LastName, 'Last name should match');
        System.assertEquals('john.doe@example.com', contacts[0].Email, 'Email should match');
    }
    
    @IsTest 
    static void testSaveContactMissingLastName() {
        // Test case 1: Required fields validation
        Test.startTest();
        try {
            Contact contact = new Contact();
            AccountContactController.saveContact(contact);
            System.assert(false, 'Expected exception for missing last name');
        } catch (Exception e) {
            // Just verify an exception was thrown
            System.assert(true, 'Exception was thrown as expected');
        }
        Test.stopTest();
    }
    
    @IsTest 
    static void testSaveContactInvalidEmail() {
        // Test case 2: Invalid email format validation
        Test.startTest();
        try {
            Contact contact = new Contact(LastName = 'Doe', Email = 'invalidemail');
            AccountContactController.saveContact(contact);
            System.assert(false, 'Expected exception for invalid email');
        } catch (Exception e) {
            // Just verify an exception was thrown
            System.assert(true, 'Exception was thrown as expected');
        }
        Test.stopTest();
    }
    
    @IsTest 
    static void testSaveContactSuccess() {
        // Test case 3: Successful contact creation
        Test.startTest();
        Contact contact = new Contact(
            LastName = 'Doe',
            Email = 'john.doe@example.com'
        );
        Contact result = AccountContactController.saveContact(contact);
        Test.stopTest();
        
        // Verify the contact was created
        System.assertNotEquals(null, result.Id, 'Contact ID should not be null');
        
        // Query to verify
        Contact savedContact = [SELECT LastName, Email FROM Contact WHERE Id = :result.Id];
        System.assertEquals('Doe', savedContact.LastName, 'Last name should match');
        System.assertEquals('john.doe@example.com', savedContact.Email, 'Email should match');
    }
    
    @IsTest
    static void testUpdateContactSuccess() {
        // Create a test contact
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com'
        );
        insert testContact;
        
        // Update the contact using the controller method
        Test.startTest();
        testContact.LastName = 'Smith';
        testContact.Email = 'john.smith@example.com';
        Contact updatedResult = AccountContactController.updateContact(testContact);
        Test.stopTest();
        
        // Verify that the contact was updated
        Contact updatedContact = [SELECT LastName, Email FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals('Smith', updatedContact.LastName, 'Last name should be updated');
        System.assertEquals('john.smith@example.com', updatedContact.Email, 'Email should be updated');
    }
    
    @IsTest 
    static void testUpdateContactMissingLastName() {
        // Create a test contact
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com'
        );
        insert testContact;
        
        // Try to update with missing last name
        Test.startTest();
        testContact.LastName = '';
        try {
            AccountContactController.updateContact(testContact);
            System.assert(false, 'Expected exception for missing last name');
        } catch (Exception e) {
            // Just verify an exception was thrown
            System.assert(true, 'Exception was thrown as expected');
        }
        Test.stopTest();
    }
    
    @IsTest 
    static void testUpdateContactInvalidEmail() {
        // Create a test contact
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com'
        );
        insert testContact;
        
        // Try to update with invalid email
        Test.startTest();
        testContact.Email = 'invalidemail';
        try {
            AccountContactController.updateContact(testContact);
            System.assert(false, 'Expected exception for invalid email');
        } catch (Exception e) {
            // Just verify an exception was thrown
            System.assert(true, 'Exception was thrown as expected');
        }
        Test.stopTest();
    }
    
    @IsTest 
    static void testDeleteContact() {
        // Create a test contact
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com'
        );
        insert testContact;
        
        // Call the deleteContact method
        Test.startTest();
        AccountContactController.deleteContact(testContact.Id);
        Test.stopTest();
        
        // Verify that the contact is deleted
        List<Contact> deletedContacts = [SELECT Id FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(0, deletedContacts.size(), 'Contact should be deleted');
    }
    
    @IsTest 
    static void testDeleteContactInvalid() {
        // Try to delete a non-existent contact
        Test.startTest();
        try {
            AccountContactController.deleteContact('003000000000000AAA'); // Invalid ID
            System.assert(false, 'Expected exception for invalid contact ID');
        } catch (Exception e) {
            // Just verify an exception was thrown
            System.assert(true, 'Exception was thrown as expected');
        }
        Test.stopTest();
    }
}