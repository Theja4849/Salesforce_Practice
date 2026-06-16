import { LightningElement } from 'lwc';

export default class DataBindingExample extends LightningElement {
   details={
    name:'',
    age:'',
    company:'',
    email:''
   }

    isOpen=false

   //employees empty objects 
   employees=[]

   //to handle input change
   handleInputChange(event){
    console.log('handle input triggered',event.target.dataset.field, event.target.value)
      this.details={
        ...this.details,
        [event.target.dataset.field]:event.target.value
      }

   }

   handleSubmit(){
     console.log('Submitted Data');
    this.employees.push(this.details)
    console.log("displaying employees", JSON.stringify(this.employees))

    
      this.details={
        name:'',
        age:'',
        company:'',
        email:''
      }
    
   }

   handleEmployees(){
    console.log("triggering handle employee function")
    if(this.isOpen==true) this.isOpen=false
    else this.isOpen=true

   }
}

//Data Binding is the process of connecting JavaScript properties 
// with HTML elements so that data can be displayed and updated automatically 
// between the component's JavaScript controller and UI.


// 1. id : it is used to uniquely identify an element 
//       ex: <input id="userName" type="text" />
//       Access in JavaScript:   this.template.querySelector('#userName');
// 2.  Value: it is used to display or store current value
//       ex: <input value={userName} />
// 3.  data-field : is used to give field name
//       ex: <input data-field="name" />
//       Access in JavaScript: const field = event.target.dataset.field;

