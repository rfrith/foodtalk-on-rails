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

after :deploy, "deploy:copy_loader_auth_files"

#NECESSARY FOR JRUBY - https://github.com/jruby/jruby/issues/4191
#Net::SSH::Transport::Algorithms::ALGORITHMS.values.each { |algs| algs.reject! { |a| a =~ /^ecd(sa|h)-sha2/ } }
#Net::SSH::KnownHosts::SUPPORTED_TYPE.reject! { |t| t =~ /^ecd(sa|h)-sha2/ }