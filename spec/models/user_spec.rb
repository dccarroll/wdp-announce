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
    @attr = { :name => "Example User", 
              :email => "example@westdenverprep.org", 
              :grade => 7,
              :password => "foobarbaz",
              :password_confirmation => "foobarbaz" }
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
  
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password =>"", :password_confirmation =>""))
      should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation =>"foobarbizz"))
      should_not be_valid
    end
    
    it "should reject short passwords" do
      tooshort = "12345"
      User.new(@attr.merge(:password => tooshort, :password_confirmation => tooshort))
      should_not be_valid
    end
    
    it "should reject long passwords" do
      toolong = "a"*41
      User.new(@attr.merge(:password => toolong, :password_confirmation => toolong ))
      should_not be_valid  
    end
  end
  
  describe "password encryption" do
    before(:each) do 
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
  
    describe "has_password? method" do
    
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end
           
    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end
  
  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  
  describe "announcement associations" do

    before(:each) do
      @user = User.create(@attr)
      @an1 = Factory(:announcement, :user => @user, :created_at => 1.day.ago)
      @an2 = Factory(:announcement, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have an announcment attribute" do
      @user.should respond_to(:announcements)
    end

    it "should have the right announcements in the right order" do
      @user.announcements.should == [@an2, @an1]
    end
    
    it "should destroy associated announcements" do
      @user.destroy
      [@an1, @an2].each do |announcement|
        Announcement.find_by_id(announcement.id).should be_nil
      end
    end
  end
end
