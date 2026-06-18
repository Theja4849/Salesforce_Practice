import { LightningElement } from 'lwc';

export default class LifeCycleMethods extends LightningElement {}



             //Life Cycle HOOKS
            //====================
// A Lifecycle Hook is a method that Salesforce automatically calls at
//  different stages of a component's life.
//  ex: constructor() 
//         //called when component is created. rarely used. Initializing variables Setting default values
//                      ex: constructor() {
//                               super();

//                          this.employee = {
//                                name:'',
//                                age:''
//                             };
//                         }
//     connectedCallback()
//         //Called when component is inserted into DOM. like useEffect in react
//                        connectedCallback() {

//                              fetch('/api/employees')
//                             .then(result => result.json())
//                             .then(data => {
//                                   this.employees = data;
//                             });

//                         }

//        ↓
//    render()
//         Internal framework method.
//         Rarely overridden.
//         Salesforce automatically decides which HTML template to render.
//        ↓
//    renderedCallback()
//         Called after HTML is rendered.
//         renderedCallback() {
//             console.log('Rendered');
//         }
            //Third-party library loading in renderedCallback

//        ↓
//    disconnectedCallback()
//           Called when component is removed.
//            disconnectedCallback() {
//                    console.log('Removed');
//             }

             //DECORATORS
             //==============
    // Decorators tell Salesforce how properties should behave. 
    //     1.@wire  2. @api     3. @track(older)   
    
        // @api : makes a property or method publicly accessible to parent components.
        //        Makes property public.Parent can pass data.
        //        <c-child
        //          employee-name="Sai">         (in Parent component)
        //        </c-child>

        //        @api employeeName;   (in child component)
        // @wire: Automatic data fetching.
        //        import getAccounts from '@salesforce/apex/AccountController.getAccounts';

        //        @wire(getAccounts)
        //          accounts;
        //        by using this salesforce automatically calls apex, store result, refreshes UI 

        //        wire with parameters
        //           @api recordId;

        //           @wire(getContacts,{
        //               accountId:'$recordId'
        //           })
        //           contacts;        (here when ever recordid changes it executes again )


        //         @wire(getAccounts)           (wire with functions)
        //              wiredAccounts({data,error}) {

        //                     if(data){
        //                         this.accounts = data;
        //                     }

        //                     if(error){
        //                          console.error(error);
        //                     }
        //             }

//         Parent → Child
//     @api

// Child → Parent
//     CustomEvent

// Unrelated Components
//     Lightning Message Service (LMS)