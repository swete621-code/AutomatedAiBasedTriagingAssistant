// navTab.js
import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class navigateToConfig extends NavigationMixin(LightningElement) {

  navigateNext() {
    console.log("reached");
    try{
    this[NavigationMixin.Navigate]({
      type: "standard__navItemPage",
      attributes: {
        apiName: 'Shift_Configuration_Page',
      },
    });
    console.log("navigation executed");
  }
  catch(error){
    console.error(error);
}
  }
}