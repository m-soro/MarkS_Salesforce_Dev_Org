import { LightningElement } from 'lwc';
import getJoke from '@salesforce/apex/JokeAPIHandler.getJoke';

export default class JokeViewer extends LightningElement {
    joke;
    setup;
    delivery;
    isTwoPart = false;
    loading = false;
    error = false;


    handleGetJoke() {
        console.log('Button Clicked!');
        this.loading = true;
        this.error = false;
        this.joke = null;
        this.setup = null;
        this.delivery = null;
        this.isTwoPart = false;

        getJoke()
            .then(result => {
                this.loading = false;
                if (result.isTwoPart){
                    this.isTwoPart = true;
                    this.setup = result.setup;
                    this.delivery = result.delivery;
                } else {
                    this.joke = result.joke;
                }
            })
            .catch(error => {
                this.error = true;
                this.loading = false;
                console.log('Error getting joke', error);
            });
    }        
}