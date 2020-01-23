class Article
  attr_accessor :description, :title, :url

  def initialize(description, title, url)
    @description = description
    @title = title
    @url = url
  end



  def self.all
    sql_articles = nil

    db_connection do |connection_helper|
      sql_articles = connection_helper.exec("SELECT title, description, url FROM articles;")
    end

    articles_hashes = sql_articles.to_a

    articles=[]
    articles_hashes.each do |article_hash|
      articles << Article.new(article_hash["title"], article_hash["url"], article_hash["description"])
    end

    return articles
    # - alternative constructor class method
    # - does not accept an argument
    # - uses `SELECT` statement to retrieve all article records
    # - should return an array of newly created article objects
  end


  def self.create(article_params)
    # - utility class method AND alternate constructor: creates a new article record in our database
    # - accepts the parameters needed for a new Article record (this should come in from your form)
    # - uses an INSERT statement to create a new article record
    # - should return the newly persisted article object

    result = db_connection do |conn|
      conn.exec_params(
        "INSERT INTO articles (title, url, description) VALUES ($1, $2, $3)", [article_params["title"], article_params["url"], article_params["description"]]
      )
    end
  end

end

  # Non-Core
  # def self.find(id)
    # - this is an alternative constructor class method
    # - accepts an id as an argument
    # - uses a SELECT statement with a WHERE clause
    # - should returns a single article object whose id matches the given id
  # end
