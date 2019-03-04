require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.
  
  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    Customer.where("first = 'Candice'")
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    Customer.where("email LIKE :query", :query => '%@%')
  end

  def self.with_dot_org_email
    Customer.where("email LIKE :query", :query => '%.org')
  end

  def self.with_invalid_email
    Customer.where("email NOT LIKE :query", :query => '%@%')
  end

  def self.with_blank_email
    Customer.where("email IS :query", :query => nil)
  end

  def self.born_before_1980
    Customer.where("birthdate < :query", :query => Date.new(1980,1,1))
  end
  
  def self.with_valid_email_and_born_before_1980
    Customer.where("birthdate < :bd AND email LIKE :email", :bd => Date.new(1980,1,1), :email => '%@%')
  end

  def self.twenty_youngest
    Customer.order('birthdate DESC').limit(20)
  end

  def self.last_names_starting_with_b
    Customer.where("last LIKE :query", :query => 'b%').order('birthdate')
  end

  def self.update_gussie_murray_birthdate
    gussie = Customer.find_by(:first => 'Gussie')
    gussie.update_attributes(:birthdate => Date.new(2004,2,8))
    gussie.save!
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where("email NOT LIKE '%@%'").update_all(email: nil)
  end

  def self.delete_meggie_herman
    meggie = Customer.find_by(:first => 'Meggie', :last => 'Herman')
    meggie.destroy
  end

  def self.delete_everyone_born_before_1978
    Customer.destroy_all("birthdate < '1977-12-31'")
  end

end
