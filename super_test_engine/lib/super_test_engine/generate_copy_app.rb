#!/usr/bin/env ruby

super_development_path = File.expand_path("../../..", __dir__)
if File.exist?(File.join(super_development_path, "super.gemspec"))
  super_lib_path = File.join(super_development_path, "lib")

  $LOAD_PATH.unshift(super_lib_path) if !$LOAD_PATH.include?(super_lib_path)
end

require "rails/generators"
require "generators/super/install/install_generator"

class SuperCopyAppGenerator < Rails::Generators::Base
  source_root(File.expand_path("copy_app_templates", __dir__))

  class_option :destination, required: true

  def set_destination_root
    self.destination_root = options[:destination]
  end

  def ensure_reasonable_directory
    app_path = File.join(destination_root, "app")
    if !File.directory?(app_path)
      raise "Can't find dir: #{app_path}"
    end
  end

  def install_super
    Super::InstallGenerator.start([], destination_root: destination_root)
  end

  def copy_app
    directory "models", "app/models"
    directory "controllers", "app/controllers/admin"
    directory "views/members", "app/views/admin/members"
  end

  def copy_db
    directory "migrations", "db/migrate"
    copy_file "seeds.rb", "db/seeds.rb"
  end

  def copy_config
    copy_file "routes.rb", "config/routes.rb"
  end
end

SuperCopyAppGenerator.start
