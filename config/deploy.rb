require 'rvm/capistrano'
require 'bundler/capistrano'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :rvm_ruby_string, "ruby-1.9.3@vec.io"

set :application, "vec.io"

set :scm, :git
set :git_enable_submodules, 1
set :repository, "https://github.com/vecio/vec.io.git"
set :branch, "master"

set :user, 'webapp'
set :group, 'webapp'
set :use_sudo, false
set :deploy_to, "/home/webapp/apps/#{application}"
set :deploy_via, :remote_cache

role :web, application
role :app, application
role :db,  application, :primary => true

set :unicorn_pid, "/tmp/unicorn.#{application}.pid"
set :unicorn_conf, "#{current_path}/config/unicorn.rb"

# Setup Shared Folders
#   that should be created inside the shared_path
set :shared_dirs, %w[uploads]

# Setup Symlinks
#   that should be created after each deployment
set :symlinks, [
  %w[uploads public/uploads]
]

# Application Specific Tasks
#   that should be performed at the end of each deployment
def application_specific_tasks
  system 'cap deploy:sitemap:refresh'
  system 'cap deploy:whenever:update'
end

# Check if remote file exists
#
def remote_file_exists?(full_path)
  'true' == capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

# Check if process is running
#
def remote_process_exists?(pid_file)
  capture("ps -p $(cat #{pid_file}) ; true").strip.split("\n").size == 2
end

namespace :deploy do

  namespace :db do
    desc "Populates the Production Database"
    task :seed, :roles => :db do
      puts "\n\n=== Populating the Production Database! ===\n\n"
      run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=production"
    end

    desc "Remove and create mongoid indexes"
    task :index, :roles => :db do
      run "cd #{current_path}; RAILS_ENV=production bundle exec rake db:mongoid:remove_indexes; RAILS_ENV=production bundle exec rake db:mongoid:create_indexes"
    end
  end

  namespace :sitemap do
    desc "Refresh the sitemap and resubmit"
    task :refresh, :roles => :app do
      run "cd #{current_path}; RAILS_ENV=production bundle exec rake sitemap:refresh"
    end
  end

  namespace :whenever do
    desc "Update the whenever crontab"
    task :update, :roles => :app do
      run "cd #{current_path}; RAILS_ENV=production bundle exec whenever --update-crontab"
    end
  end

  desc "Initializes a bunch of tasks in order after the last deployment process."
  task :restart do
    puts "\n\n=== Running Custom Processes! ===\n\n"
    create_production_log
    setup_symlinks
    application_specific_tasks
    set_permissions
    if remote_file_exists?(unicorn_pid) && remote_process_exists?(unicorn_pid)
      puts "\n\n=== Restarting Unicorn! ===\n\n"
      run "kill -s USR2 `cat #{unicorn_pid}`"
    else
      puts "\n\n=== Starting Unicorn! ===\n\n"
      run "rm #{unicorn_pid}" if remote_file_exists?(unicorn_pid)
      run "cd #{current_path} && bundle exec unicorn -c #{unicorn_conf} -E production -D"
    end
  end

  desc "Sets permissions for Rails Application"
  task :set_permissions do
    puts "\n\n=== Setting Permissions! ===\n\n"
    run "chown -R #{user}:#{group} #{deploy_to}"
  end

  desc "Creates the production log if it does not exist"
  task :create_production_log do
    unless File.exist?(File.join(shared_path, 'log', 'production.log'))
      puts "\n\n=== Creating Production Log! ===\n\n"
      run "touch #{File.join(shared_path, 'log', 'production.log')}"
    end
  end

  desc "Creates symbolic links from shared folder"
  task :setup_symlinks do
    puts "\n\n=== Setting up Symbolic Links! ===\n\n"
    symlinks.each do |config|
      run "ln -nfs #{File.join(shared_path, config[0])} #{File.join(release_path, config[1])}"
    end
  end

  desc "Sets up the shared path"
  task :setup_shared_path do
    puts "\n\n=== Setting up the shared path! ===\n\n"
    shared_dirs.each do |directory|
      run "mkdir -p #{shared_path}/#{directory}"
    end
  end

end

before 'deploy:setup', 'rvm:install_rvm', 'rvm:install_ruby'
after 'deploy:setup', 'deploy:setup_shared_path'
