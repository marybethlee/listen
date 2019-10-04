require "sequel"

class DatabaseConnection
  DB = Sequel.connect(ENV["DATABASE_URL"] || "postgres://localhost:5432/listen_development")

  def self.listen(timeout = 600, &block)
    DB.listen('comments', loop: true, timeout: timeout) do |_channel, _pid, event_data|
      data = JSON.parse(event_data)
      yield data.dig("record", "body")
    end
  end
end
