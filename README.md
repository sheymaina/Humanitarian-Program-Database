 Humanitarian Program Database
 Project Overview
This project is a relational database system designed to manage data for a humanitarian program.
It focuses on tracking partners, beneficiaries, and resource distribution while ensuring accountability through automated logging.


Objectives
- Manage beneficiary and partner data efficiently  
- Track humanitarian aid distribution  
- Maintain data integrity using constraints  
- Implement automation using triggers  
- Log system activities for transparency and auditing  


Tools & Technologies
- SQL  
- MySQL  
- MySQL Workbench  

 Database Structure

Main Table
- beneficiary_partner_data
- Stores partner name, location (village), number of beneficiaries, and beneficiary type  

Audit Table
- audit_log
- Records system actions such as inserts  
- Fields:
- log_id (Primary Key)  
- action (Description of activity)  
- created_at (Timestamp)


 Triggers

A trigger is implemented to automatically log actions whenever a new record is added

Trigger: log_insert
- Executes AFTER INSERT on beneficiary_partner_data
- Automatically inserts a record into audit_log

This ensures all changes are tracked without manual intervention.


 How to Run the Project

1. Open MySQL Workbench  
2. Run the SQL script in this order:
- Create tables  
- Create trigger  
3. Insert sample data into beneficiary_partner_data  
4. Run:
   sql    SELECT * FROM audit_log;    
5. Verify that actions are logged automatically  

Features
- Structured relational database  
- Use of primary and auto-increment keys  
- Trigger-based automation  
- Activity logging for auditing  
- Simple and scalable design  


 Project Files
- database.sql – contains table creation and trigger  
- README.md – project documentation  
 

 Author
Esther Maina
