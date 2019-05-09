namespace :cache do
  desc 'clear rails cache'
  task clear: :environment do
    STDERR.puts "Clearing Rails cache..."
    Rails.cache.clear
    STDERR.puts "Finished."
  end
end