require 'spec_helper'
class Post < ActiveRecord::Base
  acts_as_stashable
end

describe Post do
  let(:post) { Post.create }
  let(:post2) { Post.create }
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
    [post, post2].map { |p| p.stash(session) }

    Post.reparent_all(session, :title, '--REPARENTED--')

    [post, post2].map do |p|
      p.should_not be_stashed(session)
      p.reload.title.should == '--REPARENTED--'
    end
  end

  it "allows reparenting of all objects without unstashing" do
    [post, post2].map { |p| p.stash(session) }

    Post.reparent_all(session, :title, '--REPARENTED--', false)

    [post, post2].map do |p|
      p.should be_stashed(session)
      p.reload.title.should == '--REPARENTED--'
    end
  end

  it "allows reparenting using a block" do
    [post, post2].map { |p| p.stash(session) }

    Post.reparent_all(session) do |post|
      post.title = "--BLOCK-REPARENTED--"
    end

    [post, post2].map do |p|
      p.should_not be_stashed(session)
      p.reload.title.should == '--BLOCK-REPARENTED--'
    end
  end
end
