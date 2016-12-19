require( 'sinatra' )
require( 'pry-byebug')
require( 'sinatra/contrib/all' ) if development?
require_relative( '../models/product_class.rb' )
require_relative( '../models/customer_class.rb' )


#get front end
get '/' do
  @products = Product.all()
  erb ( :"/index" )
end



get '/:id/buy' do
  @products = Product.all()
  erb ( :"/buy" )
end

