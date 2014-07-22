# Note: These rake tasks are here mainly as examples to follow. You're going to want
# to write your own rake tasks that use the locations of your jetty instances. 

require 'jettywrapper'

namespace :jettywrapper do
  
  jetty = {
    :jetty_home => File.expand_path("#{File.dirname(__FILE__)}/../jetty"),
    :jetty_port => "8983", :java_opts=>["-Xmx128mb"]
  }
  
  desc "Return the status of jetty"
  task :status do
    status = Jettywrapper.is_jetty_running?(jetty) ? "Running: #{Jettywrapper.pid(jetty)}" : "Not running"
    puts status
  end
  
  desc "Start jetty"
  task :start do
    Jettywrapper.start(jetty)
    puts "jetty started at PID #{Jettywrapper.pid(jetty)}"
  end
  
  desc "stop jetty"
  task :stop do
    Jettywrapper.stop(jetty)
    puts "jetty stopped"
  end
  
  desc "Restarts jetty"
  task :restart do
    Jettywrapper.stop(jetty)
    Jettywrapper.start(jetty)
  end

  desc "Init Hydra configuration" 
  task :init => [:environment] do
    if !ENV["environment"].nil? 
      RAILS_ENV = ENV["environment"]
    end
    
    JETTY_HOME_TEST = File.expand_path(File.dirname(__FILE__) + '/../../jetty-test')
    JETTY_HOME_DEV = File.expand_path(File.dirname(__FILE__) + '/../../jetty-dev')
    
    JETTY_PARAMS_TEST = {
      :quiet => ENV['HYDRA_CONSOLE'] ? false : true,
      :jetty_home => JETTY_HOME_TEST,
      :jetty_port => 8983,
      :solr_home => File.expand_path(JETTY_HOME_TEST + '/solr'),
      :fedora_home => File.expand_path(JETTY_HOME_TEST + '/fedora/default')
    }

    JETTY_PARAMS_DEV = {
      :quiet => ENV['HYDRA_CONSOLE'] ? false : true,
      :jetty_home => JETTY_HOME_DEV,
      :jetty_port => 8984,
      :solr_home => File.expand_path(JETTY_HOME_DEV + '/solr'),
      :fedora_home => File.expand_path(JETTY_HOME_DEV + '/fedora/default')
    }
    
    # If Fedora Repository connection is not already initialized, initialize it using ActiveFedora defaults
    ActiveFedora.init unless Thread.current[:repo]  
  end

  desc "Copies the default SOLR config for the bundled jetty"
  task :config_solr => [:init] do
    FileList['solr/conf/*'].each do |f|  
      cp("#{f}", JETTY_PARAMS_TEST[:solr_home] + '/conf/', :verbose => true)
      cp("#{f}", JETTY_PARAMS_DEV[:solr_home] + '/conf/', :verbose => true)
    end
  end
  
  desc "Copies a custom fedora config for the bundled jetty"
  task :config_fedora => [:init] do
    fcfg = 'fedora/conf/fedora.fcfg'
    if File.exists?(fcfg)
      puts "copying over fedora.fcfg"
      cp("#{fcfg}", JETTY_PARAMS_TEST[:fedora_home] + '/server/config/', :verbose => true)
      cp("#{fcfg}", JETTY_PARAMS_DEV[:fedora_home] + '/server/config/', :verbose => true)
    else
      puts "#{fcfg} file not found -- skipping fedora config"
    end
  end
  
  desc "Copies the default Solr & Fedora configs into the bundled jetty"
  task :config do
    Rake::Task["hydra:jetty:config_fedora"].invoke
    Rake::Task["hydra:jetty:config_solr"].invoke
  end
end
