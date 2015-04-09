MongoidForums
============

A forum system for Rails 4 and Mongoid. 
Inspired by Forem

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

Please note that if you are using Devise, User model does not have `name` field by default,
so you either should add it or use another column (`email` for example).

The routes (along with some other designs such as Alerts system) for this project are based around Overcast Network's forum system (https://oc.tc/forums)

See here for an old open source version of oc.tc/forums that this project is based on (and borrows some code from):
https://github.com/kultus/forem-2


## Features

Here's a comprehensive list of the features currently in Mongoid Forumsf:

* Forums
  * CRUD operations (provided by an admin backend)
* Topics
  * Viewing all topics for a forum
  * Creating of new topics
  * Editing topics
  * Locking topics
  * Hiding topics
  * Pinning topics
* Posts
  * Replying to topics
  * Deleting own posts
  * Blocking replies to locked topics
  * Editing posts
* Text Formatting
  * Posts are HTML escaped and pre tagged by default.
  * Pluggable formatters for other behaviour
* [A flexible permissions system](https://github.com/radar/forem/wiki/Authorization-System) (Works exactly as Forem does, using CanCanCan and allowing overrides)
* [Translations](https://github.com/radar/forem/wiki/Translations) (Not complete, some messages currently are hardcoded in English)
* [Flexible configuration](https://github.com/radar/forem/wiki/Configuration) (All features of Forem except avatars, profile links, and theme. We are working hard on adding these, but you can also add them to your own project if needed through the default method of overriding rails engine controllers, models, and views!)
## View Customisation

If you want to customise Forem, you can copy over the views using the `mongoid_forums:views` generator:

    rails g mongoid_forums:views

You will then be able to edit the forem views inside the `app/views/mongoid_forums` of your application. These views will take precedence over those in the engine.


## Extending Classes

All of MongoidForum's business logic (models, controllers, helpers, etc) can easily be extended / overridden to meet your exact requirements using standard Ruby idioms.

Standard practice for including such changes in your application or extension is to create a directory app/decorators. place file within the relevant app/decorators/models or app/decorators/controllers directory with the original class name with _decorator appended.

### Adding a custom method to the Post model:

```ruby
# app/decorators/models/mongoid_forums/post_decorator.rb

MongoidForums::Post.class_eval do
  def some_method
    ...
  end
end
```

### Adding a custom method to the PostsController:

```ruby
# app/decorators/controllers/mongoid_forums/posts_controller_decorator.rb

MongoidForums::PostsController.class_eval do
  def some_action
    ...
  end
end
```


Planned Features:
- [ ] [emoji](http://www.emoji-cheat-sheet.com/)
- [ ] Mass moderation
- [ ] Option to have to approve topics/posts manually
- [ ] Block spammers feature
- [ ] Archiving
- [ ] Theming
- [ ] User profile links
- [ ] Avatars

