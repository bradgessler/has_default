# HasDefault

Specify a "default" instance that is to be returned for an ActiveRecord model when Model.default is called.

# Installation

Install the has_default gem

    gem install has_default --source http://gemcutter.org
    
Then configure in rails

    config.gem 'has_default',
      :lib => 'has_default',
      :source => 'http://gemcutter.org'

For whatever model you need to set a default for, run the a similar migration

    class AddDefaultsToModels < ActiveRecord::Migration
      def self.up
        change_table :plans do |t|
          t.boolean :default
        end
        add_index :plans, :default, :unique => true
      end

      def self.down
        remove_index :plans, :default
        change_table :plans do |t|
          t.remove :default
        end
      end
    end
    
# Example

Let's pretend our paid web application includes the models Plan and Account. When somebody creates an account, we want to make sure that at the very least it has a "Free Plan" associated with it.

    class Plan
      has_many :accounts
      has_default
    end

    class Account
      belongs_to :plan
  
      before_validate :set_default_plan, :unless => Proc.new{|a| a.plan.present? }
  
    protected
      def set_default_plan
        self.plan = Plan.default
      end
    end

Maybe in our seed.rb file in Rails or when we startup our application for the first time, we specify the plans that we're going to sell.

    Plan.create(:name => 'Free', :default => true)
    Plan.create(:name => 'Medium')
    Plan.create(:name => 'High')

Finally. somewhere in our application (maybe in AccountsController#new) we need to call Account#new and grab the plan.

    Account.new.plan.name # => 'Free'

Down the road when we want to change the default plan that's assigned to an account, we just set default to true and has_default takes care of the rest.

    Plan.find_by_name('High').update_attribute(:default, true)
    Account.new.plan.name # => 'High'

# License

Copyright (c) 2009 Brad Gessler, released under the MIT license

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.