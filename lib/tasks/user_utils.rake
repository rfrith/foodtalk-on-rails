namespace :user_utils do
  namespace :eligibility do
    desc "Sets user.eligible in database based on eligibility algorithm"
    task :set_eligible_flag, [] => [:environment] do |task, args|
      all_users = User.all
      eligible_users = []
      ineligible_users = []

      puts "User.all.size: #{all_users.size}"

      all_users.each do |user|
        puts "user: : #{user.name} #{user.email}"
        user.seed_eligible!
        puts "user.eligible: #{user.eligible}"
        puts "user.is_eligible?: #{user.is_eligible?}"
        user.is_eligible? ? eligible_users << user : ineligible_users << user
        puts "============================================"
      end

      puts "User.all_eligible.size: #{eligible_users.size}"
      puts "User.all_ineligible.size: #{ineligible_users.size}"

    end
  end

  namespace :test_data do

    require 'faker'

    desc "Replaces User data with faker entries"
    task :fakerize_user_data, [] => [:environment] do |task, args|

      puts "ENV[RAILS_ENV]: " + ENV["RAILS_ENV"]
      puts "ENV[DB_HOST]: " + ENV["DB_HOST"]

      #don't allow on prod db!
      exit if ENV["RAILS_ENV"] == "production" or ENV["DB_HOST"] == "frost.fcs.uga.edu"

      all_users = User.all
      puts "User.all.size: #{all_users.size}"

      all_users.each do |user|
        puts "(old) user: : #{user.name} #{user.email}"
        user.first_name = Faker::Name.first_name
        user.last_name = Faker::Name.last_name
        user.email = Faker::Internet.email
        user.save!
        puts "(new) user: : #{user.name} #{user.email}"
      end

    end
  end

end
