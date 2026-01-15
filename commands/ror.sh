bin/rails server
bin/rails generate controller Articles index --skip-routes
bin/rails generate model Article title:string body:text
bin/rails console
bin/rails db:migrate

article = Article.new(title: "Hello Rails", body: "I am on Rails!")
article.save
article
Article.find(1)
Article.all

bin/rails routes
