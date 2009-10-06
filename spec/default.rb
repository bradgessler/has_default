require 'rubygems'
require 'spec'

gem 'activerecord', '>= 1.15.4.7794'
require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

require "#{File.dirname(__FILE__)}/../init"

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :drinks do |t|
      t.column :name, :string
      t.column :default, :boolean
      t.column :created_at, :datetime      
      t.column :updated_at, :datetime
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Drink < ActiveRecord::Base
  has_default
end

describe "has_default" do
  before(:each) do
    setup_db
    Drink.create([
      {:name => 'Small'},
      {:name => 'Medium'},
      {:name => 'Large'}
    ])
  end
  
  after(:each) do
    teardown_db
  end
  
  it "should have default" do
    Drink.should respond_to(:default)
  end
  
  it "should give first record if no default" do
    Drink.default.should eql(Drink.first)
  end
  
  it "should set default" do
    Drink.last.update_attribute(:default, true)
    Drink.last.should be_default
  end
  
  it "should only allow one default" do
    Drink.last.update_attribute(:default, true)
    Drink.first.update_attribute(:default, true)    
    Drink.all(:conditions => {:default => true}).should have(1).item
    Drink.first.should be_default
  end
end