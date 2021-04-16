# frozen_string_literal: true

# Rakefile contains all the application-related tasks.

require_relative './system/application'

# Enable database component.
Application.start(:database)

# Enable logger componnent.
Application.start(:logger)

# Add existing Logger instance to DB.loggers collection.
Application['database'].loggers << Application['logger']

migrate =
  lambda do |version|
    # Enable Sequel migration extension.
    Sequel.extension(:migration)

    # Perform migrations based on migration files in a specified directory.
    Sequel::Migrator.apply(Application['database'], 'db/migrate', version)

    # Dump database schema after migration.
    Rake::Task['db:dump'].invoke
  end

namespace :db do
  desc 'Migrate the database.'
  task :migrate do
    migrate.call(nil)
  end

  desc 'Rolling back latest migration.'
  task :rollback do |_, _args|
    current_version = Application['database'].fetch('SELECT * FROM schema_info').first[:version]

    migrate.call(current_version - 1)
  end

  desc 'Dump database schema to file.'
  task :dump do
    # Dump database schema only in development environment.
    development = Application.env == 'development'

    sh %(pg_dump --schema-only --no-privileges --no-owner -s #{Application['database'].url} > db/structure.sql) if development
  end

  desc 'Seed database with test data.'
  task :seed do
    sh %(ruby db/seeds.rb)
  end
end

desc 'Generate project documentation using yard.'
task :docs do
  sh %(yard doc *.rb app/ lib/)
end
