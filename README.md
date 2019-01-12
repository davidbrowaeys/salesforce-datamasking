# Salesforce Datamasking

This package ...

## Usage
<b>Objects:</b> Lead, Account, Contact

1. Install datamasking plugin in your sandbox by deploying the package under 'pre' folder. This will install all the apex classes, triggers, ... that are required. 

2. Prepare the masking config for each object as describe below

3. Export ALL record id of your objects using any extraction tools such as dataloader, sfdx, workbench, reports.

4. Perform dummy update on all extracted files using any data tools such as dataloader. Make sure you enable BULK API mode if you have a large volume of data. 

5. Once done, make sure you delete ALL the created trigger installed in step 1.

## Masking Config

For each object, you must create a new static resource that will hold the data masking mapping. 

Go to Dveloper Console  > New  > Static Resources and select application/json and call the file : 

DataMasking<i>{{ObjectName}}</i>, i.e.: DataMaskingLead

### Keywords:

* random_name
* random_date
* random_email
* random_phone
* random_street
* random_num
* random_num_str::<i>n</i> where n is the number of digits

### Examples

{
    "Name"              : "random_name",
    "Email__c"          : "random_email",
    "BillingStreet"     : "random_street",
    "BillingPostalCode" : "random_num_str::4"
}


{
    "FirstName"    : "random_name",
    "LastName"     : "random_name",
    "DOB__c"       : "random_date",
    "Email"        : "random_email",
    "Home_Email__c": "random_email",
    "MailingStreet": "random_street",
    "OtherStreet"  : "random_street",
    "Type"         : "Customer",
    "Phone"        : null,
    "HomePhone"    : null,
    "MobilePhone"  : null,
    "OtherPhone"   : null
}
