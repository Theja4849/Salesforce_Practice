import { LightningElement,api } from 'lwc';

export default class DisplayEmployeesDataInChild extends LightningElement {


    @api employees;

    
      connectedCallback(){
        console.log('Employees Recived in Child component', JSON.stringify(this.employees))
      }


}