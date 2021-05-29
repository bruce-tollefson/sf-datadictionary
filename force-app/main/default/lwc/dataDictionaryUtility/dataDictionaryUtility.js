import { LightningElement } from 'lwc';
import submitDataObjectBatch from '@salesforce/apex/DataDictionaryUtility.submitDataObjectBatch';
import submitDataPicklistBatch from '@salesforce/apex/DataDictionaryUtility.submitDataPicklistBatch';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class DataDictionaryUtility extends LightningElement {

    //doesn't fire new batches right away if the buttons are clicked to quickly next to each other
    toast = {};
    newObjectId; //used to track if a new batch id is created
    oldObjectId; //used to track old batch id
    newPicklistId; //used to track if a new batch id is created
    oldPicklistId; //used to track old batch id

    handleDataObjectClick() {
        submitDataObjectBatch().then(result => {
            this.newObjectId = result;
            if(this.newObjectId != this.oldObjectId){
            this.oldObjectId = result;
            this.toast.message = 'Data Object Batch has started';
            this.toast.variant = 'success';
            this.showToast(this.toast);
            }else{
                this.toast.message = 'Data Object Batch has not started try again in a little while or refresh the page';
                this.toast.variant = 'warning';
                this.showToast(this.toast);
            }
        }).catch( error => {
                this.toast.message = `An error occured: ${error}`;
                this.toast.variant = 'error';
                this.showToast(this.toast);
            });
    }

    handleDataPicklistClick() {
        submitDataPicklistBatch().then(result => {
            this.newPicklistId = result;
            if(this.newPicklistId != this.oldPicklistId){
            this.oldPicklistId = result;
            this.toast.message = 'Data Picklist Batch has started';
            this.toast.variant = 'success';
            this.showToast(this.toast);
            }else{
                this.toast.message = 'Data Picklist Batch has not started try again in a little while or refresh the page';
                this.toast.variant = 'warning';
                this.showToast(this.toast);
            }
        }).catch( error => {
            this.toast.message = `An error occured: ${error}`;
            this.toast.variant = 'error';
            this.showToast(this.toast);
        });
    }

    showToast(obj){
        const event = new ShowToastEvent({
            message: obj.message,
            variant: obj.variant
        });
        this.dispatchEvent(event);
    }
}