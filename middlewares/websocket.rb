require "faye/websocket"
require "thread"
require "json"
require "erb"
require_relative "../models/database_connection"

class Websocket
  attr_reader :app, :clients

  KEEPALIVE_TIME = 2 # seconds

  def initialize(app)
    @app     = app
    @clients = []
    notify_clients_of_updates
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env, nil, { ping: KEEPALIVE_TIME })

      # Save client when new websocket connection is established
      ws.on(:open) { |event| clients << ws }

      # Code goes here if we want to listen for messages from the clients
      ws.on(:message) {}

      # Clear client from clients list when websocket connection is closed
      ws.on :close do |event|
        clients.delete(ws)
        ws = nil
      end

      # Return async Rack response
      ws.rack_response
    else
      app.call(env)
    end
  end

  private

  def notify_clients_of_updates
    Thread.new do
      DatabaseConnection.listen do |message|
        clients.each { |socket| socket.send(message) }
      end
    end
  end
end

