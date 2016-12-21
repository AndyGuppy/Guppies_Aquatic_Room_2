require( 'sinatra' )
require( 'pry-byebug')
require( 'sinatra/contrib/all' ) if development?
require_relative( '../models/product_class.rb' )
require_relative( '../models/customer_class.rb' )
require_relative( '../db/sql_runner.rb' )


#get front end
get '/' do
  @products = Product.all()
  erb ( :"/index" )
end



get '/:id/buy' do
  @products = Product.all()
  erb ( :"/buy" )
end

get '/na157255c' do
  SqlRunner.reset('db/guppies.sql')
  SqlRunner.reset('db/guppies_seeds.sql')
  redirect to('/')

end