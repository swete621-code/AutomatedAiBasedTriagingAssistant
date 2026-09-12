import { LightningElement, wire } from 'lwc';
import getAllShifts from '@salesforce/apex/DashboardController.getAllShifts';
import { NavigationMixin } from "lightning/navigation";

const COLUMNS = [
    { label: 'Shift Name', fieldName: 'Name' },
    { label: 'Start Time', fieldName: 'startTime' },
    { label: 'End Time', fieldName: 'endTime' }
];

export default class ConfigurationPage extends NavigationMixin(LightningElement) {

    shifts = [];
    columns = COLUMNS;

    @wire(getAllShifts)
    wiredShifts({ error, data }) {
        console.log("data is",data);
        if (data) {
            console.log("data is", data);

            this.shifts = data.map(record => {

                // START TIME
                let startMilliseconds = record.Start_Time__c || 0;
                let startHour = Math.floor(startMilliseconds / (1000 * 60 * 60));
                let startMinute = Math.floor(
                    (startMilliseconds % (1000 * 60 * 60)) / (1000 * 60)
                );
                let startSecond = Math.floor(
                    (startMilliseconds % (1000 * 60)) / 1000
                );

                let startTime =
                    startHour.toString().padStart(2, '0') + ':' +
                    startMinute.toString().padStart(2, '0') + ':' +
                    startSecond.toString().padStart(2, '0');

                // END TIME
                let endMilliseconds = record.End_Time__c || 0;
                let endHour = Math.floor(endMilliseconds / (1000 * 60 * 60));
                let endMinute = Math.floor(
                    (endMilliseconds % (1000 * 60 * 60)) / (1000 * 60)
                );
                let endSecond = Math.floor(
                    (endMilliseconds % (1000 * 60)) / 1000
                );

                let endTime =
                    endHour.toString().padStart(2, '0') + ':' +
                    endMinute.toString().padStart(2, '0') + ':' +
                    endSecond.toString().padStart(2, '0');

                return {
                    ...record,
                    startTime,
                    endTime
                };
            });

        } else if (error) {
            console.error("Error:", error);
        }
    }

    addNewShift() {
        this[NavigationMixin.Navigate]({
            type: "standard__navItemPage",
            attributes: {
                apiName: "Add_Remove_Shift",
            },
        });
    }
}