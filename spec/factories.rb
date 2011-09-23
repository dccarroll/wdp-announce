# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Daniel Carroll"
  user.email                 "dcarroll@westdenverprep.org"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@westdenverprep.org"
end

Factory.define :announcement do |announcement|
  announcement.content "Party tonight!"
  announcement.grade_6 true
  announcement.grade_7 true
  announcement.grade_8 true
  announcement.start_date Date.today
  announcement.end_date Date.today
  announcement.association :user
end
