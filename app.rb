require "sinatra"
require "sequel"
require "./models/comment"

class App < Sinatra::Base
  get "/" do
    erb :index, locals: { comments: Comment.order(Sequel.desc(:id)).limit(10) }
  end

  post "/comments" do
    if comment_attrs = params[:comment]
      Comment.create(comment_attrs)
    end

    status :ok
  end
end
