ActsAsStashable
===============

This is a little plugin, inspired by James Aylett's [django_session_stashable](https://github.com/jaylett/django_session_stashable).

It allows you to keep track of things you want to stash in the session - it's useful for doing lazy registrations.

Example
=======
Note that you always have to pass the session in from the controller. I don't like the idea of storing state on the model, but I may change this as it's a bit annoying to have to pass it in every time.

Install like:

    rails plugin install git@github.com:whilefalse/rails-3-acts-as-stashable.git

Even better:

  Add this to your Gemfile:

    gem 'rails-3-acts-as-stashable', :git => 'git@github.com:whilefalse/rails-3-acts-as-stashable.git'

  Then:

    bundle install

Setup your model like so:

    class MyModel < ActiveRecord::Base
      acts_as_stashable
    end

To stash stuff in a controller:
----

    @thing = Thing.create(params[:thing])
    @thing.stash(session)

Note that the object must be saved to the database first - we only store the id in the session as storing everything would be a bit silly.

To unstash
----

    @thing = Thing.find(1)
    @thing.unstash(session) if @thing.stashed?(session)

Note the +stashed?+ method that checks if the object is stashed currently.

To get all stashed objects
---

    Thing.stashed(session)

Note that this returns an Arel relation, so you can do stuff like

    Thing.stashed(session).includes(:relation)

To reparent everything
---

If you're doing lazy registration stuff, this is useful. You'll have a bunch of stuff stashed in the session, and when a user signs up, you'll want to make sure they're all made to relate to the new user.

    Thing.reparent_all(session, :field, value)        #Updated :field to value on all stashed Things, saves them and unstashes them
    Thing.reparent_all(session, :field, value, false) #Same as above but doesn't unstash the objects (not sure why you'd want this) 


To run the tests
---
    cd path/to/rails-3-acts-as-stashable
    rake spec

The tests use their own in memory database to run tests on a Post model.
