class AnnouncementsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy
  
  def create
    @announcement = current_user.announcements.build(params[:announcement])
    if @announcement.save
      flash[:success] = "Announcement created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end
  
  def destroy
    @announcement.destroy
    redirect_back_or root_path
  end
  
  private
    def authorized_user
      @announcement = current_user.announcements.find_by_id(params[:id])
      redirect_to root_path if @announcement.nil?
    end
end
