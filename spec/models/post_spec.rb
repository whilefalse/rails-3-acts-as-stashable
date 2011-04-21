require 'spec_helper'
require File.dirname(__FILE__) + '/../../lib/acts_as_stashable'
class Post < ActiveRecord::Base
  acts_as_stashable
end

describe Post do
  let(:post) { Post.new.tap { |p| p.save } }
  let(:post2) { Post.new.tap { |p| p.save } }
  let(:session) { {} }

  it "allows stashing in the session" do
    post.stash(session)
    post.should be_stashed(session)
  end

  it "correctly says that a post is not stashed" do
    post2.should_not be_stashed(session)
  end

  it "allows unstashing of a post" do
    post.should_not be_stashed(session)
    post.stash(session)
    post.should be_stashed(session)

    post.unstash(session)
    post.should_not be_stashed(session)
  end

  it "allows reparenting of all objects" do
    post.stash(session)
    post2.stash(session)

    Post.reparent_all(session, :title, '--REPARENTED--')

    post.should_not be_stashed(session)
    post2.should_not be_stashed(session)

    post.reload.title.should == '--REPARENTED--'
    post2.reload.title.should == '--REPARENTED--'
  end

  it "allows reparenting of all objects without unstashing" do
    post.stash(session)
    post2.stash(session)

    Post.reparent_all(session, :title, '--REPARENTED--', false)

    post.should be_stashed(session)
    post2.should be_stashed(session)

    post.reload.title.should == '--REPARENTED--'
    post2.reload.title.should == '--REPARENTED--'
  end
end
