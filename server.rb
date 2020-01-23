require "sinatra"
require "pg"
require "pry" if development? || test?
require "sinatra/reloader" if development?
require_relative "./app/models/article"

set :bind, '0.0.0.0'  # bind to all interfaces
set :views, File.join(File.dirname(__FILE__), "app", "views")

configure :development do
  set :db_config, { dbname: "news_aggregator_development" }
end

configure :test do
  set :db_config, { dbname: "news_aggregator_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

# Put your News Aggregator server.rb route code here

get "/" do
  redirect "/articles"
end

# get "/random" do
#   erb :random
# end

get "/articles" do
  @articles = Article.all
  erb :articles
end

get "/articles/new" do
  erb :new
end
#
# get "/articles/:id" do
#   @article
#
#   result = db_connection do |conn|
#     conn.exec("SELECT * FROM articles WHERE id=#{params["id"]}")
#   end
#
#   @article = result.to_a[0]
#   erb :show
# end

# def retrieve_id
#   @articles_array = []
#   articles_csv = CSV.readlines('articles.csv', headers:true)
#   articles_csv.each do |article|
#     @articles_array << Article.new(
#       article['description'], article['name'], article['URL'], article['id']
#     )
#   end
#   @articles_array
# end

post "/articles" do
  Article.create(params)
  redirect "/articles"
end
