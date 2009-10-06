module HasDefault
  module ActiveRecord
    def self.included(base)
      base.send :extend, ActMacro
    end
    
    module ActMacro
      def has_default(opts={})
        write_inheritable_attribute :default_column, opts[:column] || 'default'

        class_inheritable_reader :default_column
        
        self.send :extend, ClassMethods
        self.send :include, HasDefault::ActiveRecord::Callbacks
        self.send :include, HasDefault::ActiveRecord::InstanceMethods
        
        after_save :clear_default_scope
      end
    end
    
    module ClassMethods
      def default
        first(:conditions => [ "`#{default_column}` = ?", true ]) || first
      end
    end
    
    module Callbacks
    private
      # Clears default on everything except for the model being saved if its set to be the new default
      def clear_default_scope
        if self.send(self.class.default_column)
          self.class.update_all([ "`#{self.class.default_column}` = ?", nil ], [ "#{self.class.primary_key} <> ? ", self.send(self.class.primary_key)])
        end
      end
    end
    
    module InstanceMethods
    end
  end
end