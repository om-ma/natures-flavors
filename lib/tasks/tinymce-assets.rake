require "tinymce/rails/asset_installer"

namespace :assets do

  desc 'tinymce assets'
  task :tinymce => :environment do
    assets = Pathname.new(File.expand_path(File.dirname(__FILE__) + "/../../vendor/assets/javascripts/tinymce"))
    
    config   = Rails.application.config
    target   = File.join(Rails.public_path, config.assets.prefix)
    manifest = config.assets.manifest
    
    installer = TinyMCE::Rails::AssetInstaller.new(assets, target, manifest)
    installer.log_level = Logger::INFO
    installer.strategy = config.tinymce.install
    installer.install
  end
end

assets_task = 'assets:precompile'

if Rake::Task.task_defined?(assets_task)
  Rake::Task[assets_task].enhance do
    Rake::Task["assets:tinymce"].invoke
  end
end
