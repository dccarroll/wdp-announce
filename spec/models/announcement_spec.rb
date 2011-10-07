require 'spec_helper'

describe Announcement do
    before(:each) do
    @user = Factory(:user)
    @attr = {
      :content => "value for content",
      :grade_6 => true,
      :grade_7 => true,
      :grade_8 => true,
      :start_date => Date.current,
      :end_date   => Date.current
    }
  end

  it "should create a new instance given valid attributes" do
    @user.announcements.create!(@attr)
  end
  
  describe "user associations" do

    before(:each) do
      @announcement = @user.announcements.create(@attr)
    end

    it "should have a user attribute" do
      @announcement.should respond_to(:user)
    end

    it "should have the right associated user" do
      @announcement.user_id.should == @user.id
      @announcement.user.should == @user
    end
  end
  
  describe "validations" do

    it "should require a user id" do
      Announcement.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.announcements.build(@attr.merge(:content => "   ")).should_not be_valid
    end

    it "should have at least one grade" do
      no_grade = {:grade_6 => false, :grade_7 => false, :grade_8 => false}
      @user.announcements.build(@attr.merge(no_grade)).should_not be_valid
    end
    
    it "should have a starting date" do
      @user.announcements.build(@attr.merge(:start_date => nil)).should_not be_valid
    end
    
    it "should have an ending date" do
      @user.announcements.build(@attr.merge(:end_date => nil)).should_not be_valid
    end
    
    it "should not have an ending date in the past" do
      @user.announcements.build(@attr.merge(:end_date => Date.yesterday)).should_not be_valid
    end
    
  end
end
