namespace :user_utils do
  namespace :eligibility do
    desc "Sets user.eligible in database based on eligibility algorithm"
    task :all, [] => [:environment] do |task, args|
      all_users = User.all
      eligible_users = User.all_eligible
      ineligible_users = User.all_ineligible
      puts "User.all.size: #{all_users.size}"
      puts "User.all_eligible.size: #{eligible_users.size}"
      puts "User.all_ineligible.size: #{ineligible_users.size}"

      eligible_users.each { |user|
        puts "user: : #{user.name} #{user.email}"
        user.eligible ||= user.is_eligible?
        user.save!
        puts "user.eligible: #{user.eligible}"
      }

      ineligible_users.each { |user|
        puts "user: : #{user.name} #{user.email}"
        user.eligible ||= user.is_eligible?
        user.save!
        puts "user.eligible: #{user.eligible}"
      }


    end
  end
end
