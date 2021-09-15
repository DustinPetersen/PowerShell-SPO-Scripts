A little console application that stops inheriting permissions for all the items in a site collection. It is equivalent of the button "Stop Inheriting Permissions" in the Permission Settings for a document/library or a site.

<img src="../Break Inheritance for all items in site/breakinheritance.png">

The code breaks inheritance in:
- files
- list items
- folders
- subfolders and their content
- lists and libraries
- sites/subsites


 


**It does NOT remove the permissions!** The permissions remain as they were.


It will NOT stop inheriting permissions in:


- root site collection for the collection  (by design). It will delete unique permissions for all the CONTENT of a site collection


- list and libraries which exceeded the limit of 5000 items (by design)




 

At the end a simple report will be generated in ```C:\Users\Public```

 

Below you can find full function reponsible for the breaking permission inheritance - don't hesitate to improve and comment on it in the Q&A section!

