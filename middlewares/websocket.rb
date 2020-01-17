require "faye/websocket"
require "thread"
require "json"
require "erb"
require_relative "../models/database_connection"

class Websocket
  attr_reader :app, :clients

  def initialize(app)
    @app     = app
    @clients = []
    notify_clients_of_updates
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      socket = Faye::WebSocket.new(env, nil, { ping: 1 })

      # Save client when new websocket connection is established
      socket.on(:open) { |event| clients << socket }

      # Code goes here if we want to listen for messages from the clients
      socket.on(:message) {}

      # Clear client from clients list when websocket connection is closed
      socket.on :close do |event|
        clients.delete(socket)
        socket = nil
      end

      # Return async Rack response
      socket.rack_response
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

