class Announcement < ActiveRecord::Base
  include ActiveModel::Validations
  
  attr_accessible :content, :grade_6, :grade_7, :grade_8, :start_date, :end_date
  belongs_to :user
  
  validates :content, :user_id, :start_date, :end_date, :presence => true
  
  validate :valid_dates
  validate :must_have_grade
  
  def must_have_grade
    errors.add(:base, "Must have at least one grade") unless (grade_6 || grade_7 || grade_8)
  end
  
  def valid_dates
    if end_date.present? && start_date.present?
      errors.add(:base, "Must have start date before end date") unless end_date >= start_date
    end
  end
  
  default_scope :order => 'announcements.created_at DESC'
  
end
