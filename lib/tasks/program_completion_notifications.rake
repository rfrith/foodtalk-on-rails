require "#{Rails.root}/app/controllers/concerns/county_extension_office_utils"
include CountyExtensionOfficeUtils

namespace :notify do
  namespace :county_extension_offices do
    desc "Send "
    task :program_complete, [:completion_date_range_start, :completion_date_range_end] => [:environment] do |task, args|

      #set default values
      args.with_defaults(completion_date_range_start: Date.new(Date.current.year).to_s, completion_date_range_end: Date.today.to_s)

      begin
        completion_start = Time.zone.parse(args.completion_date_range_start)
      rescue Exception
        puts "Invalid completion_date_range_start argument"
      end

      begin
        completion_end = Time.zone.parse(args.completion_date_range_end)
      rescue Exception
        puts "Invalid completion_date_range_end argument"
      end

      #begin task
      begin
        date_range = completion_start..completion_end

        zip_codes = ZipCode.all

        #TODO: REMOVE AFTER PILOT TESTING!!!
        zip_codes = ZipCode.where(zip: [30621, 30606])

        #TODO: put in limited zip code list for pilot testing email
        completions = get_curriculum_completion_in_date_range_by_zip_code(date_range, zip_codes)
        completions.each do |c|
          zip_code = ZipCode.find_by(zip: c.keys[0])
          users = c.values[0]
          ceos = zip_code.county_extension_offices
          ceos.each do |ceo|
            #send email to each CountyExtensionOffice
            CountyExtensionOfficeMailer.with(users: users, county_extension_office: ceo, zip_code: zip_code.zip, date_range: date_range).program_completions_email.deliver_now
          end
        end
      rescue Exception => e
        puts "An error occurred: #{e.inspect}"
      end
    end
  end
end
