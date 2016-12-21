require( 'sinatra' )
require( 'pry-byebug')
require( 'sinatra/contrib/all' ) if development?
require_relative( '../models/product_class.rb' )
require_relative( '../db/sql_runner.rb' )

#get front end
get '/' do
  @products = Product.all()
  erb ( :"/index" )
end

#need to get custome id, now poduct been selected
get '/:id/buy' do
  @products = Product.all()
  erb ( :"/buy" )
end

#secret page to reload the table in database
get '/na157255c' do
  SqlRunner.reset('db/guppies.sql')
  SqlRunner.reset('db/guppies_seeds.sql')
  redirect to('/')
end