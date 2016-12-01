

# # config valid only for current version of Capistrano
# lock '3.4.0'

# set :application, 'mitc'
# #set :repo_url, 'git@github.com:lincolnsmithy/medicaid_eligibility.git'
# set :repo_url, 'https://github.com/dchealthlink/MITC.git'
# set :rbenv_ruby, '2.0.0'

# # Default branch is :master
# # ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# # Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '~'

# # Default value for :scm is :git
# # set :scm, :git

# # Default value for :format is :pretty
# # set :format, :pretty

# # Default value for :log_level is :debug
# # set :log_level, :debug

# # Default value for :pty is false
# set :pty, true
# set :ssh_options, {
#   forward_agent: true,
#   auth_methods: ["publickey"],
#   keys: ["/var/lib/jenkins/.ssh/DCIM.pem"]
# }

# # Default value for :linked_files is []
# # set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# # Default value for linked_dirs is []
# # set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# # Default value for default_env is {}
# # set :default_env, { path: "/opt/ruby/bin:$PATH" }

# # Default value for keep_releases is 5
# # set :keep_releases, 5

# namespace :deploy do

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end

# end





#require "bundler/capistrano"
#equire "rvm/capistrano"

#server "54.89.99.32", :web, :app, :db, primary: true

# set :application, "MITC"
# set :user, "venumadhav"
# #set :port, 22
# set :deploy_to, "/home/venumadhav"
# set :deploy_via, :remote_cache
# set :use_sudo, false

# set :scm, "git"
# set :repository, "https://github.com/dchealthlink/MITC.git"
# set :branch, "master"


# # set :pty, true
# # set :ssh_options, {
# #   forward_agent: true
# # #  auth_methods: ["publickey"],
# #  # keys: ["/var/lib/jenkins/.ssh/DCIM.pem"]
# # }


# after "deploy", "deploy:cleanup" # keep only the last 5 releases

# namespace :deploy do
#   %w[start stop restart].each do |command|
#     desc "#{command} unicorn server"
#     task command.to_sym do
#     on roles :app, except: {no_release: true} do
#       run "/etc/init.d/unicorn_#{application} #{command}"
#     end
#   end
#   end

#   task :setup_config do
#     ofn roles :app do
#     sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
#     sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
#     run "mkdir -p #{shared_path}/config"
#     #put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
#     #puts "Now edit the config files in #{shared_path}."
#   end
#   end
#   after "deploy", "deploy:setup_config"

#   task :symlink_config do
#     on roles :app do
#     run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
#   end
#   end
#   after "deploy", "deploy:symlink_config"

#   desc "Make sure local git is in sync with remote." do
#   task :check_revision do
#   on roles :web do
#     unless `git rev-parse HEAD` == `git rev-parse origin/master`
#       puts "WARNING: HEAD is not the same as origin/master"
#       puts "Run `git push` to sync changes."
#       exit
#     end
#   end
#   end
#   before "deploy", "deploy:check_revision"
# end
# end


# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'mitc'
set :repo_url, 'https://github.com/dchealthlink/MITC.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
#set :deploy_to, '/var/www/deployments/hbx_mitc'
set :deploy_to, '~/mitc'
set :rails_env, 'production'

# Default value for :scm is :git
# set :scm, :git
# set :scm, :gitcopy

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug
set :bundle_binstubs, false
set :bundle_flags, "--quiet"
set :bundle_path, nil

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
#set :linked_files, (fetch(:linked_files, []) | ['config/unicorn.rb', , 'Gemfile'])

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'pids', 'eye')

# capistrano/rails setup
set :assets_roles, [:web, :app]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# FIXME: Fix when assets are generated and linked

namespace :assets do
  desc "Kill all the assets"
  task :refresh do
    on roles(:web) do
#      execute "rm -rf #{shared_path}/public/assets/*"
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "assets:precompile"
        end
      end
    end
  end
end
after "deploy:updated", "assets:refresh"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 20 do
     # web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
      run "/etc/init.d/unicorn_#{application} restart"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

end

after "deploy:publishing", "deploy:restart"