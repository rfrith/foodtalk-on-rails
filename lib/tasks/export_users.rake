require 'csv'
require 'set'
require 'date'

namespace :export_users do

  namespace :demographic_data do

    desc "Exports user information into CSV"
    task :all, [:file_name, :signup_date_range_start, :signup_date_range_end, :user_email, :eligible, :domain_group] => [:environment] do |task, args|

      #TODO: implement remaining args

      #set default values
      args.with_defaults(file_name: 'export.csv', signup_date_range_start: Date.new(Date.current.year).to_s, signup_date_range_end: Date.today.to_s, user_email: nil, eligible: nil, domain_group: nil)

      #puts "======================================================"
      #puts "file_name: #{args.file_name}"
      #puts "signup_date_range_start: #{args.signup_date_range_start}"
      #puts "signup_date_range_end: #{args.signup_date_range_end}"
      #puts "eligible: #{args.eligible}"
      #puts "user_email: #{args.user_email}"
      #puts "======================================================"

      #convert string to boolean for == comparison below
      eligible = ActiveModel::Type::Boolean.new.cast(args.eligible)

      begin
        signup_start = Date.parse(args.signup_date_range_start)
      rescue Exception
        puts "Invalid signup_date_range_start argument"
      end
      begin
        signup_end = Date.parse(args.signup_date_range_end)
      rescue Exception
        puts "Invalid signup_date_end_start argument"
      end

      #build where clause
      #order of args [:file_name, :signup_date_range_start, :signup_date_range_end, :user_email, :eligible, :domain_group]
      where_string = ""
      where_params = {}


      if(!args.user_email.nil?)
        #users = User.where("email LIKE ?", "%#{args.user_email}%")
        where_string += "email LIKE %:email%"
        where_params.merge! email: args.user_email
      else
        #users = User.where("created_at >= ? AND created_at <= ?", signup_start, signup_end)
        where_string += "created_at >= :signup_start AND created_at <= :signup_end"
        where_params.merge! signup_start: signup_start, signup_end: signup_end
      end

      if(args.domain_group)
        puts "finding users in group: #{args.domain_group}"
        users = Group.find_by_name(args.domain_group).users.where(where_string, where_params)
      else
        puts "No domain_group specified"
        users = User.where(where_string, where_params)
      end

      CSV.open(args.file_name,"w") do |csv|

        column_names = ["signup_date", "uid", "is_eligible", "first_name", "last_name", "email", "gender", "age", "zip_code", "is_hispanic_or_latino"]

        RacialIdentity.all.each do |ri|
          column_names << ri.name.parameterize.underscore
        end

        FederalAssistance.all.each do |fa|
          column_names << fa.name.parameterize.underscore
        end

        LearningModules::BETTER_U.each do |m|
          column_names << m[:id].gsub("/", "_").gsub("#", "_") + "_started"
          column_names << m[:id].gsub("/", "_").gsub("#", "_") + "_completed"
        end

        LearningModules::FOOD_ETALK.each do |m|
          column_names << m[:id].gsub("/", "_").gsub("#", "_") + "_started"
          column_names << m[:id].gsub("/", "_").gsub("#", "_") + "_completed"
        end

        VideoSurveys::MAP_VIDEOS_TO_SURVEYS.each do |vs|
          column_names << vs[:survey_args][:origin].gsub("-", "_").gsub("/", "_").gsub("#", "_") + "_started"
          column_names << vs[:survey_args][:origin].gsub("-", "_").gsub("/", "_").gsub("#", "_") + "_completed"
        end

        csv << column_names

        users.each_with_index do |u,index|

          #skip users based on presence of eligible argument
          next if !eligible.nil? and u.is_eligible? != eligible

          values = [u.created_at, u.uid, u.is_eligible?, u.first_name, u.last_name, u.email, u.gender, u.age, u.zip_code, u.is_hispanic_or_latino]

          RacialIdentity.all.each do |ri|
            if u.racial_identities.exists?(ri.id)
              values << 1
            else
              values << 0
            end
          end

          FederalAssistance.all.each do |fa|
            if u.federal_assistances.exists?(fa.id)
              values << 1
            else
              values << 0
            end
          end

          LearningModules::BETTER_U.each do |m|
            if u.online_learning_histories.where("name LIKE ?", "%#{m[:id]}%#started").size > 0
              values << 1
            else
              values << 0
            end

            if u.online_learning_histories.where("name LIKE ?", "%#{m[:id]}%#completed").size > 0
              values << 1
            else
              values << 0
            end
          end

          LearningModules::FOOD_ETALK.each do |m|
            if u.online_learning_histories.where("name LIKE ?", "%#{m[:id]}%#started").size > 0
              values << 1
            else
              values << 0
            end

            if u.online_learning_histories.where("name LIKE ?", "%#{m[:id]}%#completed").size > 0
              values << 1
            else
              values << 0
            end
          end

          VideoSurveys::MAP_VIDEOS_TO_SURVEYS.each do |vs|
            if u.survey_histories.where("name LIKE ?", "%#{vs[:survey_args][:origin]}%#started").size > 0
              values << 1
            else
              values << 0
            end

            if u.online_learning_histories.where("name LIKE ?", "%#{vs[:survey_args][:origin]}%#completed").size > 0
              values << 1
            else
              values << 0
            end
          end

          csv << values

        end
      end

    end

  end

end