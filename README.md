# Custom Territory Management



![image](https://user-images.githubusercontent.com/38118062/62330586-c9de7d00-b4c1-11e9-97ab-2576ed961b83.png)




**Standard objects:** User, Account, Contact;	**Custom objects:** Territory, TerrUser, Reference;

 *description*|*description*
--|--| 
Account - Client Company                              | Contact with Account Territory - hierarchical territory
Contact - Contact person in the client company        | User - Salesforce User (Sales Manager)
Refenence - many-to-many relationship                 | TerrUser - many-to-many relationship, determine which User on which Territory


### **Requirements:**
- User should see all Account and Contact in the Territory to which he is added
- If we added an Account to the Territory or transferred to another Territory, the sharing should be adequately recounted, the same for Contact
- The hierarchy of Account visibility for User should be respected, for example, if the Sales Manager is assigned to Ukraine, then he should see all Ukrainian Companies in all areas and all Cities.
- The territory must be unique in Name at its hierarchy level for the same parent territory (for example, Paris can be one in France, while the namesake city Paris can also be in Russia)
- The territory has 3 levels of hierarchy (to provide an opportunity in the future to expand the number of levels of hierarchy)
- The administrator has the right to do everything, the Sales Manager - only to see and edit Account and Contact available through the territory.
- For Frontend, use to the maximum standard Lightning pages
- Do not use the standard connection of the Contact with the Account, do not use the standard Territory management
