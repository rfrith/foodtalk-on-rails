require 'rake'

namespace :notify do
  namespace :county_extension_offices do
    desc "Send "
    task :program_complete, [:completion_date_range_start, :completion_date_range_end] => [:environment] do |task, args|

      start_time = Time.now

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

        puts
        puts
        puts "○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○••○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○"
        puts "Executing task: notify:county_extension_offices:program_complete[#{args.completion_date_range_start}, #{args.completion_date_range_end}] (dd/mm/yyyy)"

        puts "Task started: #{start_time} (yyyy/mm/dd)"

        date_range = completion_start..completion_end

        env_zips = Rails.application.secrets.ext_office_notify_zip_codes

        if(env_zips)
          zip_codes = ZipCode.where(zip: env_zips.split(' ')) #using white spaces; Rails.application.secrets doesn't like commas for some odd reason
          puts "Using zip codes from ENV: #{zip_codes.map{|z| z[:zip]}.join(' ')}"
        else
          zip_codes = ZipCode.all
        end

        completions = get_curriculum_completion_in_date_range_by_zip_code(date_range, zip_codes)

        if(!completions.empty?)

          puts "Processing completions for date range: #{date_range}"
          puts "...in #{completions.size} zip codes: #{completions.map{|c|c.keys[0]}.join(', ')}"

          completions.each do |c|
            zip_code = ZipCode.find_by(zip: c.keys[0])
            users = c.values[0]
            ceos = zip_code.county_extension_offices

            puts "Processing zip code: #{zip_code.zip}".indent(2)
            puts "#{users.size} Participants completed program: #{ users.map{|u| [u[:first_name], u[:last_name].first+'.'].join(' ')}.join(', ') }".indent(4)

            ceos.each do |ceo|
              begin
                if(ceo.active)
                  if (!ceo.email.blank?)
                    puts "Sending email to #{ceo.name} (#{ceo.email})".indent(6)
                    CountyExtensionOfficeMailer.with(users: users, county_extension_office: ceo, zip_code: zip_code.zip, date_range: date_range).program_completions_email.deliver_now
                  else
                    puts "Missing email address for #{ceo.name} Extension Office. Skipping.".indent(6)
                  end
                else
                  puts "#{ceo.name} Extension Office not 'active' in DB. Skipping.".indent(6)
                end
              rescue Exception
                puts "Error sending email to #{ceo.name} (#{ceo.email})".indent(6)
              end
            end

          end
        else
          puts "No completions in this date range."
        end

        puts "Task Complete."
        puts "○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○••○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○•○"
        puts
        puts

      rescue Exception => e
        puts "An error occurred: #{e.inspect}"
      end
    end
  end
end
