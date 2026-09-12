// navTab.js
import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class navigateToConfig extends NavigationMixin(LightningElement) {

  navigateNext() {
    this[NavigationMixin.Navigate]({
      type: "standard__navItemPage",
      attributes: {
        apiName: Add/Remove_Shift,
      },
    });
  }
}