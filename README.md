= MongoidForums

A forum system for Rails 4 and Mongoid. 

MongoidForums will work as long as you're using a User model to represent your user (named exactly "User", this is an issue and we are working towards adding generators to allow any User model with any name) and have a helper method current_user to get the current user instance. Additionally it requires you have the method ```forum_display_name``` in your User model (again, later this will be injected into your model automatically using the generator).

MongoidForums is not as flexible as Forem, nor does it have all the functionality, but forem does not support Mongoid and thus this project was created. This project aspires to eventually have all the functionality of Forem, along with more features.
The code for this project intends to remain simple.

The routes (along with some other designs such as Alerts system) for this project are based around Overcast Network's forum system (https://oc.tc/forums)
See here for the public version this project is based on:
https://github.com/kultus/forem-2


TODO:
- [X] Permissions system
- [X] Sticky
- [X] Hidden
- [X] Pinned
- [ ] Archiving
- [X] Subscribing to topics + getting alerts
- [ ] Moderating topics (removing, editing, hiding). Users can edit their own posts/topics as of right now.
- [ ] Category/Forum/Topic/Post visibility level. 
