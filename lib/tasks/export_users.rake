require 'csv'
require 'set'
require 'date'

require "#{Rails.root}/app/controllers/concerns/reports"

include Reports

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
        signup_start = Time.zone.parse(args.signup_date_range_start)
      rescue Exception
        puts "Invalid signup_date_range_start argument"
      end
      begin
        signup_end = Time.zone.parse(args.signup_date_range_end)
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

      csv_string = generate_report_as_csv(users, eligible)

      File.write(args.file_name, csv_string)

    end

  end

end