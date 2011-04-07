module ActsAsStashable
  extend ActiveSupport::Concern

  module ClassMethods
    def stashed(session)
      where(:id => stashable_session_store(session))
    end

    def reparent_all(session, field, value, unstash=false)
      stashed(session).each do |obj|
        obj.send(:"#{field}=", value)
        obj.save!
        if unstash
          obj.unstash(session)
        end
      end
    end

    def stashable_session_store(session)
      (session[:acts_as_stashable] ||= {})[self.name.to_sym] ||= []
    end
  end

  module InstanceMethods
    def stash(session)
      self.class.stashable_session_store(session) << self.id
    end

    def unstash(session)
      if !stashed?(session)
        raise "Not stashed"
      else
        self.class.stashable_session_store(session).delete(self.id)
      end
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
