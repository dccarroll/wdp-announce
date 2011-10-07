namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Example User",
                         :email => "example@westdenverprep.org",
                         :password => "foobar",
                         :password_confirmation => "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@westdenverprep.org"
      password  = "password"
      grade = [0,6,7,8].sample
      User.create!(:name => name,
                   :email => email,
                   :grade => grade,
                   :password => password,
                   :password_confirmation => password)
    end
    50.times do
      User.all(:limit => 6).each do |user|
        user.announcements.create!(:content => Faker::Lorem.sentence(5),
                                  :grade_6 => true,
                                  :grade_7 => true,
                                  :grade_8 => true,
                                  :start_date => Date.current,
                                  :end_date => Date.current)
      end
    end
  end
end
