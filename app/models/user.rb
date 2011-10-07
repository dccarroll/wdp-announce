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

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :grade, :password, :password_confirmation
  
  has_many :announcements, :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@westdenverprep+\.org+\z/i
  
  validates :name,  :presence   => true,
                    :length     => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex},
                    :uniqueness => { :case_sensitive => false }
                    
  validates :grade, :presence   => true
                    
  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
                       
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
    
  def feed
    case grade
    when 6
      grade_6
    when 7
      grade_7
    when 8
      grade_8
    else
      grade_all
    end 
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    user && user.has_password?(submitted_password) ? user : nil
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  private 
    
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
    def grade_6
      Announcement.where("grade_6 = ? AND start_date >= ? AND end_date <= ?", 
                         TRUE, Date.current, Date.current)
    end 
    
    def grade_7
      Announcement.where("grade_7 = ? AND start_date >= ? AND end_date <= ?", 
                         TRUE, Date.current, Date.current)
    end
    
    def grade_8
      Announcement.where("grade_8 = ? AND start_date >= ? AND end_date <= ?", 
                        TRUE, Date.current, Date.current)
    end
    
    def grade_all
      Announcement.where("start_date >= ? AND end_date <= ?", 
                        Date.current, Date.current)    
    end
end
