MongoidForums
============

A forum system for Rails 4 and Mongoid. 

# Installation

```ruby
gem 'mongoid-forums'
```

## Run the installer

**Ensure that you first of all have a `User` model and some sort of authentication system set up**. We would recommend going with [Devise](http://github.com/plataformatec/devise), but it's up to
you. All MongoidForums needs is a model to link topics and posts to.

Run the installer and answer any questions that pop up. There's sensible defaults there if you don't want to answer them.

```shell
rails g mongoid_forums:install
```

## Set up helper methods in your user model

MongoidForums depends on a `forum_display_name` (which defaults as `to_s`) method being available on your `User` model so that it can display the user's name in posts. Define it in your model like this:

```ruby
def forum_display_name
  name
end
```
Or simply return the user's display name as the `to_s` method in your user model.

Please note that if you are using Devise, User model does not have `name` column by default,
so you either should use custom migration to add it or use another column (`email` for example).



MongoidForums is not as flexible as Forem, nor does it have all the functionality, but forem does not support Mongoid and thus this project was created. This project aspires to eventually have all the functionality of Forem, along with more features.
The code for this project intends to remain simple.

The routes (along with some other designs such as Alerts system) for this project are based around Overcast Network's forum system (https://oc.tc/forums)

See here for the public version this project is based on (and borrows some code from):
https://github.com/kultus/forem-2


TODO:
- [X] Permissions system
- [X] Sticky
- [X] Hidden
- [X] Pinned
- [X] Views tracking
- [X] Subscribing to topics + getting alerts
- [X] Generator to easily setup mongoid_forums, also to not depend on a model specifically named User
- [X] Ability to obtain how many posts a user has not read for a topic and how many topics a user has not seen for a forum
- [ ] Archiving
- [ ] Mass moderation (here users can mass moderate their own posts and hide their topics, and a moderator can hide OTHER user's topics and posts
- [ ] More admin panel controls (changing forum names, changing categories, etc)
- [ ] Option to have to approve topics/posts manually
- [ ] Category/Forum/Topic/Post visibility level. 
