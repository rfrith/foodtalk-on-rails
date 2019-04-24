namespace :carrier_wave do
  desc 'Cleans cached files created by CarrierWave gem'
  task clean_cached_files: :environment do
    STDERR.puts "Cleaning cached files..."
    CarrierWave.clean_cached_files! 1
    STDERR.puts "Finished."
  end
end

