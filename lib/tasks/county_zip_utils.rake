require 'csv'


namespace :county_zip_utils do

  namespace :import do

    default_dir = "#{Dir.home}/zip"

    desc "Clear out all old data and import all data"
    task :all, [:dir_name, :headers] => [:environment, :zip_codes, :county_extension_offices, :county_extension_offices_zip_codes] do |task, args|
      args.with_defaults(dir_name: default_dir, headers: true)
      puts "All tasks complete."
    end

    desc "Imports zip codes list from CSV file"
    task :zip_codes, [:file_name, :headers] => [:environment] do |task, args|

      puts "Invoking task :zip_codes"

      #set default values
      args.with_defaults(file_name: "#{default_dir}/zip_codes.csv", headers: true)

      puts "Processing: #{args.file_name}"
      puts "w/ headers: #{args.headers}"

      headers = ActiveModel::Type::Boolean.new.cast(args.headers)

      #delete existing
      puts "Deleting all records..."
      ZipCode.delete_all

      puts "Creating new records..."
      CSV.foreach(args.file_name, headers: headers) do |row|
        zip = ZipCode.create(id: row["id"], zip: row["zip"], eligible: ActiveModel::Type::Boolean.new.cast(row["eligible"]))
      end

      puts "Completed."
      puts "======================================================"
    end

    desc "Imports county_extension_offices list from CSV file"
    task :county_extension_offices, [:file_name, :headers] => [:environment] do |task, args|

      puts "Invoking task :county_extension_offices"

      #set default values
      args.with_defaults(file_name: "#{default_dir}/county_extension_offices.csv", headers: true)

      puts "Processing: #{args.file_name}"
      puts "w/ headers: #{args.headers}"

      headers = ActiveModel::Type::Boolean.new.cast(args.headers)

      #delete existing
      puts "Deleting all records..."
      CountyExtensionOffice.delete_all

      puts "Creating new records..."
      CSV.foreach(args.file_name, headers: headers) do |row|
        county_ext_office = CountyExtensionOffice.create(id: row["id"], name: row["name"], address1: row["address1"], address2: row["address2"], city: row["city"], state: row["state"], zip: row["zip"], phone: row["phone"], email: row["email"])
      end

      puts "Completed."
      puts "======================================================"

    end

    desc "Imports county_extension_offices_zip_codes mappings list from CSV file"
    task :county_extension_offices_zip_codes, [:file_name, :headers] => [:environment] do |task, args|

      puts "Invoking task :county_extension_offices_zip_codes"

      #set default values
      args.with_defaults(file_name: "#{default_dir}/county_extension_offices_zip_codes.csv", headers: true)

      puts "Processing: #{args.file_name}"
      puts "w/ headers: #{args.headers}"

      headers = ActiveModel::Type::Boolean.new.cast(args.headers)

      #delete existing
      puts "Deleting all records..."
      sql = "DELETE FROM county_extension_offices_zip_codes;"
      ActiveRecord::Base.connection.execute(sql)

      puts "Creating new records..."
      CSV.foreach(args.file_name, headers: headers) do |row|
        county_ext_office = CountyExtensionOffice.find(row["county_extension_office_id"])
        zip = ZipCode.find(row["zip_code_id"])
        county_ext_office.zip_codes << zip
      end

      puts "Completed."
      puts "======================================================"

    end

  end

end