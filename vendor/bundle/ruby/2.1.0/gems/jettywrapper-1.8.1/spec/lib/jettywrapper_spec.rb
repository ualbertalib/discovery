require 'spec_helper'
require 'rubygems'

  describe Jettywrapper do
    
    # JETTY1 = 
    before(:all) do
      @jetty_params = {
        :quiet => false,
        :jetty_home => "/path/to/jetty",
        :jetty_port => TEST_JETTY_PORTS.first,
        :solr_home => "/path/to/solr",
        :startup_wait => 0,
        :java_opts => ["-Xmx256m"],
        :jetty_opts => ["/path/to/jetty_xml", "/path/to/other_jetty_xml"]  
      }

      Jettywrapper.logger.level=3
    end

    before do
      Jettywrapper.reset_config
    end

    context "downloading" do
      context "with default file" do
        it "should download the zip file" do
          Jettywrapper.should_receive(:system).with('curl -L https://github.com/projecthydra/hydra-jetty/archive/v7.0.0.zip -o tmp/v7.0.0.zip').and_return(system ('true'))
          Jettywrapper.download
        end
      end

      context "specifying the file" do
        it "should download the zip file" do
          Jettywrapper.should_receive(:system).with('curl -L http://example.co/file.zip -o tmp/file.zip').and_return(system ('true'))
          Jettywrapper.download('http://example.co/file.zip')
          Jettywrapper.url.should == 'http://example.co/file.zip'
        end
      end
      context "specifying the version" do
        it "should download the zip file" do
          Jettywrapper.should_receive(:system).with('curl -L https://github.com/projecthydra/hydra-jetty/archive/v9.9.9.zip -o tmp/v9.9.9.zip').and_return(system ('true'))
          Jettywrapper.hydra_jetty_version = 'v9.9.9'
          Jettywrapper.download
        end
      end
    end

    context "unzip" do
      before do
        Jettywrapper.url = nil
      end
      context "with default file" do
        it "should download the zip file" do
          File.should_receive(:exists?).and_return(true)
          Jettywrapper.should_receive(:expanded_zip_dir).and_return('tmp/jetty_generator/hydra-jetty-v7.0.0')
          Jettywrapper.should_receive(:system).with('unzip -d tmp/jetty_generator -qo tmp/v7.0.0.zip').and_return(system ('true'))
          Jettywrapper.should_receive(:system).with('rm -r jetty').and_return(system ('true'))
          Jettywrapper.should_receive(:system).with('mv tmp/jetty_generator/hydra-jetty-v7.0.0 jetty').and_return(system ('true'))
          Jettywrapper.unzip
        end
      end

      context "specifying the file" do
        before do
          Jettywrapper.url = 'http://example.co/file.zip'
        end
        it "should download the zip file" do
          File.should_receive(:exists?).and_return(true)
          Jettywrapper.should_receive(:expanded_zip_dir).and_return('tmp/jetty_generator/interal_dir')
          Jettywrapper.should_receive(:system).with('unzip -d tmp/jetty_generator -qo tmp/file.zip').and_return(system ('true'))
          Jettywrapper.should_receive(:system).with('rm -r jetty').and_return(system ('true'))
          Jettywrapper.should_receive(:system).with('mv tmp/jetty_generator/interal_dir jetty').and_return(system ('true'))
          Jettywrapper.unzip
        end
      end
    end

    context ".url" do
      before do
        subject.url = nil
      end
      subject {Jettywrapper}
      context "When a constant is set" do
        before do
          ZIP_URL = 'http://example.com/foo.zip'
        end
        after do
          Object.send(:remove_const, :ZIP_URL)
        end
        its(:url) {should == 'http://example.com/foo.zip'}
      end
      context "when a url is set" do
        before do
          subject.url = 'http://example.com/bar.zip'
        end
        its(:url) {should == 'http://example.com/bar.zip'}
      end
      context "when url is not set" do
        its(:url) {should == 'https://github.com/projecthydra/hydra-jetty/archive/v7.0.0.zip'}
      end
    end

    context ".tmp_dir" do
      subject {Jettywrapper}
      context "when a dir is set" do
        before do
          subject.tmp_dir = '/opt/tmp'
        end
        its(:tmp_dir) {should == '/opt/tmp'}
      end
      context "when dir is not set" do
        before do
          subject.tmp_dir = nil
        end
        its(:tmp_dir) {should == 'tmp'}
      end

    end

    context ".jetty_dir" do
      subject {Jettywrapper}
      context "when a dir is set" do
        before do
          subject.jetty_dir = '/opt/jetty'
        end
        its(:jetty_dir) {should == '/opt/jetty'}
      end
      context "when dir is not set" do
        before do
          subject.jetty_dir = nil
        end
        its(:jetty_dir) {should == 'jetty'}
      end
    end

    context "app_root" do
      subject {Jettywrapper}
      context "When rails is present" do
        before do
          class Rails
            def self.root
              'rails_root'
            end
          end
        end
        after do
          Object.send(:remove_const, :Rails)
        end
        its(:app_root) {should == 'rails_root'}
      end
      context "When APP_ROOT is set" do
        before do
          APP_ROOT = 'custom_root'
        end
        after do
          Object.send(:remove_const, :APP_ROOT)
        end
        its(:app_root) {should == 'custom_root'}
      end
      context "otherwise" do
        its(:app_root) {should == '.'}
      end
    end
    
    describe "env" do
      before do
        ENV.delete('JETTYWRAPPER_ENV')
        ENV.delete('RAILS_ENV')
        ENV.delete('environment')
      end
      
      it "should have a setter" do
        Jettywrapper.env = "abc"
        expect(Jettywrapper.env).to eq "abc"  
      end
      
      it "should load the ENV['JETTYWRAPPER_ENV']" do
        ENV['JETTYWRAPPER_ENV'] = 'test'
        ENV['RAILS_ENV'] = 'test2'
        ENV['environment'] = 'test3'
        expect(Jettywrapper.env).to eq "test"
      end
      
      it "should be the Rails environment" do
        Rails = double(env: 'test')
        expect(Jettywrapper.env).to eq "test"
      end
      
      it "should use the ENV['RAILS_ENV']" do
        ENV['RAILS_ENV'] = 'test2'
        ENV['environment'] = 'test3'
        expect(Jettywrapper.env).to eq "test2"
      end
      
      it "should load the ENV['environment']" do
        ENV['environment'] = 'test3'
        expect(Jettywrapper.env).to eq "test3"
      end
      
      it "should default to 'development'" do
        expect(Jettywrapper.env).to eq "development"
      end
      
    end

    context "config" do
      before do
      end
      it "loads the application jetty.yml first" do
        IO.should_receive(:read).with('./config/jetty.yml').and_return("default:\n")
        config = Jettywrapper.load_config
      end

      it "loads the application jetty.yml using erb parsing" do
        IO.should_receive(:read).with('./config/jetty.yml').and_return("default:\n  a: <%= 123 %>")
        config = Jettywrapper.load_config
        config[:a] == 123
      end

      it "falls back on the distributed jetty.yml" do
        File.should_receive(:exists?).with('./config/jetty.yml').and_return(false)
        IO.should_receive(:read).with { |value| value =~ /jetty.yml/ }.and_return("default:\n")
        config = Jettywrapper.load_config
      end

      it "supports per-environment configuration" do
        ENV['environment'] = 'test'
        IO.should_receive(:read).with('./config/jetty.yml').and_return("default:\n  a: 1\ntest:\n  a: 2")
        config = Jettywrapper.load_config
        config[:a].should == 2
      end

      it "should take the env as an argument to load_config and the env should be sticky" do
        IO.should_receive(:read).with('./config/jetty.yml').and_return("default:\n  a: 1\nfoo:\n  a: 2")
        config = Jettywrapper.load_config('foo')
        config[:a].should == 2
        expect(Jettywrapper.env).to eq 'foo'
      end

      it "falls back on a 'default' environment configuration" do
        ENV['environment'] = 'test'
        IO.should_receive(:read).with('./config/jetty.yml').and_return("default:\n  a: 1")
        config = Jettywrapper.load_config
        config[:a].should == 1
      end
    end
    
    context "instantiation" do
      it "can be instantiated" do
        ts = Jettywrapper.instance
        ts.class.should eql(Jettywrapper)
      end

      it "can be configured with a params hash" do
        ts = Jettywrapper.configure(@jetty_params) 
        ts.quiet.should == false
        ts.jetty_home.should == "/path/to/jetty"
        ts.port.should == @jetty_params[:jetty_port]
        ts.solr_home.should == '/path/to/solr'
        ts.startup_wait.should == 0
        ts.jetty_opts.should == @jetty_params[:jetty_opts]
      end

      it "should override nil params with defaults" do
        jetty_params = {
          :quiet => nil,
          :jetty_home => '/path/to/jetty',
          :jetty_port => nil,
          :solr_home => nil,
          :startup_wait => nil,
          :jetty_opts => nil
        }

        ts = Jettywrapper.configure(jetty_params) 
        ts.quiet.should == true
        ts.jetty_home.should == "/path/to/jetty"
        ts.port.should == 8888
        ts.solr_home.should == File.join(ts.jetty_home, "solr")
        ts.startup_wait.should == 5
        ts.jetty_opts.should == []
      end
      
      it "passes all the expected values to jetty during startup" do
        ts = Jettywrapper.configure(@jetty_params) 
        command = ts.jetty_command
        command.should include("-Dsolr.solr.home=#{@jetty_params[:solr_home]}")
        command.should include("-Djetty.port=#{@jetty_params[:jetty_port]}")
        command.should include("-Xmx256m")
        command.should include("start.jar")
        command.slice(command.index('start.jar')+1, 2).should == @jetty_params[:jetty_opts]
      end

      it "escapes the :solr_home parameter" do
        ts = Jettywrapper.configure(@jetty_params.merge(:solr_home => '/path with spaces/to/solr'))
        command = ts.jetty_command
        command.should include("-Dsolr.solr.home=/path\\ with\\ spaces/to/solr")
      end
      
      it "has a pid if it has been started" do
        jetty_params = {
          :jetty_home => '/tmp'
        }
        ts = Jettywrapper.configure(jetty_params) 
        Jettywrapper.any_instance.stub(:process).and_return(double('proc', :start => nil, :pid=>5454))
        ts.stop
        ts.start
        ts.pid.should eql(5454)
        ts.stop
      end
      
      it "can pass params to a start method" do
        jetty_params = {
          :jetty_home => '/tmp', :jetty_port => 8777
        }
        ts = Jettywrapper.configure(jetty_params) 
        ts.stop
        Jettywrapper.any_instance.stub(:process).and_return(double('proc', :start => nil, :pid=>2323))
        swp = Jettywrapper.start(jetty_params)
        swp.pid.should eql(2323)
        swp.pid_file.should eql("_tmp_test.pid")
        swp.stop
      end
      
      it "can get the status for a given jetty instance" do
        # Don't actually start jetty, just fake it
        Jettywrapper.any_instance.stub(:process).and_return(double('proc', :start => nil, :pid=>12345))
        
        jetty_params = {
          :jetty_home => File.expand_path("#{File.dirname(__FILE__)}/../../jetty")
        }
        Jettywrapper.stop(jetty_params)
        Jettywrapper.is_jetty_running?(jetty_params).should eql(false)
        Jettywrapper.start(jetty_params)
        Jettywrapper.is_jetty_running?(jetty_params).should eql(true)
        Jettywrapper.stop(jetty_params)
      end
      
      it "can get the pid for a given jetty instance" do
        # Don't actually start jetty, just fake it
        Jettywrapper.any_instance.stub(:process).and_return(double('proc', :start => nil, :pid=>54321))
        jetty_params = {
          :jetty_home => File.expand_path("#{File.dirname(__FILE__)}/../../jetty")
        }
        Jettywrapper.stop(jetty_params)
        Jettywrapper.pid(jetty_params).should eql(nil)
        Jettywrapper.start(jetty_params)
        Jettywrapper.pid(jetty_params).should eql(54321)
        Jettywrapper.stop(jetty_params)
      end
      
      it "can pass params to a stop method" do
        jetty_params = {
          :jetty_home => '/tmp', :jetty_port => 8777
        }
        Jettywrapper.any_instance.stub(:process).and_return(double('proc', :start => nil, :pid=>2323))
        swp = Jettywrapper.start(jetty_params)
        (File.file? swp.pid_path).should eql(true)
        
        swp = Jettywrapper.stop(jetty_params)
        (File.file? swp.pid_path).should eql(false)
      end
      
      describe "creates a pid file" do
        let(:ts) { Jettywrapper.configure(@jetty_params) }
        describe "when the environment isn't set" do
          before { ENV['environment'] = nil }
          it "should have the path and env in the name" do
            ts.pid_file.should eql("_path_to_jetty_development.pid")
          end
        end
        describe "when the environment is set" do
          before { ENV['environment'] = 'test' }
          it "should have the path and env in the name" do
            ts.pid_file.should eql("_path_to_jetty_test.pid")
          end
        end
      end
      
      it "knows where its pid file should be written" do
        ts = Jettywrapper.configure(@jetty_params) 
        ts.pid_dir.should eql(File.expand_path("#{ts.base_path}/tmp/pids"))
      end
      
      it "writes a pid to a file when it is started" do
        jetty_params = {
          :jetty_home => '/tmp'
        }
        ts = Jettywrapper.configure(jetty_params) 
        Jettywrapper.any_instance.stub(:process).and_return(double('proc', :start => nil, :pid=>2222))
        ts.stop
        ts.pid_file?.should eql(false)
        ts.start
        ts.pid.should eql(2222)
        ts.pid_file?.should eql(true)
        pid_from_file = File.open( ts.pid_path ) { |f| f.gets.to_i }
        pid_from_file.should eql(2222)
      end
      
    end # end of instantiation context
    
    context "logging" do
      it "has a logger" do
        ts = Jettywrapper.configure(@jetty_params) 
        ts.logger.should be_kind_of(Logger)
      end
      
    end # end of logging context 
    
    context "wrapping a task" do
      it "wraps another method" do
        Jettywrapper.any_instance.stub(:start).and_return(true)
        Jettywrapper.any_instance.stub(:stop).and_return(true)
        error = Jettywrapper.wrap(@jetty_params) do            
        end
        error.should eql(false)
      end
      
      it "configures itself correctly when invoked via the wrap method" do
        Jettywrapper.any_instance.stub(:start).and_return(true)
        Jettywrapper.any_instance.stub(:stop).and_return(true)
        error = Jettywrapper.wrap(@jetty_params) do 
          ts = Jettywrapper.instance 
          ts.quiet.should == @jetty_params[:quiet]
          ts.jetty_home.should == "/path/to/jetty"
          ts.port.should == @jetty_params[:jetty_port]
          ts.solr_home.should == "/path/to/solr"
          ts.startup_wait.should == 0   
        end
        error.should eql(false)
      end
      
      it "captures any errors produced" do
        Jettywrapper.any_instance.stub(:start).and_return(true)
        Jettywrapper.any_instance.stub(:stop).and_return(true)
        Jettywrapper.instance.logger.should_receive(:error).with("*** Error starting jetty: this is an expected error message")
        expect { error = Jettywrapper.wrap(@jetty_params) do 
          raise "this is an expected error message"
        end }.to raise_error "this is an expected error message"
      end
      
    end # end of wrapping context

    context "quiet mode", :quiet => true do
      it "inherits the current stderr/stdout in 'loud' mode" do
        ts = Jettywrapper.configure(@jetty_params.merge(:quiet => false))
        process = ts.process
        process.io.stderr.should == $stderr
        process.io.stdout.should == $stdout
      end

      it "redirect stderr/stdout to a log file in quiet mode" do
        ts = Jettywrapper.configure(@jetty_params.merge(:quiet => true))
        process = ts.process
        process.io.stderr.should_not == $stderr
        process.io.stdout.should_not == $stdout
      end
    end
  end
