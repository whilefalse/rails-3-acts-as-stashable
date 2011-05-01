module ActsAsStashable
  extend ActiveSupport::Concern

  module ClassMethods
    def stashed(session)
      where(:id => stashable_session_store(session))
    end

    def reparent_all(session, field=nil, value=nil, unstash=true)
      stashed(session).each do |obj|
        if block_given?
          yield obj
        else
          obj.send(:"#{field}=", value)
        end
        obj.save!
        obj.unstash(session) if unstash
      end
    end

    def stashable_session_store(session)
      (session[:acts_as_stashable] ||= {})[name.to_sym] ||= []
    end
  end

  module InstanceMethods
    def stash(session)
      self.class.stashable_session_store(session) << self.id
    end

    def unstash(session)
      raise "Not stashed" if !stashed?(session)
      self.class.stashable_session_store(session).delete(id)
    end

    def stashed?(session)
      self.class.stashable_session_store(session).include? id
    end
  end
end

class ActiveRecord::Base
  def self.acts_as_stashable
    include ActsAsStashable
  end
end
