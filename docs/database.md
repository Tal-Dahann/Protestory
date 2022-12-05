## Cloud Firestore Data Structure

#### User Collection:

* User: (User ID is the name of the document)
  * **username** string


#### Protest Collection:

* Protest: (Protest ID i sthe name of the document)
  * **name** string
  * **date** timestamp
  * **creator** string
  * **creation_time** timestamp
  * **participants_amount** integer
  * **contant_info** string
  * **description** string
  * **location** string
  * **editors** array (Sprint 2)
  * **updates** subcollection (Sprint 2)
  * **stories** subcollection:
    * **likes** subcollection (Sprint 2)
    * **content** string
    * **creator** string (user_id)
    * **creation_time** timestamp
  * **tags** array


#### Participants Collection:

* Each document:
  * **user_id** string (id of user doc)
  * **protest_id** string (id of protest doc)
  * **creation_time** timestamp
