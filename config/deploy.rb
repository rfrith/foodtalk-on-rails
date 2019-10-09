# config valid for current version and patch releases of Capistrano
lock "~> 3.11"

set :application, ENV['APPLICATION']
set :repo_url, ENV['REPO_URL']
set :rvm_roles, [:app, :web]

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

set :deploy_to, ENV['DEPLOY_TO']
set :rvm_ruby_version, ENV['RVM_RUBY_VERSION']


set :maintenance_template_path, File.expand_path("../../app/views/errors/maintenance.html.erb", __FILE__)

set :loaderio_auth_files, ENV['LOADERIO_AUTH_FILES']


# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
#set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

# Add bundler support
append :linked_dirs, '.bundle'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure


namespace :deploy do
  desc "Copy Loader.io auth files"
  task :copy_loader_auth_files do
    on roles(:web) do
      fetch(:loaderio_auth_files, "").to_s.split(",").each do |f|
        execute "cp #{f} #{fetch(:deploy_to, "")}/current/public"
      end
    end
  end
end

namespace :cache do
  task :clear do
    on roles(:app) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, "rake cache:clear"
        end
      end
    end
  end
end

namespace :memcached do

  desc "Flushes memcached local instance"
  task :flush do
    on roles(:app) do
      execute "cd #{fetch(:deploy_to, '')}/current/public && rake memcached:flush"
      #execute :bundle, :exec, "rake memcached:flush"
    end
  end

  desc "Restart the Memcache daemon"
  task :restart do
    on roles(:app) do
      deploy.memcached.stop
      deploy.memcached.start
    end
  end

  desc "Start the Memcache daemon"
  task :start do
    on roles(:app) do
      invoke_command "memcached -P #{current_path}/log/memcached.pid  -d", :via => run_method
    end
  end

  desc "Stop the Memcache daemon"
  task :stop do
    on roles(:app) do
      pid_file = "#{current_path}/log/memcached.pid"
      invoke_command("killall -9 memcached", :via => run_method) if File.exist?(pid_file)
    end
  end
end


after :deploy, "deploy:copy_loader_auth_files"
#after 'deploy:update', 'cache:clear'
after 'deploy', 'memcached:flush'

#NECESSARY FOR JRUBY - https://github.com/jruby/jruby/issues/4191
#Net::SSH::Transport::Algorithms::ALGORITHMS.values.each { |algs| algs.reject! { |a| a =~ /^ecd(sa|h)-sha2/ } }
#Net::SSH::KnownHosts::SUPPORTED_TYPE.reject! { |t| t =~ /^ecd(sa|h)-sha2/ }