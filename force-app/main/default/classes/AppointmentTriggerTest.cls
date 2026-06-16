@isTest
private class AppointmentTriggerTest {

    @isTest
    static void testPreventDoubleBooking() {

        // Create Doctor
        Doctor__c doctor = new Doctor__c(
             Name= 'Dr. Rajesh Kumar',
            Specialization__c = 'Cardiology',
            Consultation_Fee__c = 1000,
            Availability_Status__c = 'Available',
            Is_Active__c = true
        );
        insert doctor;

        // Create Patients
        Patient__c patient1 = new Patient__c(
            Name = 'John Doe',
            Phone__c = '9976543210',
            Email__c='jhone@gmail.com',
            Status__c = 'New'
        );
        insert patient1;

        Patient__c patient2 = new Patient__c(
            Name = 'Jane Doe',
            Phone__c = '9976543211',
            Email__c='jhonedoe@gmail.com',
           Status__c = 'New'
        );
        insert patient2;

        // First appointment
        Appointment__c firstAppointment = new Appointment__c(
            Patient__c = patient1.Id,
            Doctor__c = doctor.Id,
            Appointment_Date__c = Date.today().addDays(1),
            Appointment_Time__c = Time.newInstance(10, 0, 0, 0),
            Status__c = 'Confirmed',
            Consultation_Type__c='Home Visit'
        );
        insert firstAppointment;

        // Conflicting appointment
        Appointment__c conflictingAppointment = new Appointment__c(
            Patient__c = patient2.Id,
            Doctor__c = doctor.Id,
            Appointment_Date__c = Date.today().addDays(1),
            Appointment_Time__c = Time.newInstance(10, 0, 0, 0),
            Status__c = 'Confirmed',
            Consultation_Type__c='Home Visit'
        );

        Test.startTest();
        Database.SaveResult result =
            Database.insert(conflictingAppointment, false);
        Test.stopTest();

        System.assertEquals(false, result.isSuccess());
        System.assert(
            result.getErrors()[0].getMessage().contains('already has an appointment')
        );
    }

    @isTest
    static void testAllowDifferentTime() {

        // Create Doctor
        Doctor__c doctor = new Doctor__c(
            Name = 'Dr. Priya Sharma',
            Specialization__c = 'General Medicine',
            Consultation_Fee__c = 800,
            Availability_Status__c = 'Available',
            Is_Active__c = true
        );
        insert doctor;

        // Create Patients
        Patient__c patient1 = new Patient__c(
            Name = 'Patient One',
            Phone__c = '9976543212',
           Status__c = 'New',
           Email__c='patient1@gmail.com'
        );
        insert patient1;

        Patient__c patient2 = new Patient__c(
            Name = 'Patient Two',
            Phone__c = '9976543213',
           Status__c = 'New',
           Email__c='patient2@gmail.com'

        );
        insert patient2;

        // First appointment
        insert new Appointment__c(
            Patient__c = patient1.Id,
            Doctor__c = doctor.Id,
            Appointment_Date__c = Date.today().addDays(1),
            Appointment_Time__c = Time.newInstance(10, 0, 0, 0),
            Status__c = 'Confirmed',
            Consultation_Type__c='Home Visit'
        );

        // Second appointment at different time
        Test.startTest();
        insert new Appointment__c(
            Patient__c = patient2.Id,
            Doctor__c = doctor.Id,
            Appointment_Date__c = Date.today().addDays(1),
            Appointment_Time__c = Time.newInstance(11, 0, 0, 0),
            Status__c = 'Confirmed',
            Consultation_Type__c='Home Visit'
        );
        Test.stopTest();

        System.assertEquals(
            2,
            [SELECT COUNT() FROM Appointment__c WHERE Doctor__c = :doctor.Id]
        );
    }
}