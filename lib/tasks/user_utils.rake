namespace :user_utils do
  namespace :eligibility do
    desc "Sets user.eligible in database based on eligibility algorithm"
    task :all, [] => [:environment] do |task, args|
      all_users = User.all
      eligible_users = []
      ineligible_users = []

      puts "User.all.size: #{all_users.size}"

      all_users.each do |user|
        puts "user: : #{user.name} #{user.email}"
        user.seed_eligibile!
        puts "user.eligible: #{user.eligible}"
        puts "user.is_eligible?: #{user.is_eligible?}"
        user.is_eligible? ? eligible_users << user : ineligible_users << user
        puts "============================================"
      end

      puts "User.all_eligible.size: #{eligible_users.size}"
      puts "User.all_ineligible.size: #{ineligible_users.size}"

    end
  end
end
