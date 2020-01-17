require "sequel"

class DatabaseConnection
  DATABASE_URL = ENV.fetch("DATABASE_URL", "postgres://localhost:5432/listen_development")
  DB = Sequel.connect(DATABASE_URL)

  def self.listen(&block)
    DB.listen('comments', loop: true) do |_channel, _pid, event_data|
      data = JSON.parse(event_data)
      yield data.dig("record", "body")
    end
  end
end
