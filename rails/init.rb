require File.dirname(__FILE__) + '/../lib/has_default'

ActiveRecord::Base.send :include, HasDefault::ActiveRecord