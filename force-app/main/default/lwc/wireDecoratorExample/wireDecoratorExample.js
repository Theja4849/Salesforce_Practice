import { LightningElement,wire } from 'lwc';
import getTopRevenueAccounts from '@salesforce/apex/getTopRevenueAccounts.getTopRevenueAccounts'
export default class WireDecoratorExample extends LightningElement {
    accountsToDisplay=[]

    //this is by using wire approach
    // @wire(getTopRevenueAccounts)
    // getAccountsHandler(response){

    //     const {data,error}= response;
    //     if(error){
    //         console.log("Error in getting accounts",error);
    //         return 
    //     }
    //     if(data) {
    //         // this.accountsToDisplay=data
    //         console.log("got accounts  from apex",data)
    //     }
    //   }


    //imperative approach to get apex class data
    connectedCallback(){
        getTopRevenueAccounts().then((response)=>{

            console.log("response using imperative approach",response)
            this.accountsToDisplay=response
        }).catch(error=>{
            console.log("Error in getting accounts",error)
        })
    }

     get hasAccounts() {
    return this.accountsToDisplay &&
           this.accountsToDisplay.length > 0;
}
     
}