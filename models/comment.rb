require_relative "database_connection"

class Comment < Sequel::Model(DatabaseConnection::DB)
end
