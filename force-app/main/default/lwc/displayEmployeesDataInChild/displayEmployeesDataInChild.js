import { LightningElement, api } from 'lwc';
import topRevenueAccounts from '@salesforce/apex/getTopRevenueAccounts.getTopRevenueAccounts'
export default class DisplayEmployeesDataInChild extends LightningElement {


  @api employees;
  @api accountsInfo = []



  @api loadAccountsData() {
    topRevenueAccounts().then((data) => {
      console.log('fetching accounts in child component ')
      this.accountsInfo = data
      console.log("got accounts in child componen", this.accountsInfo)
      const accountEvnt = new CustomEvent('accountsloaded', {
        //here the event name becomes onaccountsloaded in html in parent component
        detail: this.accountsInfo
      })

      this.dispatchEvent(accountEvnt)
      console.log("dispatched event in child component")

    }).catch((error) => {
      console.error("Error in getting accounts in child component", error)
    })
  }

}






// this is the flow i implemented for child to parent communication by using custom events
// =====================================================================================
// User Clicks Get Accounts
//           ↓
// Parent handleAccounts()
//           ↓
// Parent calls Child Method
//           ↓
// Child loadAccounts()
//           ↓
// Apex Call
//           ↓
// Accounts Returned
//           ↓
// dispatchEvent(accountsloaded)
//           ↓
// Parent handleAccountsLoaded()
//           ↓
// accounts assigned
//           ↓
// UI refreshed