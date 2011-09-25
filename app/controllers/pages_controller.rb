class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in?
      @announcement = Announcement.new       
      @announcement.grade_6 = true
      @announcement.grade_7 = true
      @announcement.grade_8 = true
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end
  
end
