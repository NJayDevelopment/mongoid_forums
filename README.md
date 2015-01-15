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
- [ ] Generator to easily setup mongoid_forums, also to not depend on a model specifically named User
- [ ] Mass moderation (here users can mass moderate their own posts and hide their topics, and a moderator can hide OTHER user's topics and posts
- [ ] More admin panel controls (changing forum names, changing categories, etc)
- [ ] Option to have to approve topics/posts manually
- [ ] Category/Forum/Topic/Post visibility level. 
