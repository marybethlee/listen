require "sequel"
require_relative "../models/database_connection"

namespace :db do
  desc "Migrate database"
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run(
      DatabaseConnection::DB,
      "./migrations",
      use_transactions: true
    )
  end

  desc "Roll back the last migration on the database"
  task :rollback do
    Sequel.extension :migration

    current_version = DatabaseConnection::DB[:schema_info].first[:version]

    Sequel::Migrator.run(
      DatabaseConnection::DB,
      "./migrations",
      use_transactions: true,
      target: current_version - 1
    )
  end

  desc "Listen to comments channel"
  task :listen do
    DatabaseConnection.listen { |message| puts message }
  end
end
