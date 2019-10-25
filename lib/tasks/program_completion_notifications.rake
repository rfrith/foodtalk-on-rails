require "#{Rails.root}/app/controllers/concerns/county_extension_office_utils"
include CountyExtensionOfficeUtils

namespace :notify do
  namespace :county_extension_offices do
    desc "Send "
    task :program_complete, [:completion_date_range_start, :completion_date_range_end] => [:environment] do |task, args|

      #set default values
      args.with_defaults(completion_date_range_start: Date.new(Date.current.year).to_s, completion_date_range_end: Date.today.to_s)

      #puts "completion_date_range_start: #{args.completion_date_range_start}"
      #puts "completion_date_range_end: #{args.completion_date_range_end}"

      begin
        completion_start = Time.zone.parse(args.completion_date_range_start)
      rescue Exception
        puts "Invalid completion_date_range_start argument"
      end

      #puts "parsed completion_start: #{completion_start}"

      begin
        completion_end = Time.zone.parse(args.completion_date_range_end)
      rescue Exception
        puts "Invalid completion_date_range_end argument"
      end

      #puts "parsed completion_end: #{completion_end}"

#begin task

      #puts "User.all.size: #{User.all.size}"
      #puts "User.all w/ match in zipcodes.zip size: #{User.where(zip_code: ZipCode.all.map{|z| z[:zip]}).size}"
      #puts "User.all w/ no match in zipcodes.zip size: #{User.where.not(zip_code: ZipCode.all.map{|z| z[:zip]}).size}"

      #User.where.not(zip_code: ZipCode.all.map{|z| z[:zip]}).each do |u|
        #puts "u.uid: #{u.uid}"
        #puts "u.email: #{u.email}"
        #puts "u.name: #{u.name}"
        #puts "u.zip_code: #{u.zip_code}"
        #puts "\n---------------------------------------\n"
        #puts u.zip_code
      #end

      date_range = completion_start..completion_end

      completions = get_curriculum_completion_in_date_range_by_zip_code(date_range)

      completions.each do |c|
        zip_code = ZipCode.find_by(zip: c.keys[0])
        ceos = zip_code.county_extension_offices

        ceos.each do |ceo|
          #send email to each CountyExtensionOffice
          CountyExtensionOfficeMailer.with(completions: c, county_extension_office: ceo, zip_code: zip_code.zip, date_range: date_range).program_completions_email.deliver_now
          break
        end
        break
      end
    end
  end
end
