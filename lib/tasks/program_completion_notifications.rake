require 'rake'

namespace :notify do
  namespace :county_extension_offices do
    desc "Send "
    task :program_complete, [:completion_date_range_start, :completion_date_range_end] => [:environment] do |task, args|

      #include after environment is loaded
      include CountyExtensionOfficeUtils

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

        puts "Processing completions for date range: #{date_range}"

        env_zips = Rails.application.secrets.ext_office_notify_zip_codes

        if(env_zips)
          puts "Using env_zips: #{env_zips}"
          zip_codes = ZipCode.where(zip: env_zips.split(' ')) #using white spaces; Rails.application.secrets doesn't like commas for some odd reason
        else
          zip_codes = ZipCode.all
        end

        completions = get_curriculum_completion_in_date_range_by_zip_code(date_range, zip_codes)

        puts "Processing #{completions.size} completion(s)."

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
