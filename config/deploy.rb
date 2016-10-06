require "bundler/capistrano"

set :application, "artpolygraf"
set :repository,  "git@github.com:solenko/artpolygraf.git"
set :user, 'rubyon'
set :password, 'rubycon'

set :deploy_to, '/home/ruby/erp'

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "94.25.144.239"                          # Your HTTP server, Apache/etc
role :app, "94.25.144.239"                          # This may be the same as your `Web` server
role :db,  "94.25.144.239", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

after "deploy:update_code", "deploy:symlink_config"
# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end

  task :symlink_config, :roles => :app do
    run "ln -nsf #{shared_path}/config/database.yml #{current_release}/config"
    run "ln -sf #{shared_path}/pids #{current_release}/pids"
    run "ln -sf #{shared_path}/log #{current_release}/log"
    run "ln -sf #{shared_path}/dumps #{current_release}/dumps"
  end
end