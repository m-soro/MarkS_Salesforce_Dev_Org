public with sharing class JokeAPIHandler {
    
    // Returned joke object
    public class JokeResponse{
        @AuraEnabled public Boolean isTwoPart;
        @AuraEnabled public String joke;
        @AuraEnabled public String setup;
        @AuraEnabled public String delivery;
    }

    // Method to call the Joke API
    @AuraEnabled(cacheable=true)
    public static JokeResponse getJoke(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:JokeAPI/joke/Programming');
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        JokeResponse jokeResult = new JokeResponse();

        if(response.getStatusCode() == 200){
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            String type = (String) result.get('type');
            if (type == 'single'){
                jokeResult.isTwoPart = false;
                jokeResult.joke = (String) result.get('joke');
            } else if (type == 'twopart'){
                jokeResult.isTwoPart = true;
                jokeResult.setup = (String) result.get('setup');
                jokeResult.delivery = (String) result.get('delivery');
            } 
        } else {
            throw new AuraHandledException('Failed to fetch joke: ' + response.getStatusCode());
        }
        return jokeResult;
    }
} 