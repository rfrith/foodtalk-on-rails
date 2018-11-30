require 'csv'
require 'set'
require 'date'

require "#{Rails.root}/app/controllers/concerns/reports"

include Reports

namespace :mailchimp_utils do

  namespace :reports do

    desc "Reports how many of the users manually added to mailchimp resulted in foodtalk.org account creations"
    task :count_resultant_website_registrations, [:file_name, :signup_date_range_start, :signup_date_range_end, :user_email] => [:environment] do |task, args|

      #set default values
      args.with_defaults(file_name: 'mailchimp_export.csv', signup_date_range_start: Date.new(Date.current.year).to_s, signup_date_range_end: Date.today.to_s)

      #puts "======================================================"
      #puts "file_name: #{args.file_name}"
      #puts "signup_date_range_start: #{args.signup_date_range_start}"
      #puts "signup_date_range_end: #{args.signup_date_range_end}"
      #puts "======================================================"

      begin
        signup_start = Time.zone.parse(args.signup_date_range_start)
      rescue Exception
        puts "Invalid signup_date_range_start argument"
      end

      begin
        signup_end = Time.zone.parse(args.signup_date_range_end)
      rescue Exception
        puts "Invalid signup_date_end_start argument"
      end

      user_list = []

      #read csv
      parsed_csv = CSV.foreach(args.file_name, headers: true) do |row|
        user_list << {email: row['Email Address'], opt_in: Date.strptime(row['OPTIN_TIME'], "%m/%d/%Y %H:%M")}
      end

      parsed_emails = user_list.map {|x| x.values[0]}

      #build where clause
      #order of args [:file_name, :signup_date_range_start, :signup_date_range_end]
      where_string = ""
      where_params = {}

      where_string += "email IN (:emails)"
      where_params.merge! emails: parsed_emails

      users = User.where(where_string, where_params)

      mailchimp_to_foodtalk = 0
      foodtalk_to_mailchimp = 0

      users.each do |user|
        mailchimp_user = user_list.find {|u| u[:email] == user.email }
        if(mailchimp_user) #skip user unless they match

          opt_in = Date.strptime(mailchimp_user[:opt_in].strftime("%m/%d/%Y %H:%M"), "%m/%d/%Y %H:%M") + 8.hours #make up for server time differences
          created_at = Date.strptime(user.created_at.strftime("%m/%d/%Y %H:%M"), "%m/%d/%Y %H:%M")

          puts "opt-in:.......#{opt_in}"
          puts "created_at:...#{created_at}"

          if(created_at <= opt_in)

            foodtalk_to_mailchimp += 1
            puts "equal - foodtalk_to_mailchimp"

          elsif(opt_in < created_at)

            mailchimp_to_foodtalk += 1
            puts "mailchimp_to_foodtalk"

          end
        end
        puts "---------------------------"
        puts ""
        puts ""
        puts ""
      end

      puts "Number of matching accounts in Mailchimp and Foodtalk.org:  #{users.size}"
      puts "Number of Foodtalk.org accounts originating from Mailchimp: #{mailchimp_to_foodtalk}"
      puts "Number of Mailchimp accounts originating from Foodtalk.org: #{foodtalk_to_mailchimp}"

    end

  end

end