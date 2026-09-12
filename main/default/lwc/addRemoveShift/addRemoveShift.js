import { LightningElement ,track} from 'lwc';
import saveShift from '@salesforce/apex/DashboardController.saveShift';
import deleteShift from '@salesforce/apex/DashboardController.deleteShift';

export default class AddRemoveShift extends LightningElement {
@track Shift_Records={
Name:'',
Start_Time__c:'',
End_Time__c:''
}

handleChange(event){

const field=event.target.name;
const value=event.target.value;

this.Shift_Records={
    ...this.Shift_Records,
    [field]:value
};


}

addShift(){

console.log("Shift Record is",JSON.stringify(this.Shift_Records));
saveShift({ name:this.Shift_Records.Name, startTime: this.Shift_Records.Start_Time__c, endTime:this.Shift_Records.End_Time__c })
            .then(() => {
                alert('Shift saved successfully!');
            })
            .catch(error => {
                console.error('Error saving shift:', error);
            });
}

removeShift(){

console.log(JSON.stringify(this.Shift_Records));

deleteShift({name:this.Shift_Records.Name, startTime: this.Shift_Records.Start_Time__c, endTime:this.Shift_Records.End_Time__c})
.then(()=>{
alert('Shift deleted successfully');
})
.catch(error=>{
  console.error('Error deleting shift:', error);
});

}

}