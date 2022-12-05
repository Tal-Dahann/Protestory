User Collection:  (User ID is the name of the document)
	User:	
	-  **username** string
	-  **attending_protests** subcollection  

Protests Collection: (Protest ID is the name of the document)
	Protest:
	- **name** string  
	- **date** timestamp
	- **creator** string (user id)  
	- **creation_time** timestamp
	- **attenders_amount** integer
	- **contact_info** string
	- **description** string
	- **location** string
	- **editors** array (Sprint 2)
	- **tags** array
	- **updates** subcollection (Sprint 2):
	- **stories** subcollection:
	- **likes** subcollection
		- **content** string
	    - **creator** string (user_id)
	    - **creation_time** timestamp

  
Followers Collection:
	Follow:
	- **user_id** string (id of user doc) 
	- **protest_id** string (id of protest doc) 
	- **creation_time** timestamp