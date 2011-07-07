# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  grade      :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", :email => "example@westdenverprep.org", :grade =>7 }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "z" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should accept WDP email addresses" do
    addresses = %w[rprior@westdenverprep.org adMN232+s@westdenverprep.org a@westdenverprep.org]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
      end
  end
  
  it "should not accept non-WDP email addresses" do
    addresses = %w[dcarroll @westdenverprep.org foo@gmail.com westdenverprep.org@gmail.com 
                   foo_westdenverprep.org example@westdenverprep.or]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should_not be_valid
      end
  end
  
  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
end
