import { LightningElement, wire } from 'lwc';
import getActiveShift from '@salesforce/apex/DashboardController.getActiveShift';
import getAllCases from '@salesforce/apex/DashboardController.getAllCases';
import { NavigationMixin } from "lightning/navigation";

export default class DashBoardPage extends NavigationMixin(LightningElement) {

    activeShift;
    shiftError;

    cases = [];
    caseError;

    columns = [
        { label: 'Case Number', fieldName: 'Id', type: 'text' },
        { label: 'Assigned To', fieldName: 'OwnerName', type: 'text' },
        { label: 'Status', fieldName: 'Status', type: 'text' },
        {
            label: 'Created Time',
            fieldName: 'CreatedDate',
            type: 'date',
            typeAttributes: {
                year: "numeric",
                month: "2-digit",
                day: "2-digit",
                hour: "2-digit",
                minute: "2-digit"
            }
        },
        {
            label: 'End Time',
            fieldName: 'ClosedDate',
            type: 'date',
            typeAttributes: {
                year: "numeric",
                month: "2-digit",
                day: "2-digit",
                hour: "2-digit",
                minute: "2-digit"
            }
        }
    ];

    @wire(getActiveShift)
    wiredActiveShift({ error, data }) {
        
        if (data) {

            let startMilliseconds = data.Start_Time__c || 0;
            let endMilliseconds = data.End_Time__c || 0;

            let startTime = this.convertMillisecondsToTime(startMilliseconds);
            let endTime = this.convertMillisecondsToTime(endMilliseconds);

            this.activeShift = {
                ...data,
                startTime,
                endTime
            };

            this.shiftError = undefined;

        } else if (error) {
            this.shiftError = error;
            console.error(error);
        }
    }

    @wire(getAllCases)
    wiredCases({ error, data }) {
        if (data) {
            console.log("case data",data);
            this.cases = data.map(row => ({
                ...row,
                OwnerName: row.Owner ? row.Owner.Name : ''
            }));
            this.caseError = undefined;

        } else if (error) {
            this.caseError = error;
            this.cases = [];
        }
    }

    convertMillisecondsToTime(ms) {
        let hour = Math.floor(ms / (1000 * 60 * 60));
        let minute = Math.floor((ms % (1000 * 60 * 60)) / (1000 * 60));
        let second = Math.floor((ms % (1000 * 60)) / 1000);

        return `${hour.toString().padStart(2,'0')}:` +
               `${minute.toString().padStart(2,'0')}:` +
               `${second.toString().padStart(2,'0')}`;
    }

    navigateToConfig() {
        try {
            this[NavigationMixin.Navigate]({
                type: "standard__navItemPage",
                attributes: {
                    apiName: 'Shift_Configuration_Page',
                },
            });
            console.log("navigation executed");
        } catch (error) {
            console.error(error);
        }
    }
}