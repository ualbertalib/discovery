namespace  :comfortable_mexican_sofa do
  desc "Create the UAlberta Site and import fixtures into the database"
  task :cmssetup  => :environment do
    ENV['FROM'] = 'db/cms_fixtures'
    ENV['TO']   = 'ualberta-libraries'

    Comfy::Cms::Site.create!(:identifier => 'ualberta-libraries', :hostname => 'localhost')

    Rake::Task['comfortable_mexican_sofa:fixtures:import'].invoke
  end
end
