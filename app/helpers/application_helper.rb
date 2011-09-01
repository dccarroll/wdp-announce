module ApplicationHelper
  
  def logo
      image_tag("logo.png", :alt => "WDP Announce", :class => "round")
  end
     
  def title
    base_title = "WDP Announce"
    if @title.nil?
      base_title
    else 
      "#{base_title} | #{@title}"
    end
  end
end 

