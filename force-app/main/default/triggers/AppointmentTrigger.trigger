trigger AppointmentTrigger on Appointment__c (before insert, before update) {
    AppointmentTriggerHandler.preventDoubleBooking(Trigger.new, Trigger.oldMap);
}