({
    getContacts: function(component) {
        var action = component.get("c.getAccountContacts");
        action.setParams({ 
            accountId: component.get("v.recordId") 
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.contacts", response.getReturnValue());
            } else {
                console.error("Error fetching contacts", response.getError());
                this.showToast("Error", "Failed to load contacts", "error");
            }
        });
        
        $A.enqueueAction(action);
    },

    createContact: function(component) {
        var action = component.get("c.saveContact");
        action.setParams({ 
            contact: component.get("v.newContact") 
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.isNewContactModalOpen", false);
                this.showToast("Success", "Contact created successfully", "success");
                this.getContacts(component);
            } else {
                console.error("Error creating contact", response.getError());
                this.showToast("Error", "Failed to create contact", "error");
            }
        });
        
        $A.enqueueAction(action);
    },

    performEdit: function(component, contact) {
        var action = component.get("c.updateContact");
        action.setParams({ 
            contact: contact 
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                this.showToast("Success", "Contact updated successfully", "success");
                this.getContacts(component);
            } else {
                var errors = response.getError();
                var message = errors && errors[0] && errors[0].message ? errors[0].message : "Unknown error";
                console.error("Edit error:", message);
                this.showToast("Error", message, "error");
            }
        });
        
        $A.enqueueAction(action);
    },

    performDelete: function(component, contactId) {
        var action = component.get("c.deleteContact");
        action.setParams({ 
            contactId: contactId 
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                this.showToast("Success", "Contact deleted successfully", "success");
                this.getContacts(component);
            } else {
                var errors = response.getError();
                var message = "Unknown error";
                
                if (errors && errors[0]) {
                    var errorMsg = errors[0].message || "";
                    
                    // Check for case association error
                    if (errorMsg.includes("associated with the following cases")) {
                        message = "This contact cannot be deleted because it has associated cases. Please remove the case associations first.";
                    } else {
                        message = errorMsg;
                    }
                }
                
                console.error("Delete error:", message);
                this.showToast("Error", message, "error");
            }
            
            // Close the confirmation modal
            component.set("v.showDeleteConfirmation", false);
        });
        
        $A.enqueueAction(action);
    },

    showToast: function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ 
            title: title, 
            message: message, 
            type: type 
        });
        toastEvent.fire();
    }
})
