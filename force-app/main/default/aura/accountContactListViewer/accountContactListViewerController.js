({
    doInit: function(component, event, helper) {
        helper.getContacts(component)
    },
    
    openNewContactModal: function(component, event, helper) {
        component.set("v.newContact", { 
            'sobjectType': 'Contact', 
            'FirstName': '', 
            'LastName': '', 
            'Email': '',
            'AccountId': component.get("v.recordId")
        })
        component.set("v.emailError", "")
        component.set("v.isNewContactModalOpen", true)
    },
    
    closeNewContactModal: function(component, event, helper) {
        component.set("v.isNewContactModalOpen", false)
    },
    
    saveNewContact: function(component, event, helper) {
        var newContact = component.get("v.newContact")
        
        if (!newContact.FirstName || !newContact.LastName || !newContact.Email) {
            component.set("v.emailError", "All fields are required")
            return
        }
        
        var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/
        if (!emailPattern.test(newContact.Email)) {
            component.set("v.emailError", "Please enter a valid email address")
            return
        }
        
        helper.createContact(component)
    },
    
    handleEditClick: function(component, event, helper) {
        var contactId = event.getSource().get("v.value")
        var contacts = component.get("v.contacts")
        var selectedContact = contacts.find(contact => contact.Id === contactId)
        
        if (selectedContact) {
            // Create a deep copy of the contact
            var contactCopy = JSON.parse(JSON.stringify(selectedContact))
            
            // Ensure AccountId is set
            contactCopy.AccountId = component.get("v.recordId")
            
            // Set the selected contact
            component.set("v.selectedContact", contactCopy)
            component.set("v.contactToEditId", contactId)
            component.set("v.emailError", "")
            component.set("v.showEditConfirmation", true)
        }
    },
    
    cancelEdit: function(component, event, helper) {
        component.set("v.showEditConfirmation", false)
        component.set("v.contactToEditId", "")
        component.set("v.emailError", "")
    },
    
    confirmEdit: function(component, event, helper) {
        var selectedContact = component.get("v.selectedContact")
        
        // Validate required fields
        if (!selectedContact.FirstName || !selectedContact.LastName || !selectedContact.Email) {
            component.set("v.emailError", "All fields are required")
            return
        }
        
        // Validate email format
        var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/
        if (!emailPattern.test(selectedContact.Email)) {
            component.set("v.emailError", "Please enter a valid email address")
            return
        }
        
        // Ensure AccountId is set
        selectedContact.AccountId = component.get("v.recordId")
        
        // Close the modal
        component.set("v.showEditConfirmation", false)
        component.set("v.contactToEditId", "")
        component.set("v.emailError", "")
        
        // Update the contact
        helper.performEdit(component, selectedContact)
    },
    
    handleDeleteClick: function(component, event, helper) {
        var contactId = event.getSource().get("v.value")
        component.set("v.contactToDeleteId", contactId)
        component.set("v.showDeleteConfirmation", true)
    },
    
    cancelDelete: function(component, event, helper) {
        component.set("v.showDeleteConfirmation", false)
        component.set("v.contactToDeleteId", "")
    },
    
    confirmDelete: function(component, event, helper) {
        var contactId = component.get("v.contactToDeleteId")
        component.set("v.showDeleteConfirmation", false)
        
        if (contactId) {
            helper.performDelete(component, contactId)
        }
    }
})